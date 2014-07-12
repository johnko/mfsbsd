# mfsBSD installation (deployment) instructions

Copyright (c) 2007-2013 Martin Matuska <mm at FreeBSD.org>

Version 2.1ko1 (johnko's fork)

## BUILD:

For customized build please see the BUILD file

## DEPLOYMENT:

### Scenario 1:

You have a linux server without console access and want to install
FreeBSD on this server.

a) modify your configuration files (do this properly, or no ssh access)
b) create an image file (e.g. make BASE=/cdrom/9.2-RELEASE)
c) write image with dd to the bootable harddrive of the linux server
d) reboot
e) ssh to your machine and enjoy :)

### Scenario 2:

You want a rescue CD-ROM with a minimal FreeBSD installation that doesn't
need to remain in the tray after booting.

a) modify your configuration files
b) create an iso image file (e.g. make iso BASE=/cdrom/9.2-RELEASE)
c) burn ISO image onto a writable CD
d) boot from the CD and enjoy :)

### Scenario 3:

You want a rescue partition on your FreeBSD system so you can re-partition
all harddrives remotely.

a) modify your configuration files
b) create an .tar.gz file (e.g. make tar BASE=/cdrom/9.2-RELEASE)
c) create your slice with sysinstall or fdisk (e.g. ada0s1)
d) auto-label the slice (e.g. bsdlabel -r -w ada0s1 auto)
e) create a filesystem on the slice (e.g. newfs /dev/ada0s1a)
f) mount the slice and extract your .tar.gz file on it
g) configure a bootmanager (e.g. boot0cfg -B -s 1 /dev/ada0)
h) boot from your rescue system and enjoy :)

### Scenario 4 by johnko:

You want to deploy hundred of servers with the same image:

a) modify your configuration files
b) create an iso image file (e.g. make enciso BASE=/cdrom/10.0-RELEASE)
c) pxe boot all servers from iso using memdisk
d) launch jails on each host and enjoy

### Scenario 5 by johnko:

You want to prepare for disaster recovery:

a) modify your configuration files
b) create an USB img file (e.g. make encimage BASE=/cdrom/10.0-RELEASE)
c) distribute USB to disaster recovery team
d) disaster happens!!
e) redeploy with USB, recover from backups and enjoy :)