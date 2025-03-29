size="1280x1280"
quality="80"

# ファイルリストを取得、for文的な loop処理 
# TODO: 拡張子の大文字小文字などに対応
for jpgfile in ./images/*.jpg; do

  basename="`basename $jpgfile`"

  echo "resizing.... $basename"


  convert $jpgfile -strip -auto-orient -quality $quality -density 72 -units PixelsPerInch -geometry $size -gravity center -background white -extent $size "./images-resized/$basename"

# end loop
done

