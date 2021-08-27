#!/bin/bash -xe

patch_name="android_frameworks_base-R.patch"
permissioncontroller_patch="packages_apps_PermissionController-R.patch"


patch_src=/home/pavel/microg/docker-lineage-cicd/src/signature_spoofing_patches
vendor=lineage
LMANIFEST_DIR=/home/pavel/microg/manifests

CUSTOM_PACKAGES="GmsCore GsfProxy FakeStore MozillaNlpBackend NominatimNlpBackend com.google.android.maps.jar FDroid FDroidPrivilegedExtension CallRecorder"

cd /home/pavel/android/lineage
rsync -a --delete --include '*.xml' --exclude '*' "$LMANIFEST_DIR/" .repo/local_manifests/

repo sync -d -j 32
repo forall -vc "git reset --hard"
repo forall -vc "git clean -fxd"

rm -rf /home/pavel/android/lineage/vendor/google
cp -r /home/pavel/android/proprietary_vendor_google/ /home/pavel/android/lineage/vendor/google

mkdir -p "vendor/$vendor/overlay/microg/"
sed -i "1s;^;PRODUCT_PACKAGE_OVERLAYS := vendor/$vendor/overlay/microg\n;" "vendor/$vendor/config/common.mk"
sed -i "1s;^;PRODUCT_PACKAGES += $CUSTOM_PACKAGES\n\n;" "vendor/$vendor/config/common.mk"

cd frameworks/base
sed 's/android:protectionLevel="dangerous"/android:protectionLevel="signature|privileged"/' "$patch_src/$patch_name" | patch --version-control none --quiet --force -p1
find . -name '*.orig' -delete
cd ../..

cd packages/apps/PermissionController
patch --quiet --force --version-control none  -p1 -i "$patch_src/$permissioncontroller_patch"
find . -name '*.orig' -delete
cd ../../..

mkdir -p "vendor/$vendor/overlay/microg/frameworks/base/core/res/res/values/"
cp $patch_src/frameworks_base_config.xml "vendor/$vendor/overlay/microg/frameworks/base/core/res/res/values/config.xml"

#. ./build/envsetup.sh
#breakfast redfin

