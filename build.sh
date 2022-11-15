#!/bin/bash

set -xe

cd /workspace
git clone -b Ubuntu-5.15.0-54.60 --depth=1 https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/jammy linux-src
mkdir preempt-rt-patches
cd preempt-rt-patches
wget https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.15/older/patches-5.15.73-rt52.tar.gz
tar xvf patches*
cd ../linux-src
for p in ../preempt-rt-patches/patches/*.patch; do
  echo $p
  cat $p | patch -p1
done

# The three files are:
#   - common ubuntu config
#   - amd64 config
#   - rt config
scripts/kconfig/merge_config.sh \
  debian.master/config/config.common.ubuntu \
  debian.master/config/amd64/config.common.amd64 \
  ../rt.config-fragment

# Do not generate dbg package as that is very time consuming and generates a
# large debian package.
# scripts/config --disable DEBUG_INFO

time make bindeb-pkg -j$(nproc)

# Finally move all the artifacts into a folder so it is easy to copy out via docker cp
cd ..
mkdir debs
mv *.deb debs
