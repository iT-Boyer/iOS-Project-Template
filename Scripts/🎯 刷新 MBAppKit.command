#!/bin/sh
echo "本脚本用于修改 MBAppKit 后将更改同步到项目"
cd "$(dirname "$0")/.."
echo $PWD
fastlane refresh_appkit
say "refresh done"
