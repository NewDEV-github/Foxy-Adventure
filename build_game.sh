#!/bin/bash
sudo apt-get install unzip
OS="linux"
BITS="64"
EXEC_EXT="x86_64"
GODOT_VERSION="3.3.2.stable"
GODOT_VERSION_NUMBER=$GODOT_VERSION
GODOT_VERSION_VERSION=$GODOT_VERSION
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/" + $GODOT_VERSION_VERSION+"/Godot_v" + $GODOT_VERSION_VERSION + "-" + $GODOT_VERSION_NUMBER+"_linux_headless.64.zip"
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
sudo mkdir -p "builds/" + $OS + "-" + $BITS + "-standard"

sudo ./$GODOT_BINARY_FILENAME --path "." --export $OS + "-" + $BITS $GITHUB_WORKSPACE+"/builds/" + $OS + "-" + $BITS + "-standard/FoxyAdventure." + $EXEC_EXT
