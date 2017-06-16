#!/bin/bash
# I'm so sorry alad :c
set -e

REPO=$1
PKG=$2

readonly base=/build/build

root=/repos

chmod 777 "$base/$PKG"

var_tmp=$(mktemp -d "${TMPDIR:-/var/tmp}/$argv0".XXXXXXXX)

# libmakepkg/util/util.sh
_canonicalize_path() {
    readlink -ev -- "$1"
}

source /usr/share/makepkg/util.sh

sudo arch-nspawn -M /etc/makepkg.conf \
    -C /etc/pacman.conf \
	/var/lib/build/root pacman -Syu --noconfirm

cd_safe "$base/$PKG"
sudo -u build sudo PKGDEST="$var_tmp" makechrootpkg -d $root -r /var/lib/build -cun

root=/repos/$REPO

cd_safe "$var_tmp"
pkg=(./*)
mv "$pkg" -t "$root"
db_path=$(_canonicalize_path "$root/$REPO".db)


cd_safe "$root"

while [ -f $root/$REPO.db.tar.lck ]
do
    sleep 2
done
repo-add -R "$db_path" "${pkg#./}"
#repose -zf $REPO
