Buildroot for Raspberry Pi
==========================

This buildroot *overlay* will produce a bleeding-edge, light-weight and trimmed
down toolchain, rootfs and kernel for the Raspberry Pi. It's intended for
**advanced users** and specific embedded applications.

Before You Begin
----------------

- If you're not familiar with Buildroot and what it can and can't do, please
  take the time to [read the manual](http://buildroot.org/downloads/manual/manual.html).

- You must be pretty comfortable with **cross-compilation** in order to use
  rpi-buildroot.

Test Drive
----------

You can test drive rpi-buildroot by following the instructions below:

	wget http://dl.guillermoamaral.com/rpi/sdcard.img.xz
	xz -d sdcard.img.xz
	sudo dd if=sdcard.img of=/dev/sdx # replace *sdx* with your actual sdcard device node

There's now also a test drive image for the Raspberry Pi 2:

	wget http://dl.guillermoamaral.com/rpi/sdcard2.img.xz
	xz -d sdcard2.img.xz
	sudo dd if=sdcard2.img of=/dev/sdx # replace *sdx* with your actual sdcard device node

The default user is **root**, no password is required.

Building
--------

	git clone --depth 1 git://github.com/gamaral/rpi-buildroot.git
	cd rpi-buildroot
	make raspberrypi_defconfig # if your target is a Raspberry Pi 2, use 'raspberrypi2_defconfig'
	make nconfig         # if you want to add packages or fiddle around with it
	make                 # build (NOTICE: Don't use the **-j** switch, it's set to auto-detect)

Deploying
---------

### Flash

Flash output/images/sdcard.img onto an SD card with "dd" as root:

**Notice** you will need to replace *sdX* in the following commands with the
actual device node for your sdcard.

#### Automatic

	board/raspberrypi/flashsdcard /dev/sdX

This will resize the root partition to fill up the whole SD card.

#### Manual

	dd if=output/images/sdcard.img of=/dev/sdX

Resize the partition (if needed)

	parted /dev/sdX
	> print         # prints partition table
	> resizepart 2  # resize the root partition
	> 100%          # make it fill up the whole SD card
	> print         # prints partition table
	> quit          # exit program

Then resize the filesystem

	resize2fs /dev/sdx2

### Manual

You will need to create two partitions in your sdcard, the first (boot) needs
to be a small *W95 FAT16 (LBA)* patition (that's partition id **e**), about 32
MB will do.

**Notice** you will need to replace *sdx* in the following commands with the
actual device node for your sdcard.

Create the partitions on the SD card. Run the following as root.

**Notice** all data on the SD card will be lost.

	fdisk /dev/sdx
	> p             # prints partition table
	> d             # repeat until all partitions are deleted
	> n             # create a new partition
	> p             # create primary
	> 1             # make it the first partition
	> <enter>       # use the default sector
	> +32M          # create a boot partition with 32MB of space
	> n             # create rootfs partition
	> p
	> 2
	> <enter>
	> <enter>       # fill the remaining disk, adjust size to fit your needs
	> t             # change partition type
	> 1             # select first partition
	> e             # use type 'e' (FAT16)
	> a             # make partition bootable
	> 1             # select first partition
	> p             # double check everything looks right
	> w             # write partition table to disk.

Now format the boot partition as FAT 16

	# run the following as root
	mkfs.vfat -F16 -n BOOT /dev/sdx1
	mkdir -p /media/boot
	mount /dev/sdx1 /media/boot

You will need to copy all the files in *output/images/boot* to your *boot*
partition.

	# run the following as root
	cp output/images/rpi-firmware/bootcode.bin /media/boot
	cp output/images/rpi-firmware/fixup.dat /media/boot
	cp output/images/rpi-firmware/start.elf /media/boot
	cp output/images/zImage /media/boot/kernel.img
	cp output/images/*.dtb /media/boot
	umount /media/boot

The second (rootfs) can be as big as you want, but with a 200 MB minimum,
and formated as *ext4*.

	# run the following as root
	mkfs.ext4 -L rootfs /dev/sdx2
	mkdir -p /media/rootfs
	mount /dev/sdx2 /media/rootfs

You will need to extract *output/images/rootfs.tar* onto the partition, as **root**.

	# run the following as root
	tar -xvpsf output/images/rootfs.tar -C /media/rootfs # replace with your mount directory
	umount /media/rootfs

