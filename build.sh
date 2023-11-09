#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 10G
export ARCH=arm64
export KBUILD_BUILD_HOST=github
export KBUILD_BUILD_USER="nayem8854"
[ -d "out" ] && rm -rf ../out || mkdir -p ../out

make O=../out ARCH=arm64 RMX1931_defconfig

PATH="${PWD}/../tc/clang-r383902/bin:${PATH}:${PWD}/../gcc/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=../out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${PWD}/../gcc/los-4.9-64/bin/aarch64-linux-android-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

compile

cd ..
mkdir module
cp out/drivers/ommc/core/mmc_test.ko module
cp out/drivers/net/wireless/ath/wil6210/wil6210.ko module
cp out/drivers/media/usb/gspca/gspca_main.ko module
cp out/drivers/media/rc/msm-geni-ir.ko module
cp out/drivers/platform/msm/msm_11ad/msm_11ad_proxy.ko module
cp out/drivers/media/platform/msm/dvb/adapter/mpq-adapter.ko module
cp out/drivers/soc/qcom/llcc_perfmon.ko module
cp out/net/bridge/br_netfilter.ko module
cp out/drivers/media/platform/msm/dvb/demux/mpq-dmx-hw-plugin.ko module
cp out/drivers/media/platform/msm/broadcast/tspp.ko module
cp out/drivers/video/backlight/lcd.ko module
cp out/drivers/char/rdbg.ko module
cp out/arch/arm64/boot/Image.gz-dtb module
cp out/arch/arm64/boot/Image module
cp out/arch/arm64/boot/Image.gz module
cp out/arch/arm64/boot/dts/19696/sm8150-v2.dtb module
cp out/arch/arm64/boot/dts/19696/sm8150-v2-mtp.dtb module

zip -r compiled-kernel.zip module
