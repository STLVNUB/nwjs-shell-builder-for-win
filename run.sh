# Exit on error
set -e
source config.sh

BUILD_DIR=`pwd`
WORKING_DIR="${BUILD_DIR}/TMP"
RELEASE_DIR="${BUILD_DIR}/releases"

check_dependencies() {
    # Check if NSIS is present
    if [[ "`makensis`" =~ "MakeNSIS" && "`convert`" =~ "Version: ImageMagick" ]]; then
        echo 'OK';
    else
        echo 'NO';
    fi
}

clean() {
    if [[ ${1} = "all" ]];then
        rm -rf ${RELEASE_DIR}; printf "\nCleaned ${RELEASE_DIR}\n\n";
    fi
    rm -rf ${WORKING_DIR}; printf "\nCleaned ${WORKING_DIR}\n\n";
}

build() {
    if [[ `check_dependencies` = "NO" ]]; then
        printf "\nNOTE! NSIS or ImageMagick is missing in the system\n\n";
        exit 1;
    fi
    if [[ ! -d "${RELEASE_DIR}" ]]; then
        mkdir ${RELEASE_DIR}
    fi
    ${BUILD_DIR}/nwjs-build.sh \
        --src="$w_src" \
        --name="${w_name}" \
        --nw="$w_nwjsVersion" \
        --win-icon="$w_windowsIconPath" \
        --target="${1}" \
        --version="$w_version" \
        --ffmpeg \
        --build
    cd ${BUILD_DIR}
}

pack_windows() {
    echo 'pack_windows...'
    for arch in ${architechture[@]}; do
        echo $arch
        cd ${WORKING_DIR}
        cp -r ${BUILD_DIR}/resources/windows/app.nsi ${WORKING_DIR}
        cp -r ${w_windowsIconPath} ${BUILD_DIR}/TMP/win-${arch}/latest-git/

        # other installers
        cp -r ${BUILD_DIR}/other_installers ${BUILD_DIR}/TMP/win-${arch}/latest-git/

        # Replce paths and vars in nsi script
        replace \
            NWJS_APP_REPLACE_APPNAME "${w_name}" \
            NWJS_APP_REPLACE_DESCRIPTION "${w_description}" \
            NWJS_APP_REPLACE_LICENSE ${w_license} \
            NWJS_APP_REPLACE_VERSION ${w_version} \
            NWJS_APP_REPLACE_EXE_NAME ${w_name}-${w_version}-Windows-${arch}.exe \
            NWJS_APP_REPLACE_INC_FILE_1 ${BUILD_DIR}/TMP/win-${arch}/latest-git \
            NWJS_APP_REPLACE_ICO_FILE_NAME $(basename ${w_windowsIconPath}) \
            NWJS_APP_REPLACE_INC_FILE_ICO ${w_windowsIconPath} -- app.nsi;
        makensis app.nsi
        # Clean a bit
        rm -rf ${WORKING_DIR}/${w_name}.nsi;
        mv ${WORKING_DIR}/${w_name}-${w_version}-Windows-${arch}.exe ${RELEASE_DIR}
        printf "\nDone Windows ${arch}\n"
    done
}

clean all
build "2 3"
pack_windows
