# Disaster Recovery With USB / Setting Up A New Network

## Summary

These instructions will assist in setting up a FreeBSD host server with jails running:

- DHCP service
- PXE boot service
- pkgng repository http service
- FreeBSD distribution http service

## Requirements

- New host server(s) with 64-bit CPU that have AES-NI capability
  - Recommended: 2 host servers for DHCP failover
- Lots of RAM (6+ GB)
- 2 hard disk drives [HDD] (500+ GB)

## Definitions

Variable         | Example       | Description
-----------------|---------------|------------
[password]       |               | Default is empty / blank.
[company]        | contoso       | Needed in step 7. Company short name.
[router_ip]      | 192.168.0.1   | Needed in step 7. The router's IP address. If the router is running DHCP, can be found by running `net-router`.
[ip_address]     | 192.168.0.120 | Needed in step 7. An address currently unassigned (it will become the host IP). Please ensure the next IP is also unassigned.
[ip_address + 1] | 192.168.0.121 | It will become the DHCP service IP address if you enable `dhcpd` in step 9.
[network_if]     | re0           | May be needed in step 7. The primary network interface. If network cables are plugged in, can be found by running:

```
net-nic
```

or list all the active possibilities:

```
net-nicsactive
```

But ignoring any interfaces that look like:

- bridge[0-9]
- enc[0-9]
- gif[0-9]
- ipfw[0-9]
- lo[0-9]
- pflog[0-9]
- plip[0-9]
- tap[0-9]
- tun[0-9]


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
3. `Network / PXE Boot`


### 2) Insert CD or USB media containing `NOX` recovery image into new host server.

Reboot with `Ctrl + Alt + Del` and access the `Boot Selection Menu`:

> To access the Boot Selection Menu:
> Brand   | Possible Keys
> --------|--------------
> Acer    | `F2`
> Dell    | `F12`
> HP      | `ESC`
> Phoenix | `F12`

Make sure to boot new host server from the media: you should be able to select the USB / Removable Drive, although it may also be listed under Hard Disk from the BIOS `Boot Selection Menu`.


### 3) If the boot is successful:

After about, 5 - 10 minutes you will see a FreeBSD `login:` prompt.

> You may need to press the Enter/Return key a few times.

Type the username:

```
root
```

Then at the `Password:` prompt, enter the `[password]` listed above.

> At this point, you will have a prompt like:
> ```
> root  /root
> #
> ```

For ease of copy and paste, you may be able to start a GUI session with:

```
startgui
```

If that doesn't work, press `Ctrl + C` several times (this will interrupt the running process), and then try a variation of:

```
startgui nofbdev
startgui nointel
startgui novesa
startgui nofbdev nointel
startgui nofbdev novesa
startgui nointel novesa
```

> To find these instructions so you can copy and paste the commands:
> Open the `File System` icon and go to `/server/root/mfsbsd/RECOVER.md`.


### 4) **Warning:** If the HDD have data, you may need to erase them:

***BE EXTRA CAREFUL AND MAKE SURE YOU DON'T NEED ANY DATA ON THESE DRIVES, THEN CONTINUE WITH:***

In the following example, we are wiping the partition table of 2 HDDs, `/dev/ada0` and `/dev/ada1`

```
destroygeom -d ada0 -d ada1
```


### 5) Install the `NOX` recovery image:

This script will automatically detect available disks and create a ZFS mirror, if applicable:

```
mfsbsd-install
```


### 6) After the host server reboots twice, unplug the USB drive or eject the CD.

Login again as per step 3.

> Remember, you can also start a GUI session.


### 7) Edit the CSV network map:

The network map is basically a list of all the computers (or at least servers) connected to the network.

> The MAC / Hardware / Ethernet address needed below can be found with
> ```
> net-nicmac
> ```
> or
> ```
> net-nicmacactive
> ```

Edit the `/server/csv/dhcpd/[company].csv` file with a plain text editor.

> If you are in a GUI session, open the `File System` icon and go to the file.

If not in a GUI session, you may be able to edit via the command line with:

```
edit /server/csv/dhcpd/[company].csv
```

1. Append the new host server(s) MAC / Hardware / Ethernet address, hostname, IP address.
2. You need to modify / verify:

Line | Description
-----|------------
dhcp-boot,tag:!gpxe,lpxelinux.0,192.168.0.200                    | PXE boot service IP. This IP is used with `ucarp` failover.
dhcp-failover,primary,192.168.0.121                              | [ip_address + 1] PRIMARY DHCP service IP
dhcp-failover,secondary,192.168.0.141                            | [ip_address + 1] SECONDARY DHCP service IP
dhcp-option,option:dns-server,8.8.8.8,208.67.222.222             | DNS IP (Usually Windows AD server, Google and OpenDNS are listed as examples)
dhcp-option,option:router,192.168.0.1                            | [router_ip] Router internal IP. This is the default route, aka default gateway.
dhcp-option,option:domain-name,contoso.local                     | Local domain name
dhcp-range,192.168.0.10,192.168.0.19                             | First DHCP range for DHCP service. Most known devices we set as DHCP reservations, so these are usually for guests.
dhcp-range,192.168.0.20,192.168.0.29                             | Additional DHCP range for DHCP service. If all the devices are brand new, you may want to increase these and remove a lot of the `dhcp-host` lines.
dhcp-subnet,192.168.0.0,255.255.255.0                            | Network and subnet
dhcp-host,00:00:00:00:12:34,alfa,192.168.0.120,localchain,static | [ip_address] Example PRIMARY host server with static IP.
dhcp-host,00:00:00:00:56:78,beta,192.168.0.140,localchain,static | [ip_address] Example SECONDARY host server with static IP.

**Save the file.**


### 8) To apply and test the changes to the network map, run the command:

```
cron-csv-detect-diff
```

At this point, if you do the following and get a bunch of numbers, your network is working:

```
host google.ca
```

If you don't see a response like `google.ca has address XX.XX.XX.XX` then restart from step 7.


### 9) Create the network service jails:

If you are setting up a network with a router / RocketHub and you don't know how to turn the router's DHCP off:

```
jrolerecover pxe
```

For full recovery with DHCP, and assuming you edited modified `dhcp-failover` from step 8:

```
jrolerecover dhcpd
```

### 10)* Compile a new FreeBSD patch or release (takes many hours):

**This step is optional, and requires a fast Internet connection to download the FreeBSD source!*

If you choose to do this, you can skip steps 11 and 12.

```
startsvnbuilder
```


### 11)* Compile updated ports into a pkgng repository (takes a few hours):

**This step is optional, and requires a fast Internet connection to download the ports files!*

If you choose to do this, you can skip step 12.

```
startmfsbsdbuilder ports newkey
```


### 12) Build a new `NOX` recovery image (takes a few minutes):

**This builds a new `NOX` recovery image which is a modified mfsBSD image from the existing source code located in `/server/root/mfsbsd`**

```
startmfsbsdbuilder newkey
```


### 13) When complete, new USB, CD, and tar `NOX` recovery images can be listed at:

```
ls -lh /usr/jails/mfsbsd*/root/mfsbsd/NOX*
```

Plug in a new USB, and the new `NOX` recovery image can be written to the USB drive with a command like:

```
writenoxusb /dev/da0
```


### 14) SECONDARY new host server can now be plugged in to the network.

Repeat from step 1 to 9, with modification of step 2 to boot via Network / PXE Boot.

When step 9 is complete on the SECONDARY new host, stop the jails:

```
stopezjail
```


### 15) On the PRIMARY new host server:

If you did 10 or 11 the first time, migrate the data from the PRIMARY new host to the SECONDARY new host:

```
jrolesenddata poudriere [secondserver_ip]
```

```
jrolesenddata pxe [secondserver_ip]
```

Then sync the jails over from the PRIMARY to SECONDARY new host:

```
jrolesendjail pxe.lanctl.local [secondserver_ip]
```

```
jrolesendjail pkgng.lanctl.local [secondserver_ip]
```

```
jrolesendjail freebsd-dist.lanctl.local [secondserver_ip]
```


### 16) SECONDARY new host server should be rebooted:

```
reboot
```
