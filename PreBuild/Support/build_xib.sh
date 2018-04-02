
# xib 编译
# /Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/IBCompilerPlugin.xcplugin/Contents/Resources/IBStoryboardCompiler.xcspec

if [ "$CALLED_FROM_MASTER" ]
then
# This is the other build, called from the original instance
exit 0
fi

MB_COMPILE_DIRECTORY=${MBBuildOutput}/../Output-nibs
rm -f "${MB_COMPILE_DIRECTORY}/${INPUT_FILE_BASE}.nib"
ibtool --errors --warnings --notices\
    --auto-activate-custom-fonts\
    --target-device iphone\
    --minimum-deployment-target 7.0\
    --compile "${MB_COMPILE_DIRECTORY}/${INPUT_FILE_BASE}.nib"\
    "${INPUT_FILE_PATH}"