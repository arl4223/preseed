#!/bin/bash

# Variables
TEMP_DIR = /tmp
LOOP_DIR = loopdir
INITRD_DIR = initdir
EXPORT_DIR = exportdir
PRESEED_URL = 
PRESEED_FILE = preseed.cfg
DEBIAN_VERSION = 8.2.0
PACKAGES = rsync xorriso

apt-get install -y $PACKAGES

# Change into temp dir
cd $TEMP_DIR

# Download Debian ISO
wget http://cdimage.debian.org/debian-cd/$DEBIAN_VERSION/amd64/iso-cd/debian-$DEBIAN_VERSION-amd64-netinst.iso $TEMP_DIR/netinst.iso

# Extract isohdpfx.bin
dd if=$TEMP_DIR/netinst.iso bs=512 count=1 of=/$TEMP_DIR/isohdpfx.bin

mkdir $LOOP_DIR
mount -o loop netinst.iso $LOOP_DIR
mkdir $EXPORT_DIR
rsync -a -H --exclude=TRANS.TBL $LOOP_DIR/ $EXPORT_DIR
umount $LOOP_DIR
rm -rf $LOOP_DIR

mkdir $INITRD_DIR
cd $INITRD_DIR
gzip -d < $TEMP_DIR/$EXPORT_DIR/install.amd/initrd.gz | cpio --extract --verbose --make-directories --no-absolute-filenames
cp $TEMP_DIR/$PRESEED_FILE $PRESEED_FILE
find . | cpio -H newc --create --verbose | gzip -9 > $TEMP_DIR/$EXPORT_DIR/install.amd/initrd.gz
cd ../
rm -rf $INITRD_DIR

cd $EXPORT_DIR
md5sum `find -follow -type f` > md5sum.txt
cd ../

xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes \
-isohybrid-mbr $TEMP_DIR/isohdpfx.bin -partition_offset 16 \
-A "Debian Autoinstall"  -b isolinux/isolinux.bin -c \
isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
-boot-info-table -o debian-autoinstall.iso $EXPORT_DIR
