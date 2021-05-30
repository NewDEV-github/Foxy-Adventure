#!/bin/bash
sudo apt-get install unzip
GODOT_VERSION="3.3.2.stable"
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/3.3.2/Godot_v3.3.2-stable_linux_headless.64.zip"
GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/3.3.2/Godot_v3.3.2-stable_export_templates.tpz"

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
sudo mkdir -p builds/{x11-64-standard,win-64-standard,osx-standard}

sudo ./$GODOT_BINARY_FILENAME --path "." --export "x11-64" $GITHUB_WORKSPACE/builds/x11-64-standard/FoxyAdventure.x86_64
sudo ./$GODOT_BINARY_FILENAME --path "." --export "osx" $GITHUB_WORKSPACE/builds/osx-standard/FoxyAdventure.zip
sudo ./$GODOT_BINARY_FILENAME --path "." --export "win-64" $GITHUB_WORKSPACE/builds/win-64-standard/FoxyAdventure.exe
