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
    if [[ $(pacman -Sl "$REPO" | grep "$1" | cut -d" " -f2) == "" || $PKG == $1 ]]; then
        echo $1
    fi
}
aurchain * | while read -r CHAINPKG _; do check $CHAINPKG; done > /tmp/queue

# aurutils will do the building and repo management
sudo -u nobody aurbuild -c -d $REPO -a /tmp/queue
EXIT_CODE=$?

# Clean up repo
rm /repos/$REPO/*~ || true
rm /repos/$REPO/*.old || true

exit $EXIT_CODE
