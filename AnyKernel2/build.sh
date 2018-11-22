# Set info vars.
CURRENT_DATE=$(date +'%Y%m%d')
PETTY_WORKING_DIR="/var/lib/jenkins/workspace/Pettyl_Upstream/kernel"
PETTYL_VERSION=$1
KERNEL_VERSION="3.18.85"
FILE_NAME="Pettyl.Kernel-v${PETTYL_VERSION}-${KERNEL_VERSION}-${CURRENT_DATE}.zip"

# Delete old stuff.
rm AnyKernel2/*.zip
if [ -f AnyKernel2/modules/system/lib/modules/wlan.ko ]; then
    rm AnyKernel2/modules/system/lib/modules/wlan.ko
fi

# Start building anykernel zip.
rm AnyKernel2/zImage
cp arch/arm/boot/zImage AnyKernel2/zImage
mv arch/arm/boot/zImage AnyKernel2/zImage
find . -type f -name "wlan.ko" -exec cp -fv {} AnyKernel2/modules/system/lib/modules/. \;

# Update kernel version
cp AnyKernel2/anykernel-template.sh AnyKernel2/anykernel.sh
sed -i -e "s/PETTYL_VERSION/$PETTYL_VERSION/g" AnyKernel2/anykernel.sh
sed -i -e "s/KERNEL_VERSION/$KERNEL_VERSION/g" AnyKernel2/anykernel.sh

# Zip it!.
cd AnyKernel2
zip -r9 ${FILE_NAME} * -x build.sh README.md anykernel-template.sh
cd ..

# Print final result in color!
GREEN='\033[0;32m'
echo ""
echo -e "${GREEN}> Succeed!, file located at AnyKernel2/$FILE_NAME"
