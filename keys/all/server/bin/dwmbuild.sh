#!/bin/sh
# Copyright (c) 2014 John Ko

/bin/rm -r /tmp/dwmpkg > /dev/null 2>&1
/bin/mkdir ~/src > /dev/null 2>&1
for project in dmenu dwm dwmsd
do
  if [ -e ~/src/${project} ]; then
    rm -r ~/src/${project}
  fi
  /usr/local/bin/git clone https://github.com/johnko/${project} ~/src/${project} || exit 1
  cd ~/src/${project}
  /usr/local/bin/gmake DESTDIR=/tmp/dwmpkg install || exit 1
done
cd /tmp/dwmpkg
chmod 755 usr
chmod 755 usr/local
/bin/rm dwm.tar dwm.tar.xz builder-pubkey.asc builder-pubkey.asc.sig > /dev/null 2>&1
/server/bin/bs e || exit 1
/server/bin/bs si || exit 1
/usr/bin/tar -c -f dwm.tar builder-pubkey.asc builder-pubkey.asc.sig ./usr || exit 1
/usr/bin/xz -z dwm.tar || exit 1
/bin/mv dwm.tar.xz ~/dwm.txz || exit 1
/bin/ls -lFAG ~/dwm.txz

