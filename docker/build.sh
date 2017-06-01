#!/bin/bash
cower -p */PKGBUILD -dd
aurqueue * > queue
sudo -u nobody aurbuild -c -a queue
rm -rf /var/lib/aurbuild/x86_64/nobody*
