#! /bin/sh

ScriptPath=$(dirname $0)
ProjectRoot=$(dirname $ScriptPath)

perl -w "$ScriptPath/sort-Xcode-project-file.pl" "$ProjectRoot/${PRODUCT_NAME}.xcodeproj"
perl -w "$ScriptPath/sort-Xcode-project-file.pl" "$ProjectRoot/PreBuild/project-framework.xcodeproj"
timeFile="$ScriptPath/PreBuild.time"
touch "$timeFile"
