# -*- coding: utf-8 -*-

$: << File.dirname(__FILE__)
require 'test_helper'
require 'test/unit'

require 'image_size'
require 'exifr'

class TestImageConvertLite < Test::Unit::TestCase
  def setup
    @test_seed_dir = File.dirname(__FILE__) + '/seed/'
    @workspace  = File.dirname(__FILE__) + '/workspace/'
    @convert    = '/usr/local/bin/convert'
    @converter  = ImageConvertLite::Converter.new(:workspace=>@workspace,:convert_bin=>@convert)

    # 画像じゃなーい
    @non_img    = @test_seed_dir + 'non_image.mp3'

    # 400 ×1200
    @img_tate   = @test_seed_dir + 'tate.jpg'

    # 1632 ×1224
    @img_yoko   = @test_seed_dir + 'yoko.jpg'

    # 1224 x 1632(exifでのローテーションあり)
    @img_tate_r6  = @test_seed_dir + 'tate.r6.jpg'
  end

  # def teardown
  # end

  def test_non_image
    assert_raise(ArgumentError) do
      @converter.convert(:file=>@non_img,:width=>6000,:height=>1000)
    end
  end

  # exifが消えることを確認
  def test_exif_gone
    result = @converter.convert(:file=>@img_tate_r6,:width=>6000,:height=>1000)
    exif = EXIFR::JPEG::new(result)
    assert_equal(exif.exif,nil)
  end

  def test_a
    # TODO テストづくり
    result = @converter.convert(:file=>@img_tate,:width=>6000,:height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.height,1000)
    assert_equal(isize.width,333)
  end
end
