
# 概要

何度も書いてはどこに行ったかわからなくなるImageMagickのラッパーを真面目にgem化しようと思い立ちました

## スレッドセーフでは無いです(not thread_safe)

### テストは以下の感じで
ruby test/test.rb

### コーディングしながらのテストの場合は
bundle exec ruby test/test_by_hand.rb

### いじるときはこんなかんじで
watchr -e 'watch( "(.*)/(.*)\.rb" ){|md| system("bundle exec ruby test/test_by_hand.rb")}'

### テストをいじるときはこんなかんじで
watchr -e 'watch( "(.*)/(.*)\.rb" ){|md| system("ruby test/test.rb")}'
