#!/bin/bash
dbus-uuidgen > /etc/machine-id

machine=$(uname -m)
readonly machine

var_tmp=$(mktemp -d "${TMPDIR:-/var/tmp}/$argv0".XXXXXXXX)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/$argv0".XXXXXXXX)
readonly makepkg_conf=${makepkg_conf-/usr/share/devtools/makepkg-$machine.conf}

mkdir -p /var/lib/build/
mkarchroot  -C /etc/pacman.conf -M "$makepkg_conf" /var/lib/build/root base-devel namcap
