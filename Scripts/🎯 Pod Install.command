#!/bin/sh
cd "$(dirname "$0")/.."
echo $PWD
pod install --verbose
fastlane sort_project
say "install done"
