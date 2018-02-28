#!/bin/sh
echo "本脚本用于修改 PreBuild 的 Podfile 后将更改同步到项目"
cd "$(dirname "$0")/.."
echo $PWD
fastlane update_pods_combine
say "update done"
