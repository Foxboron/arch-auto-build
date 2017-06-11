#!/bin/bash
repolist=(/config/repos/*)
cp /config/pacman.conf /etc/pacman.conf || true
cp /config/pacman.conf /etc/pacman.conf.orig || true

for repo in "${repolist[@]}"; do
	if ! pacconf --repo=${repo#/config/repos} 2> /dev/null; then
		cat $repo >> /etc/pacman.conf
		mkdir -p /repos/${repo#/config/repos}
		repo-add -R /repos/${repo#/config/repos}/${repo#/config/repos}.db.tar
	fi
done

pacman -Sy
