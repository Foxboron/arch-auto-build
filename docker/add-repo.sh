#!/bin/bash

if [ ! -d "/var/cache/pacman/$1" ]; then
	echo "Include = /etc/pacman.d/$1" >> /etc/pacman.conf
	mkdir /var/cache/pacman/$1
	chmod 777 /var/cache/pacman/$1
	chown -R nobody:nobody /var/cache/pacman/$1
	cat >/etc/pacman.d/$1<<EOL
[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = /var/cache/pacman/$1
CleanMethod = KeepCurrent

[$1]
SigLevel = Optional TrustAll
Server = file:///var/cache/pacman/$1
	EOL
	repo-add /var/cache/pacman/$1/$1.db.tar

fi
