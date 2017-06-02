#!/bin/bash

# Check if there is a repo for this
add-repo.sh $1

# lets get the AUR PKGBUILDS
cower -p */PKGBUILD -dd
chown -R nobody:nobody *
aurqueue * > queue

# aurutils will do the building and repo management
sudo -u nobody aurbuild -c -d $1 -a queue

# Cleanup
rm -rf /var/lib/aurbuild/x86_64/nobody*
exit
