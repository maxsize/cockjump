#!/bin/bash
echo "Choose root folder."
printf "1.scene  2.ui -->"
read choice

if [ $choice -eq 1 ]
then 
foldername="scene"
else
foldername="ui"
fi

printf "Input file name you want to convert -->"
read filename
unzip ./../assets/$foldername/PNG/$filename.zip -d tmp
pushd tmp
for png in *.png; do
	echo "Converting $png..."
	png2atf -p -n 0,0 -i $png -o `echo $png | sed 's/\.png/.atf/'`
	rm $png
done

cat library.json | sed 's/\.png/.atf/g' > library-atf.json
mv library-atf.json library.json
zip -r $filename.zip *
popd
mkdir ./../assets/$foldername/PVRTC
rm ./../assets/$foldername/PVRTC/$filename.zip
mv tmp/$filename.zip ./../assets/$foldername/PVRTC/$filename.zip
rm -rf tmp
exit 0