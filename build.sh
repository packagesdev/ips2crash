#!/bin/sh

BASEDIR="$( dirname "$0" )"
cd "$BASEDIR"

ABSOLUTE_FOLDER_PATH=`pwd`
ABSOLUTE_BUILD_PATH="$ABSOLUTE_FOLDER_PATH"/distribution/build

echo "$ABSOLUTE_FOLDER_PATH"

## Create the build folder if needed

/bin/mkdir -p distribution/build

## Create the artifacts folder if needed

/bin/mkdir -p distribution/artifacts

# Retrieve the version

VERSION="1.0"

if [ -f distribution/Version ];
then

	VERSION=`cat distribution/Version`

fi

## Build ips2crash

pushd tool_ips2crash

/usr/bin/xcodebuild clean build -configuration Release -scheme "ips2crash" -derivedDataPath "$ABSOLUTE_BUILD_PATH" CONFIGURATION_BUILD_DIR="$ABSOLUTE_BUILD_PATH"

popd

## Create the zip archive

pushd distribution

ZIP_DIRECTORY_NAME="ips2crash_$VERSION"

/bin/mkdir -p build/"$ZIP_DIRECTORY_NAME"

/bin/cp ../LICENSE.txt build/"$ZIP_DIRECTORY_NAME"/LICENSE

/bin/cp build/ips2crash build/"$ZIP_DIRECTORY_NAME"

/usr/bin/zip -r artifacts/"$ZIP_DIRECTORY_NAME".zip build/"$ZIP_DIRECTORY_NAME" 

popd

exit 0

