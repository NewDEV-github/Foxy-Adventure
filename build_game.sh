#!/bin/bash
sudo apt-get install unzip
GODOT_VERSION="3.3.stable"
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/3.3/Godot_v3.3-stable_linux_headless.64.zip"
GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/3.3/Godot_v3.3-stable_export_templates.tpz"

GODOT_BINARY_FILENAME="$(basename -s .zip $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_ZIP_FILENAME="$(basename $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_TPZ_FILENAME="$(basename $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK)"
wget $GODOT_BINARY_DOWNLOAD_LINK
wget $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK

unzip $GODOT_ZIP_FILENAME
unzip $GODOT_TPZ_FILENAME
unzip templates/$GODOT_VERSION/osx.zip

cd $GITHUB_WORKSPACE
mkdir -p builds/tmp/{x11-64-standard,win-64-standard,osx-standard}
mkdir -p builds/{x11-64-standard,win-64-standard,osx-standard}

sudo ./$GODOT_BINARY_FILENAME --path "." --export-zip "x11-64" $GITHUB_WORKSPACE/builds/tmp/x11-64-standard/FoxyAdventure.zip
sudo ./$GODOT_BINARY_FILENAME --path "." --export-zip "osx" $GITHUB_WORKSPACE/builds/tmp/osx-standard/FoxyAdventure.zip
sudo ./$GODOT_BINARY_FILENAME --path "." --export-zip "win-64" $GITHUB_WORKSPACE/builds/tmp/win-64-standard/FoxyAdventure.zip

unzip $GITHUB_WORKSPACE/builds/tmp/x11-64-standard/FoxyAdventure.zip
unzip $GITHUB_WORKSPACE/builds/tmp/osx-standard/FoxyAdventure.zip
unzip $GITHUB_WORKSPACE/builds/tmp/win-64-standard/FoxyAdventure.zip

rm $GITHUB_WORKSPACE/builds/tmp/x11-64-standard/FoxyAdventure.zip
rm $GITHUB_WORKSPACE/builds/tmp/osx-standard/FoxyAdventure.zip
rm $GITHUB_WORKSPACE/builds/tmp/win-64-standard/FoxyAdventure.zip

cp -r $GITHUB_WORKSPACE/builds/tmp/x11-64-standard/  $GITHUB_WORKSPACE/builds/x11-64-standard/
cp -r $GITHUB_WORKSPACE/builds/tmp/osx-standard/  $GITHUB_WORKSPACE/builds/osx-standard/
cp -r $GITHUB_WORKSPACE/builds/tmp/win-64-standard/  $GITHUB_WORKSPACE/builds/win-64-standard/

cp $GITHUB_WORKSPACE/templates/windows_64_release.exe $GITHUB_WORKSPACE/builds/win-64-standard/FoxyAdventure.exe
cp $GITHUB_WORKSPACE/templates/linux_x11_64_release $GITHUB_WORKSPACE/builds/x11-64-standard/FoxyAdventure.x86_64
cp $GITHUB_WORKSPACE/templates/osx_template.app $GITHUB_WORKSPACE/builds/osx-standard/FoxyAdventure.app