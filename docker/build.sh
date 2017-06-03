#!/bin/bash

REPO=$1
PKG=$2

# Check if there is a repo for this
add-repo.sh $REPO

pacman -Sy

# lets get the AUR PKGBUILDS
cower -p */PKGBUILD -dd
chown -R nobody:nobody *

# Check all packages for something inn our repo.
# If it is there, we dont care for the AUR package
check(){
    if [[ $(pacman -Sl $REPO | grep $1 | cut -d" " -f2) == "" || $PKG == $1 ]]; then
        echo $pkg
    fi
}
aurchain * | while read -r pkg _; do check $PKG; done > /tmp/queue

# aurutils will do the building and repo management
sudo -u nobody aurbuild -c -d $REPO -a /tmp/queue
EXIT_CODE=$?

# Clean up repo
rm /repos/$REPO/*~
rm /repos/$REPO/*.old

exit $EXIT_CODE
