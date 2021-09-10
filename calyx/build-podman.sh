#!/usr/bin/env -S bash -xe

podman build ./docker -t calyxbuild

mkdir -p $(pwd)/ccache
echo "max_size = 100G" > $(pwd)/ccache/ccache.conf

podman run -t --rm \
    --mount type=bind,source=$(pwd),destination=/work \
    --mount type=bind,source=$(pwd)/ccache,destination=/var/cache/ccache \
    localhost/calyxbuild:latest ./build.sh $*
