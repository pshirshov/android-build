#!/bin/bash -xe
cd lineage
export WITH_GMS=true
. ./build/envsetup.sh
breakfast redfin

mka target-files-package otatools
croot
sign_target_files_apks -o -d ~/.android-certs \
    $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip \
    signed-target_files.zip
ota_from_target_files -k ~/.android-certs/releasekey \
    --block --backup=true \
    signed-target_files.zip \
    signed-ota_update.zip
