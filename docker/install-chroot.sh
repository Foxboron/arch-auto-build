#!/bin/bash
dbus-uuidgen > /etc/machine-id

machine=$(uname -m)
readonly machine

var_tmp=$(mktemp -d "${TMPDIR:-/var/tmp}/$argv0".XXXXXXXX)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/$argv0".XXXXXXXX)

cp /config/makepkg.conf /etc/makepkg.conf || true

mkdir -p /var/lib/build/
mkarchroot  -C /etc/pacman.conf -M /etc/makepkg.conf /var/lib/build/root base-devel namcap
