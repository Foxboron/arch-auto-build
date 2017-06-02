#!/bin/bash

if [ ! -d "/repos/$1/$1.db.tar" ]; then
	echo "Include = /etc/pacman.d/$1" >> /etc/pacman.conf
	cat >/etc/pacman.d/$1<<EOL
[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = /repos/$1
CleanMethod = KeepCurrent

[$1]
SigLevel = Optional TrustAll
Server = file:///repos/$1
EOL
	repo-add /repos/$1/$1.db.tar
	chown -R nobody:nobody /repos/$1

fi
