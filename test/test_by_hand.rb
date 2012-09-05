# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__)) + '/test_helper.rb'

test_seed_dir = File.dirname(__FILE__) + '/seed/**/*'
workspace = File.dirname(__FILE__) + '/workspace/'
convert   = '/usr/local/bin/convert'

Dir::glob(test_seed_dir).each do |f|
  puts "#{f}: #{File::stat(f).size} bytes"
  converter = ImageConvertLite::Converter.new(:workspace=>workspace,:convert_bin=>convert)
  begin
    converter.convert({:file=>f,:width=>6000,:height=>1000})
    converter.convert({:file=>f,:max_width=>6000,:max_height=>1000})
    converter.convert({:file=>f,:max_width=>300,:max_height=>300})
    converter.convert({:file=>f,:width=>200})
    converter.convert({:file=>f,:crop=>true})
    converter.convert({:file=>f,:crop=>true,:width=>200,:heitht=>200})
    converter.convert({:file=>f,:crop=>true,:max_width=>200,:max_height=>200})
    converter.convert({:file=>f,:max_width=>200,:max_height=>200})
    converter.convert({:file=>f,:feature_phone=>true})
    converter.convert({:file=>f,:width=>480,:feature_phone=>true})
    converter.convert({:file=>f,:crop=>true,:width=>480,:feature_phone=>true})

  rescue => e
    puts e.message
  end
end

# TODO thread_safeじゃないのでparallelでもforkのサンプルで書く
