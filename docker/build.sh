#!/bin/bash
cower -p */PKGBUILD -dd
chown -R nobody:nobody *
aurqueue * > queue
sudo -u nobody aurbuild -c -d $1 -a queue
rm -rf /var/lib/aurbuild/x86_64/nobody*
exit
