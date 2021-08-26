#!/bin/bash
sudo apt-get install unzip
sudo apt-get install osslsigncode
GODOT_V_N=${2} #3.3.3
GODOT_V_S=${4} #stable
GODOT_VERSION=$GODOT_V_N"."$GODOT_V_S #3.3.3.stable
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_V_N"/Godot_v"$GODOT_V_N"-"$GODOT_V_S"_linux_headless.64.zip"
GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_V_N"/Godot_v"$GODOT_V_N"-"$GODOT_V_S"_export_templates.tpz"

GODOT_BINARY_FILENAME="$(basename -s .zip $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_ZIP_FILENAME="$(basename $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_TPZ_FILENAME="$(basename $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK)"
wget $GODOT_BINARY_DOWNLOAD_LINK
wget $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK

unzip $GODOT_ZIP_FILENAME
unzip $GODOT_TPZ_FILENAME

cd /home/runner/
sudo mkdir -p .local/share/godot
cd .local/share/godot
sudo mkdir -p templates/$GODOT_VERSION
sudo cp -r $GITHUB_WORKSPACE/templates/* templates/$GODOT_VERSION

cd $GITHUB_WORKSPACE
sudo mkdir -p builds/$GODOT_VERSION/{x11-64-standard,win-64-standard,osx-standard}
echo EXPORTING TO $GITHUB_WORKSPACE/builds/$GODOT_VERSION
sed 's/enable=true/enable=false/g' $GITHUB_WORKSPACE/export_presets.cfg
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "x11-64" $GITHUB_WORKSPACE/builds/$GODOT_VERSION/x11-64-standard/FoxyAdventure.x86_64
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "osx" $GITHUB_WORKSPACE/builds/$GODOT_VERSION/osx-standard/FoxyAdventure.zip
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "win-64" $GITHUB_WORKSPACE/builds/$GODOT_VERSION/win-64-standard/FoxyAdventure.zip
