#!/bin/bash

if [ ! -d "/var/cache/pacman/$1" ]; then
	echo "Include = /etc/pacman.d/$1" >> /etc/pacman.conf
	mkdir /repos/$1
	chmod 777 /repos/$1
	chown -R nobody:nobody /var/cache/pacman/$1
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

fi
