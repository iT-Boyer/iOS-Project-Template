#!/bin/sh
cd "$(dirname "$0")/.."
echo $PWD
fastlane alpha
