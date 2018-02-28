#!/bin/sh
cd "$(dirname "$0")/.."
echo $PWD
fastlane setup_project
say "setup done"
