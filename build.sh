echo checking for repo update
git config pull.rebase false
git pull

#clone or update clang if its alreay exists
set -e

if [ -r clang ]; then
  echo clang found!
  cd clang
  git config pull.rebase false
  cd ..
  

else
  echo clang not found!, git cloning it now....
  git clone --depth=1 https://github.com/kdrag0n/proton-clang.git clang

fi

KERNEL_DEFCONFIG=phoenix_defconfig
ANYKERNEL3_DIR=$PWD/AnyKernel3/
KERNELDIR=$PWD/
FINAL_KERNEL_ZIP=Redcliff-v3.0.4-phoenix.zip
export PATH="${PWD}/clang/bin:${PATH}"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING="$(${PWD}/clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
IMAGE_GZ=$PWD/out/arch/arm64/boot/Image.gz
DTB=$PWD/out/arch/arm64/boot/dts/qcom/sdmmagpie.dtb
DTBO_IMG=$PWD/out/arch/arm64/boot/dtbo.img
# Speed up build process
MAKE="./makeparallel"

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Clean build always lol
echo "**** Cleaning ****"
mkdir -p out
make O=out clean

echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip

echo "**** Verify target files ****"
if [ ! -f "$IMAGE_GZ" ]; then
    echo "!!! Image.gz not found"
    exit 1
fi
if [ ! -f "$DTB" ]; then
    echo "!!! dtb not found"
    exit 1
fi
if [ ! -f "$DTBO_IMG" ]; then
    echo "!!! dtbo.img not found"
    exit 1
fi

echo "**** Moving target files ****"
mv $IMAGE_GZ $ANYKERNEL3_DIR/Image.gz
mv $DTB $ANYKERNEL3_DIR/dtb
mv $DTBO_IMG $ANYKERNEL3_DIR/dtbo.img

echo "**** Time to zip up! ****"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP *

echo "**** Removing leftovers ****"
cd ..
rm $ANYKERNEL3_DIR/Image.gz
rm $ANYKERNEL3_DIR/dtb
rm $ANYKERNEL3_DIR/dtbo.img

mv -f $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP out/

echo "Check out/$FINAL_KERNEL_ZIP"
