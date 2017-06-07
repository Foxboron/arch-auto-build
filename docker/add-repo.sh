#!/bin/bash

if [[ ! -e "/etc/pacman.d/$1" ]]; then
	echo "Include = /etc/pacman.d/$1" >> /etc/pacman.conf
	cat >/etc/pacman.d/$1<<EOL
[options]
CacheDir = /var/cache/pacman/pkg
CleanMethod = KeepCurrent

[$1]
SigLevel = Optional TrustAll
Server = file:///repos/$1
EOL
	mkdir -p /repos/$1
	repo-add /repos/$1/$1.db.tar
	chown -R nobody:nobody /repos/$1

fi
