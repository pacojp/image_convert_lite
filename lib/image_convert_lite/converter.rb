# -*- coding: utf-8 -*-

require 'image_size'
require 'exifr'

module ImageConvertLite
  class Converter

    attr_accessor :workspace,:convert_bin,:debug

    def initialize(attrs)
      self.workspace   = attrs[:workspace]
      self.convert_bin = attrs[:convert_bin]
      self.debug       = attrs[:debug]
      raise ArgumentError,'must set :workspace'   unless self.workspace
      raise ArgumentError,'must set :convert_bin' unless self.convert_bin
      raise ArgumentError,":workspace(#{self.workspace}) must be directory" unless File.directory?(self.workspace)
      raise ArgumentError,":convert_bin must be file" unless File.exists?(self.convert_bin)
    end

    #
    # attrs
    #
    # :file 変換対象ファイル(ファイルパス)
    # :width 幅
    # :height 高さ
    # # :max_width と :max_heidhtは同時に指定しないとだめ（片方で指定すると -resize 100x> 普通にリサイズしちゃうので）
    # :max_width 最大幅
    # :max_height 最大高
    # :crop クロップ
    # :feature_phone 縦長かつ240x320にリサイズ（:widthを指定した場合はそれに準ずる）
    #
    def convert(attrs)
      raise ArgumentError, 'attrs must be hash' unless attrs.kind_of?(Hash)
      data,file_path_from,file_path_to = target_file(attrs)
      isize = ImageSize.new(data)
      # 画像以外はスキップ
      raise ArgumentError, 'not image file' unless isize.format
      convert_inner(data,isize,file_path_from,file_path_to,attrs)
      file_path_to
    end

    private

    def millsec_st
      Time.now.instance_eval { strftime('%Y%m%d%H%M%S') + usec.to_s.rjust(6,'0') }
    end

    def target_file(attrs)
      # TODO データは :file か :blob で渡せるようにしたいね
      if attrs.keys.include?(:file)
        f = attrs.delete(:file)
        raise ArgumentError, ':file option must be file' unless File.exists?(f)
        raise ArgumentError, ':file option must be file' if File.directory?(f)
        # ちなみにdp2merrillが20M程度のjpgを吐くそう
        raise ArgumentError, 'file size too big(bigger than 25M)' if File.size(f) > 30_000_000
        f_new = File.expand_path(self.workspace + '/' + File.basename(f)) + ".#{Process.pid}.#{millsec_st}.#{attrs_to_s(attrs)}.jpg"
        data = File.binread(f)
        return data,f,f_new
      end
      raise ArgumentError,'attrs must have :file option'
    end

    def attrs_to_s(attrs)
      attrs.to_a.flatten.join('_')
    end

    def convert_inner(data,isize,file,file_to,attrs)
      command = []
      resize  = false

      target_width  = attrs[:max_width]
      target_width  ||= attrs[:width]
      target_height = attrs[:max_height]
      target_height ||= attrs[:height]

      if attrs[:crop]
        crop_size = isize.height > isize.width ? isize.width : isize.height
        command << "-gravity center -crop #{crop_size}x#{crop_size}+0+0 +repage"
      end

      set_max_wh = (attrs.keys & [:max_width,:max_height]).size
      set_wh     = (attrs.keys & [:width,:height]).size
      case set_max_wh
      when 1
        raise ArgumentError,':max_width and :max_height both must be set'
      when 2
        if set_wh > 0
          raise ArgumentError,'can not set :width or :height if :max_width or :max_height is set'
        end
        command << "-resize #{attrs[:max_width]}x#{attrs[:max_height]}\\>"
        resize = true
      else
        # 携帯向け処理をする場合は後で処理するのでOK
        if set_wh > 0 && !attrs[:feature_phone]
          command << "-resize #{attrs[:width]}x#{attrs[:height]}"
          resize = true
        end
      end

      if resize
        # http://blog.mirakui.com/entry/20110123/1295795409
        # -define jpeg:size=180x120
        # とりあえず出力はjpg一本なので
        command.unshift("-define jpg:size=#{target_width}x#{target_height} ")
      end

      converted = false
      if command.size > 0
        cmd = "#{self.convert_bin} #{file} -auto-orient -strip -quality 98 #{command.join(' ')} #{file_to}"
        puts cmd if self.debug
        `#{cmd}`
        converted = true
      end

      if attrs[:feature_phone]
        if converted
          from = file_to
          isize_target = ImageSize.new(File.binread(file_to))
        else
          from = file
          isize_target = isize
        end

        rotate = isize_target.width > isize_target.height

        # 変換済みでない場合はexif縦画像な可能性があるので
        # ＆
        # exifはあるけどorientationがない場合もあるので
        unless converted
          if exif = EXIFR::JPEG::new(StringIO.new(data))
            if exif.orientation
              rotate = exif.orientation.to_i != 6
            end
          end
        end

        height = 320
        width  = 240
        if w = attrs[:width]
          rate   = w.to_f / 240.to_f
          height = (rate * 320.to_f).to_i
          width  = (rate * 240.to_f).to_i
        end
        #cmd = "#{self.convert_bin} #{from} -auto-orient -strip -quality 98  #{rotate ? '-rotate 90' : ''} -resize #{width}x#{height}\\> #{file_to}"
        cmd = "#{self.convert_bin} #{from} -auto-orient -strip -quality 98  #{rotate ? '-rotate 90' : ''} -resize #{width}x#{height} #{file_to}"
        puts cmd if self.debug
        `#{cmd}`
      end
    end
  end
end
