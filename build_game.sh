#!/bin/bash
GODOT_V_N=${2} #3.3.3
GODOT_V_S=${4} #stable
EXPORT_MODE=${6} #normal or zipped
GODOT_VERSION=$GODOT_V_N"."$GODOT_V_S #3.3.3.stable
echo "Builiding with:"
echo "$GODOT_VERSION"
echo "For user: $(whoami)"
echo "Installing required packages..."
BASE_PATH=${8}
sudo apt-get install unzip
sudo apt-get install osslsigncode
echo "Generating links and other required data..."
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_V_N"/Godot_v"$GODOT_V_N"-"$GODOT_V_S"_linux_headless.64.zip"
GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_V_N"/Godot_v"$GODOT_V_N"-"$GODOT_V_S"_export_templates.tpz"
GODOT_BINARY_FILENAME="$(basename -s .zip $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_ZIP_FILENAME="$(basename $GODOT_BINARY_DOWNLOAD_LINK)"
GODOT_TPZ_FILENAME="$(basename $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK)"
DOWNLOAD_FILES=("$GODOT_ZIP_FILENAME" "$GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK")
echo "Checking for required files..."
if [ -f "$GODOT_BINARY_FILENAME" ]; then
    echo "$GODOT_BINARY_FILENAME exists."
else
    echo "$GODOT_BINARY_FILENAME doesn't exist. Downloading now..."
    wget $GODOT_BINARY_DOWNLOAD_LINK
    unzip $GODOT_ZIP_FILENAME
fi
if [ -f "$GODOT_TPZ_FILENAME" ]; then
    echo "$GODOT_TPZ_FILENAME exists."
else
    echo "$GODOT_TPZ_FILENAME doesn't exist. Downloading now..."
    wget $GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK
    unzip $GODOT_TPZ_FILENAME

fi
echo "Installing Godot's export templates..."
sudo mkdir -p /home/$(whoami)/.local/share/godot/templates/$GODOT_VERSION
sudo cp -r templates/* /home/$(whoami)/.local/share/godot/templates/$GODOT_VERSION
echo "Downloading certificates for windows export..."
cd $BASE_PATH
CETS=("https://newdev.web.app/dl/files/downloads/foxy-adventure/foxyadventure.crt" "https://newdev.web.app/dl/files/downloads/foxy-adventure/foxyadventure.keystore" "https://newdev.web.app/dl/files/downloads/foxy-adventure/foxyadventure.p12" "https://newdev.web.app/dl/files/downloads/foxy-adventure/foxyadventure.pem")
for CERT in $CERTS
do
    if [ -f "$CERT" ]; then
        echo "$CERT exists."
    else
        wget "$CERT"
    fi
done
sudo mkdir -p builds/$GODOT_VERSION/{x11-64-standard,win-64-standard,osx-standard}
echo "Exporting for x11-64 to $BASE_PATH/builds/$GODOT_VERSION/x11-64-standard..."
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "x11-64" $BASE_PATH/builds/$GODOT_VERSION/x11-64-standard/FoxyAdventure.x86_64
echo "Exporting for osx to $BASE_PATH/builds/$GODOT_VERSION/osx-standard..."
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "osx" $BASE_PATH/builds/$GODOT_VERSION/osx-standard/FoxyAdventure.zip
echo "Exporting for win-64 to $BASE_PATH/builds/$GODOT_VERSION/win-64-standard..."
sudo ./$GODOT_BINARY_FILENAME --verbose --path "." --export "win-64" $BASE_PATH/builds/$GODOT_VERSION/win-64-standard/FoxyAdventure.exe
