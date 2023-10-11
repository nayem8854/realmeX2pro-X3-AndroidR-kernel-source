#!/bin/bash

#Installing necessary components
! sudo apt-get update
! sudo apt-get install -y bc git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig libssl-dev ccache python2 cpio

export SOURCE_ROOT=~/workspace/source
export DEFCONFIG=vendor/realme_sm8150-perf_defconfig
export MAKE_PATH=/home/gitpod/workspace/source/prebuild/build-tools/linux-x86/bin/
export CROSS_COMPILE=/home/gitpod/workspace/source/prebuild/bin/aarch64-linux-android-
export KERNEL_ARCH=arm64
export KERNEL_DIR=${SOURCE_ROOT}/kernel/msm-4.14
export KERNEL_OUT=${KERNEL_DIR}/../kernel_out
export KERNEL_SRC=${KERNEL_OUT}
export CLANG_TRIPLE=aarch64-linux-gnu-
export OUT_DIR=${KERNEL_OUT}
export ARCH=${KERNEL_ARCH}
export TARGET_INCLUDES=${TARGET_KERNEL_MAKE_CFLAGS}
export TARGET_LINCLUDES=${TARGET_KERNEL_MAKE_LDFLAGS}
export TARGET_KERNEL_MAKE_ENV+="CC=~/workspace/source/prebuild/linux-x86/clang-r383902/bin/clang"

make_defconfig()
{
cd ${KERNEL_DIR} && \
${MAKE_PATH}make -j$(nproc --all) O=${OUT_DIR} ${TARGET_KERNEL_MAKE_ENV} HOSTLDFLAGS="${TARGET_LINCLUDES}" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} ${DEFCONFIG}
}

compile()
{
cd ${OUT_DIR} && \
${MAKE_PATH}make -j$(nproc --all) ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} HOSTCFLAGS="${TARGET_INCLUDES}" HOSTLDFLAGS="${TARGET_LINCLUDES}" O=${OUT_DIR} ${TARGET_KERNEL_MAKE_ENV}
}
make_defconfig
compile
