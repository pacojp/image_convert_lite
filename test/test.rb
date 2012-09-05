# -*- coding: utf-8 -*-

$: << File.dirname(__FILE__)
require 'test_helper'
require 'test/unit'

require 'image_size'
require 'exifr'

#
# TODO 画像が横向いているかの確認は、、、、どうするんだろう、、、
#

class TestImageConvertLite < Test::Unit::TestCase
  def setup
    @test_seed_dir = File.dirname(__FILE__) + '/seed/'
    @workspace  = File.dirname(__FILE__) + '/workspace/'
    @convert    = '/usr/local/bin/convert'
    @converter  = ImageConvertLite::Converter.new(:workspace=>@workspace,:convert_bin=>@convert)
  end

  # def teardown
  # end

  def test_non_image
    # 画像じゃなーい
    non_img    = @test_seed_dir + 'non_image.mp3'
    assert_raise(ArgumentError) do
      @converter.convert(:file=>non_img,:width=>6000,:height=>1000)
    end
  end

  # exifが消えることを確認
  def test_exif_gone
    img  = @test_seed_dir + 'tate.r6.jpg'
    result = @converter.convert(:file=>img,:width=>6000,:height=>1000)
    exif = EXIFR::JPEG::new(result)
    assert_equal(exif.exif,nil)
  end

  def convert_test(attrs,width,height)
    result = @converter.convert(attrs)
    isize  = ImageSize.new(File.binread(result))
    #assert_equal(isize.width,width)
    #assert_equal(isize.height,height)
    isize.width == width && isize.height == height
  end

  def test_tate
    # 400 ×1200
    img = @test_seed_dir + 'tate.jpg'
    result = @converter.convert(:file=>img,:width=>6000,:height=>1000)

    assert_block do
      convert_test(
        {:file=>img,:width=>6000,:height=>1000},
        333,1000
      )
    end

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,333)
    assert_equal(isize.height,1000)

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>2000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,400)
    assert_equal(isize.height,1200)

    result = @converter.convert(:file=>img,:max_width=>300,:max_height=>300)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,100)
    assert_equal(isize.height,300)

    result = @converter.convert(:file=>img,:crop=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,400)
    assert_equal(isize.height,400)

    result = @converter.convert(:file=>img,:crop=>true,:width=>200,:height=>200)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,200)
    assert_equal(isize.height,200)

    result = @converter.convert(:file=>img,:feature_phone=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,107)
    assert_equal(isize.height,320)

    result = @converter.convert(:file=>img,:feature_phone=>true,:width=>480)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,213)
    assert_equal(isize.height,640)
  end

  def test_tate_r6
    # 1224 x 1632(exifでのローテーションあり)
    img  = @test_seed_dir + 'tate.r6.jpg'

    result = @converter.convert(:file=>img,:width=>6000,:height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,750)
    assert_equal(isize.height,1000)

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,750)
    assert_equal(isize.height,1000)

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>2000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1224)
    assert_equal(isize.height,1632)

    result = @converter.convert(:file=>img,:max_width=>300,:max_height=>300)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,225)
    assert_equal(isize.height,300)

    result = @converter.convert(:file=>img,:crop=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1224)
    assert_equal(isize.height,1224)

    result = @converter.convert(:file=>img,:crop=>true,:width=>200,:height=>200)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,200)
    assert_equal(isize.height,200)

    result = @converter.convert(:file=>img,:feature_phone=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,240)
    assert_equal(isize.height,320)

    result = @converter.convert(:file=>img,:feature_phone=>true,:width=>480)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,480)
    assert_equal(isize.height,640)
  end

  def test_yoko
    # 1632 ×1224
    img   = @test_seed_dir + 'yoko.jpg'

    result = @converter.convert(:file=>img,:width=>6000,:height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1333)
    assert_equal(isize.height,1000)

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>1000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1333)
    assert_equal(isize.height,1000)

    result = @converter.convert(:file=>img,:max_width=>6000,:max_height=>2000)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1632)
    assert_equal(isize.height,1224)

    result = @converter.convert(:file=>img,:max_width=>300,:max_height=>300)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,300)
    assert_equal(isize.height,225)

    result = @converter.convert(:file=>img,:crop=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,1224)
    assert_equal(isize.height,1224)

    result = @converter.convert(:file=>img,:crop=>true,:width=>200,:height=>200)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,200)
    assert_equal(isize.height,200)

    result = @converter.convert(:file=>img,:feature_phone=>true)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,240)
    assert_equal(isize.height,320)

    result = @converter.convert(:file=>img,:feature_phone=>true,:width=>480)
    isize  = ImageSize.new(File.binread(result))
    assert_equal(isize.width,480)
    assert_equal(isize.height,640)
  end
end
