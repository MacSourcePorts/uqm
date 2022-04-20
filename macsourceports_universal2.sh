# game/app specific values
export APP_VERSION="0.8.0"
export ICONSDIR="src/res/darwin"
export ICONSFILENAME="The Ur-Quan Masters"
export PRODUCT_NAME="The Ur-Quan Masters"
export EXECUTABLE_NAME="The Ur-Quan Masters"
export PKGINFO="APPLMLST"
export COPYRIGHT_TEXT="Copyright © 2002 The Ur-Quan Masters. All rights reserved."

#constants
source ../MSPScripts/constants.sh

rm -rf ${BUILT_PRODUCTS_DIR}

rm -rf ${X86_64_BUILD_FOLDER}
mkdir ${X86_64_BUILD_FOLDER}
rm -rf ${ARM64_BUILD_FOLDER}
mkdir ${ARM64_BUILD_FOLDER}

./build.sh uqm clean
(PKG_CONFIG_PATH=/usr/local/lib/pkgconfig CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" ARCH=x86_64 ./build.sh uqm -j8)
build/unix_installer/copy_mac_frameworks.pl
mv "${WRAPPER_NAME}" ${X86_64_BUILD_FOLDER}

./build.sh uqm clean
(ARCH=arm64 ./build.sh uqm -j8)
build/unix_installer/copy_mac_frameworks.pl
mv "${WRAPPER_NAME}" ${ARM64_BUILD_FOLDER}

# create the app bundle
"../MSPScripts/build_app_bundle.sh"

"../MSPScripts/sign_and_notarize.sh" "$1"