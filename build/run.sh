# path to the ADT tool in Flash Builder sdks
ADT="/Applications/Adobe Flash Builder 4.6/sdks/4.6.0/bin/adt"

echo "****** preparing ANE package sources *******"

unzip ./SoundExtension.swc -d .
rm catalog.xml
echo "****** creating ANE package *******"

"$ADT" -package -storetype PKCS12 -keystore ./cert.p12 -storepass pasword -tsa none -target ane ./release/SoundExtension.ane ./extension.xml -swc ./SoundExtension.swc -platform iPhone-ARM ./library.swf ./libSoundExtension.a -platform default ./library.swf

echo "****** ANE package created *******"
rm library.swf