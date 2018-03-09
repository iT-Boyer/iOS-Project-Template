#!/bin/sh
cd "$(dirname "$0")/.."
echo $PWD
pod install --verbose
say "install done"
