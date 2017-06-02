#!/bin/bash

REPO=$1
PKG=$1

# Check if there is a repo for this
add-repo.sh $REPO

pacman -Sy

# lets get the AUR PKGBUILDS
cower -p */PKGBUILD -dd
chown -R nobody:nobody *

# Ugly hack - lets find all unique packages
# cower downloads PKBUILDS even if they are are inn
# a binary repo. So we sort out the ones available inn
# our repo before passing it to aurbuild.
# We need this so we rely on dependant builds
pacman -Sl $REPO | cut -d" " -f2 > ignores
comm -13 <(sort ignores) <(sort queue) > queue

# Insert out built package back into the queue so it get built
echo "$PKG" > queue

# aurutils will do the building and repo management
sudo -u nobody aurbuild -c -d $REPO -a queue

# Cleanup
rm -rf /var/lib/aurbuild/x86_64/nobody*
exit
