
# Version: ImageMagick 6.7.7-6 2012-07-20 Q16 http://www.imagemagick.org

#
# tate.jpg     400 x 1200
# tate.r6.JPG 1224 x 1632
# yoko.JPG    1632 x 1224
#
# ■備考
# auto-orient付けなくても基本いい感じでやってくれるんだけど、cropする際はauto-orient付けないと
# -crop 400x400+0+400 と書くところを -crop 400x400+400+0 って書かないと希望の動作をしなくなるので
# つけとけって感じ
# どうにかcropの引数なしに自動で正方形に切り出せないかな、、、とトライしたが全滅、、、。
#
#

# 普通の縦長画像
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=200x200   -resize 200x200 workspace/tate.to_small.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=2000x2000 -resize 2000x2000 workspace/tate.make_bigger.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=2000x2000 -resize 2000x2000\> workspace/tate.make_small_if_bigger01.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=300x300   -resize 300x300\> workspace/tate.make_small_if_bigger02.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=400x400 -crop 400x400+0+400 +repage workspace/tate.crop.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=400x400 -crop 400x400+0+400 +repage -resize 200x200 workspace/tate.crop.resize.JPG
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=200x200 -crop 400x400+0+400 +repage -resize 200x200 workspace/tate.crop.resize.d200.JPG
# ↓こいつ採用中
/usr/local/bin/convert seed/tate.jpg -auto-orient -strip -quality 98 -define jpeg:size=200x200 -gravity center -crop 400x400+0+0 +repage -resize 200x200 workspace/tate.crop.resize.d200.gcenter.JPG


# exifのローテーションが6な縦長
/usr/local/bin/convert seed/tate.r6.jpg -auto-orient -strip -quality 98 -define jpeg:size=1224x1224 -crop 1224x1224+0+204 +repage workspace/tate.r6.crop.JPG
/usr/local/bin/convert seed/tate.r6.jpg -auto-orient -strip -quality 98 -define jpeg:size=1224x1224 -crop 1224x1224+0+204 +repage -resize 200x200 workspace/tate.r6.crop.resize.JPG
# define_sizeを最終サイズの200にしても1224にするのと比べてそんなに画像に違いが見られなかった
/usr/local/bin/convert seed/tate.r6.jpg -auto-orient -strip -quality 98 -define jpeg:size=200x200   -crop 1224x1224+0+204 +repage -resize 200x200 workspace/tate.r6.crop.resize.d200.JPG

# 横長画像
/usr/local/bin/convert seed/yoko.jpg -auto-orient -strip -quality 98 -define jpeg:size=1224x1224 -crop 1224x1224+204+0 +repage workspace/yoko.crop.JPG
/usr/local/bin/convert seed/yoko.jpg -auto-orient -strip -quality 98 -define jpeg:size=1224x1224 -crop 1224x1224+204+0 +repage -resize 200x200 workspace/yoko.crop.resize.JPG
/usr/local/bin/convert seed/yoko.jpg -auto-orient -strip -quality 98 -define jpeg:size=200x200   -crop 1224x1224+204+0 +repage -resize 200x200 workspace/yoko.crop.resize.d200.JPG

open workspace
