#!/usr/bin/env -S bash -xe

CALYX_REVISION="refs/tags/2.11.0"

docker build ./docker -t calyxbuild

mkdir -p $(pwd)/ccache
echo "max_size = 100G" >$(pwd)/ccache/ccache.conf

function init() {
    mkdir -p os
    pushd .
    cd os
    repo init -u https://gitlab.com/CalyxOS/platform_manifest -b $CALYX_REVISION
    popd
}

init

docker run -t --rm \
    --user $(id -u):$(id -g) \
    --mount type=bind,source=$(pwd),destination=/work \
    --mount type=bind,source=$(pwd)/ccache,destination=/var/cache/ccache \
    calyxbuild:latest ./build.sh $*
