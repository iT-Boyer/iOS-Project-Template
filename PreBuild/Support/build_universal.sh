# REF: Universal static library script
# http://github.com/michaeltyson/iOS-Universal-Library-Template

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ "$CALLED_FROM_MASTER" ]; then
    # This is the other build, called from the original instance
    exit 0
fi

# Find the BASESDK version number
SDK_VERSION=$(echo ${SDK_NAME} | grep -o '.\{3,4\}$')

echo "XCode has selected SDK: ${PLATFORM_NAME} with version: ${SDK_VERSION} (although back-targetting: ${IPHONEOS_DEPLOYMENT_TARGET})"

# Next, work out if we're in SIM or DEVICE
if [ ${PLATFORM_NAME} = "iphonesimulator" ]; then
    OTHER_SDK_TO_BUILD=iphoneos${SDK_VERSION}
elif [ ${PLATFORM_NAME} = "iphoneos" ]; then
    OTHER_SDK_TO_BUILD=iphonesimulator${SDK_VERSION}
else
    echo "Unsupport PLATFORM_NAME = ${PLATFORM_NAME}"
    exit 1
fi

# Build the other architecture
echo "Xcode already build with ${SDK_NAME}, now build ${OTHER_SDK_TO_BUILD}"
xcodebuild -project "${PROJECT_FILE_PATH}" -configuration "${CONFIGURATION}" -target "${TARGET_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" CALLED_FROM_MASTER=1 | xcpretty

# Merge built architectures
CURRENTCONFIG_DEVICE_DIR="${SYMROOT}/${CONFIGURATION}-iphoneos"
CURRENTCONFIG_SIMULATOR_DIR="${SYMROOT}/${CONFIGURATION}-iphonesimulator"
CURRENTCONFIG_UNIVERSAL_DIR="${SYMROOT}/${CONFIGURATION}-universal"

echo "Taking device build from: ${CURRENTCONFIG_DEVICE_DIR}"
echo "Taking simulator build from: ${CURRENTCONFIG_SIMULATOR_DIR}"
echo "Will output a universal build to: ${CURRENTCONFIG_UNIVERSAL_DIR}"

DEVICE_A="${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}"
SIMULATOR_A="${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}"
UNIVERSAL_A="${CURRENTCONFIG_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"

echo "Get output destination prepared."
rm -f "${UNIVERSAL_A}"
mkdir -p "${CURRENTCONFIG_UNIVERSAL_DIR}"

echo "lipo: for current configuration (${CONFIGURATION}) creating output file: ${UNIVERSAL_A}"
lipo "${DEVICE_A}" "${SIMULATOR_A}" -create -output "${UNIVERSAL_A}"

echo "Now copy back."
cp -f "${UNIVERSAL_A}" "${DEVICE_A}"
cp -f "${UNIVERSAL_A}" "${SIMULATOR_A}"
