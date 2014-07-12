# mfsBSD building instructions

Copyright (c) 2007-2013 Martin Matuska <mm at FreeBSD.org>

Version 2.1ko1 (johnko's fork)

This fork (github.com/johnko/mfsbsd) of mfsBSD is setup as follows:

```
./conf

./keys                     # allows organizing different directories to include/exclude

./keys/all                 # a sub tree that can be copied
./keys/all/root            # copied to /root, overwrites any existing files
./keys/all/root/bin        # some tools should be moved to here
./keys/all/server          # this is my custom folder, I don't think anyone 
                           # ... will ever use this

./keys/mfsbsdonly          # another sub tree that can be copied
./keys/mfsbsdonly/boot     # copied to /boot, overwrites any existing files

./keys/private

./mfsbsdonly               # the default sub tree that is copied (later ones overwrite)

./mfsbsdonly/boot          # copied to /boot

./mfsbsdonly/etc           # now contains *.conf files, copied to /etc
./mfsbsdonly/etc/rc.conf.d
./mfsbsdonly/etc/rc.d      # startup scripts

./mfsbsdonly/root          # root users's home folder, copied to /root
./mfsbsdonly/root/.ssh     # contains authorized_keys

./packages                 # these packages will be copied, but not installed (may be 
                           # ... installed after boot by /etc/rc.d/jpackages)
./pkginstall               # these packages will be installed.

./tools
./tools/roothack
```

The order in which files are copied/overwritten can be seen in `Makefile` and `build.sh` 
where later folders overwrite existing files of earlier folders. Said another way, last
file wins:

- ${MFSBSDONLY} (./mfsbsdonly)
- ${FILESDIR} (./all)
- then any in ${KEYCFG} (KEYCFG="mfsbsdonly all private" which equates to ./keys/mfsbsdonly ./keys/all ./keys/private)

## JOHN'S QUICK START:

```
git clone https://github.com/johnko/mfsbsd.git mfsbsd
cd mfsbsd && ./build.sh nox all $CSV
```

where $CSV is your own custom folder in ./keys like 'private' in the folder tree above.

If all goes well, you'll have created a NOX-10.0-RELEASE-amd64.tar/iso/img files

## BUILDING INSTRUCTIONS:
 1. Configuration
    Create a `./keys/private` directory with your favourite configurations that you don't
    want to accidentally make public. For example a custom `/etc/rc.conf` would go in
    `./keys/private/etc/rc.conf`

 2. Additional packages and files
    If you want any packages installed, copy the .t?z files that should be
    automatically installed into the ./pkginstall/ directory.

    Add any additional files into the ./customfiles/ directory. These will be copied
    recursively into the root of the boot image.

    WARNING: Your image should not exceed 45MB in total, otherwise kernel panic
             may occur on boot-time. To allow bigger images, you have to
             recompile your kernel with increased NKPT (e.g. NKPT=120)

 3. Distribution or custom world and kernel
    You may choose to build from a FreeBSD distribution (e.g. CDROM), or by
    using make buildworld / buildkernel from your own world and kernel
    configuration.

    To use a distribution (e.g. FreeBSD cdrom), you need access to it 
    (e.g. a mounted FreeBSD ISO via mdconfig) and use BASE=/path/to/distribution

    To use your own but already built world and kernel, use CUSTOM=1
    If you want this script to do make buildworld and make buildkernel for you,
    use BUILDWORLD=1 and BUILDKERNEL=1

 4. Creating images

    You may create three types of output: disc image for use by dd(1), 
    ISO image or a simple .tar.gz file

    Examples:

    a) disc image
	make BASE=/cdrom/usr/freebsd-dist
	make BASE=/cdrom/9.2-RELEASE
        make CUSTOM=1 BUILDWORLD=1 BUILDKERNEL=1

    b) bootable ISO file:
	make iso BASE=/cdrom/usr/freebsd-dist
	make iso BASE=/cdrom/9.2-RELEASE
	make iso CUSTOM=1 BUILDWORLD=1 BUILDKERNEL=1

    c) .tar.gz file:
	make tar BASE=/cdrom/usr/freebsd-dist
	make tar BASE=/cdrom/9.2-RELEASE
	make tar CUSTOM=1 BUILDWORLD=1 BUILDKERNEL=1

    d) roothack edition:
	make iso CUSTOM=1 BUILDWORLD=1 BUILDKERNEL=1 ROOTHACK=1

    e) special edition (with FreeBSD distribution):
	make iso BASE=/cdrom/9.2-RELEASE RELEASE=9.2-RELEASE ARCH=amd64

    f) GCE-compatible .tar.gz file:
	make gce BASE=/cdrom/usr/freebsd-dist
	make gce BASE=/cdrom/9.2-RELEASE
	make gce CUSTOM=1 BUILDWORLD=1 BUILDKERNEL=1
