#! /bin/sh

ScriptPath=$(dirname $0)

Sort () {
    if [[ "$1" == *Pods.xcodeproj ]]; then
        # echo "跳过 pod"
        return
    fi
    echo "整理: $1"
    perl -w "$ScriptPath/sort-Xcode-project-file.pl" "$1"
}
export ScriptPath
export -f Sort
find . -name "*.xcodeproj" -maxdepth 2 -exec bash -c 'Sort "{}"' \;

timeFile="$ScriptPath/PreBuild.time"
touch "$timeFile"
