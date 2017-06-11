#!/bin/bash
dbus-uuidgen > /etc/machine-id

cp /config/makepkg.conf /etc/makepkg.conf || true

mkdir -p /var/lib/build/
mkarchroot  -C /etc/pacman.conf -M /etc/makepkg.conf /var/lib/build/root base-devel namcap git
