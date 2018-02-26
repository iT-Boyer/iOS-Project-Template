#!/bin/bash

TargetName=$1

echo "Will clean target: $TargetName"

ClearDir () {
  BuildDir="$1/Build/Intermediates/$TargetName.build"
  Path1="$BuildDir/Debug-iphoneos/$TargetName.build/Objects-normal"
  echo "Clear $Path1"
  rm -rf "$Path1"
  Path2="$BuildDir/Debug-iphonesimulator/$TargetName.build/Objects-normal"
  echo "Clear $Path2"
  rm -rf "$Path2"
}

export TargetName
export -f ClearDir

DerivedDataDir=~/Library/Developer/Xcode/DerivedData
find "$DerivedDataDir" -maxdepth 1  -type d  -name "${TargetName// /_}-*" -exec bash -c 'ClearDir "$0"' {} \;
