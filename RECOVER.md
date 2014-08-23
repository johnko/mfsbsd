# Disaster Recovery With USB / Setting Up A New Network

## Summary

These instructions will assist in setting up a FreeBSD host server with jails running:

- DHCP service (will take the next sequential IP address relative to the host server)
- PXE boot service
- pkgng repository http service
- FreeBSD distribution http service

## Definitions

Variable         | Example       | Description
-----------------|---------------|------------
[company]        | contoso       | Needed in step 5 and 13. Company short name.
[password]       |
[ip_address]     | 192.168.0.120 | Needed in step 4. An address currently unassigned (it will become the host IP). Please ensure the next IP is also unassigned
[ip_address + 1] | 192.168.0.121 | It will become the DHCPD IP if you enable `dhcpd` in step 9.
[network_if]     | re0           | Needed in step 4. The primary network interface. It can be found by running:

```
net-nic
```

or possibly even:

```
ifconfig -l | sed -E -e 's/lo[0-9]+//g' -e 's/bridge[0-9]+//g' -e 's/enc[0-9]+//g' -e 's/ipfw[0-9]+//g' -e 's/pflog[0-9]+//g' -e 's/plip[0-9]+//g' -e 's/tap[0-9]+//g' -e 's/tun[0-9]+//g'
```

## Requirements

- New server(s) with 64-bit CPU
- Lots of RAM
- 2 or more hard disk drives (HDD) (sized 500 GB or more)
- Recommended at least 2 servers for DHCP failover

## Instructions

### 1) Plug in new host server. Turn on new host server and access the `BIOS Setup`:

> To access the BIOS setup:
> Brand   | Possible Keys
> --------|--------------
> Acer    | `F2, F10`
> Dell    | `F2`
> HP      | `F10`
> Phoenix | `DEL`

Setup BIOS boot order to:

1. `Hard Drive`
2. `USB / Removable Drive`
3. `CD / Optical Drive`

### 2) Insert CD or USB media containing `NOX` recovery image into host server.

Reboot with `Ctrl + Alt + Del` and access the `Boot Selection Menu`:

> To access the Boot Selection Menu:
> Brand   | Possible Keys
> --------|--------------
> Acer    | `F2`
> Dell    | `F12`
> HP      | `ESC`
> Phoenix | `F12`

Make sure to boot new host server from the media: you should be able to select the `USB / Removable Drive` or `CD / Optical Drive` from the BIOS `Boot Selection Menu`.

### 3) If the boot is successful, you will see a FreeBSD `login:` prompt, type:

```
root
```

Then at the `Password:` prompt, type:

```
[password]
```

### 4) Configure network interface on new host server manually with a command like:

```
ifconfig [network_if] inet [ip_address]/32
```

### 5) Edit the CSV network map:

Plug in the USB to a working computer and edit the `/server/csv/dhcpd/[company].csv` file with a plain text editor.

1. Append the new host server(s) MAC/Hardware address, hostname, IP address.
2. You need to modify / verify:

Line | Description
-----|------------
dhcp-boot,tag:!gpxe,lpxelinux.0,192.168.0.200                    | PXE boot service IP
dhcp-failover,primary,192.168.0.121                              | Primary DHCP service IP
dhcp-failover,secondary,192.168.0.141                            | Secondary DHCP service IP
dhcp-option,option:dns-server,192.168.0.200,208.67.222.222       | DNS IP
dhcp-option,option:router,192.168.0.1                            | Router internal IP
dhcp-option,option:domain-name,contoso.local                     | Local domain name
dhcp-range,192.168.0.10,192.168.0.19                             | First DHCP range for DHCP service
dhcp-range,192.168.0.20,192.168.0.29                             | Additional DHCP range for DHCP service
dhcp-subnet,192.168.0.0,255.255.255.0                            | Network and subnet
dhcp-host,00:00:00:00:12:34,alfa,192.168.0.120,localchain,static | Host server with static IP

### 6) **Warning:** If the HDD have data, you may need to erase them:

***BE EXTRA CAREFUL AND MAKE SURE YOU DON'T NEED ANY DATA ON THESE DRIVES, THEN CONTINUE WITH:***

In the following example, we are wiping the partition table of `/dev/ada0` and `/dev/ada1`

```
destroygeom -d ada0 -d ada1
```

### 7) Install the `NOX` recovery image:

This script will automatically detect available disks and create a ZFS mirror, if applicable:

```
mfsbsd-install
```

### 8) After the host server reboots twice, unplug the USB drive or eject the CD.

Login again as per step 3.

### 9) Create the network service jails:

For all services listed in the Summary section (above):

```
jrolerecover dhcpd
```

or for all services *EXCEPT* dhcpd:

```
jrolerecover pxe
```

### 10)* Compile a new FreeBSD patch or release (takes many hours):

**This step is optional, and requires a fast Internet connection!*

If you choose to do this, you can skip steps 11 and 12.

```
startsvnbuilder
```

### 11)* Compile updated ports into a pkgng repository (takes a few hours):

**This step is optional, and requires a fast Internet connection!*

If you choose to do this, you can skip step 12.

```
startmfsbsdbuilder ports
```

### 12) Build a new `NOX` recovery image (takes a few minutes):

```
startmfsbsdbuilder
```

### 13) New USB, CD, and tar `NOX` recovery images can be listed at:

```
ls -lh /usr/jails/mfsbsd*/root/mfsbsd/NOX*
```

Plug in a new USB, and the new `NOX` recovery image can be written to the USB drive with a command like:

```
writenoxusb /dev/da0
```
