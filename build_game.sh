#!/bin/bash
sudo apt-get install unzip
OS="linux"
BITS="64"
EXEC_EXT="x86_64"
GODOT_VERSION="3.3.2.stable"
MODE="all"
while getopts "platform:bits:godot-version:mode" opt
do
   case "$opt" in
      platform ) OS="$OPTARG" ;;
      bits ) BITS="$OPTARG" ;;
      godot-version ) GODOT_VERSION="$OPTARG" ;;
      mode ) MODE="$OPTARG" ;;
   esac
done
echo "Building for platform: "$OS", "$BITS"-bits, with Godot Engine version: "$GODOT_VERSION". Build mode: " $MODE
if [$OS -eq "linux"]; then
  if [$BITS -eq "64"]; then
    EXEC_EXT="x86_64"
  fi
  if [$BITS -eq "32"]; then
    EXEC_EXT="x86"
  fi
fi
if [$OS -eq "windows"]; then
  EXEC_EXT="exe"
fi
if [$OS -eq "osx"]; then
  EXEC_EXT=".zip"
fi

version=$(echo $GODOT_VERSION | grep -o '[^-]*$')
GODOT_VERSION_NUMBER=$(echo $version | cut -d. -f1)"."$(echo $version | cut -d. -f2)"."$(echo $version | cut -d. -f3) #3.3.3
GODOT_VERSION_VERSION=$(echo $version | cut -d. -f4) #stable
GODOT_BINARY_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_VERSION_NUMBER"/Godot_v"$GODOT_VERSION_NUMBER"-"$GODOT_VERSION_VERSION"_linux_headless.64.zip"
GODOT_EXPORT_TEMPLATES_DOWNLOAD_LINK="https://downloads.tuxfamily.org/godotengine/"$GODOT_VERSION_NUMBER"/Godot_v"$GODOT_VERSION_NUMBER"-"$GODOT_VERSION_VERSION"_export_templates.tpz"

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
if ["${MODE}" -eq "all"]; then
  cd $GITHUB_WORKSPACE
  sudo mkdir -p "builds/"$OS"-"$BITS"-standard"
  sudo ./$GODOT_BINARY_FILENAME --path "." --export $OS"-"$BITS $GITHUB_WORKSPACE"/builds/"$OS"-"$BITS"-standard/FoxyAdventure."$EXEC_EXT
fi