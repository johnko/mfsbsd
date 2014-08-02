mfsBSD
=========

Copyright (c) 2007-2013 Martin Matuska <mm at FreeBSD.org>

Version 2.1ko1 (johnko's fork)

> This fork (github.com/johnko/mfsbsd) of mfsBSD has some extra features:
> - inspired by Joyent's SmartOS: boot a whole Data Center from a USB or PXE boot
> - how to recover with the USB image in `./doc` (auto-create DHCP, PXE, pkgng repo, distro jails)
> - DHCP and PXE auto-configured based on make-your-own network map in `keys/all/server/csv/dhcpd/net.csv`
> - host network interfaces also auto-configured based on make-your-own network map with `lagg` support
> - refactored `zfsinstall` to use `geom_label` for identifying partitions
> - refactored `zfsinstall` to use `geom_mirror` and `geom_eli` for swap
> - refactored `zfsinstall` to use `geom_eli` for encryption
> - refactored `zfsinstall` to use the bsdconfig-style zfs creation
> - `zfsinstall` creates the ssh key of the installed server (so you know what the pubkey will be when you reconnect)
> - refactored `Makefile` for custom "key" folders to separate different config setups
> - refactored `Makefile` for more inodes in the mfsroot
> - included sample `build.sh` script
> - `/etc/rc.d/jautopkg` to install packages, with fall back to install /packages/*t?z that are not pre-installed
> - smaller `prunelist` (larger mfsroot)
> - sample `BIGNKPT` kernel config
> - lots of useful script in `./keys/all/server/bin/` like `buildallports` (using poudriere) and `stat-all`
> - lots of useful ***EXPERIMENTAL*** configs in `./keys/all/server/nginx/` (use at your own risk)

## To-do

- jail deployment automation with Chef/Puppet/Ansible/etc.
- MySQL/Percona/MariaDB multi-master replication
- Riak, RiakCS

## Description

This is a set of scripts that generates a bootable image, ISO file or boot
files only, that create a working minimal installation of FreeBSD. This
minimal installation gets completely loaded into memory.

The image may be written directly using dd(1) onto any bootable block device,
e.g. a hard disk or a USB stick e.g. /dev/da0, or a bootable slice only,
e.g. /dev/ada0s1

## Build-time requirements
 - FreeBSD 8 or higher installed, tested on i386 or amd64
 - Base and kernel from a FreeBSD 8 or higher distribution
   (release or snapshots, e.g mounted CDROM disc1 or ISO file)

## Runtime requirements
 - a minimum of 512MB system memory

## Other information

See BUILD and INSTALL files for building and installation instructions.

Project homepage: http://mfsbsd.vx.sk

This project is based on the ideas of the depenguinator project:
http://www.daemonology.net/depenguinator/
