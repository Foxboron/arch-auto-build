#!/bin/bash
if [ -z ${var+x} ]; then 
	echo "We need to initialize a repositry. ./build-docker.sh {{repo}}";
	exit
fi
docker build -t arch-build .
ID=$(docker run --privileged -it -v /srv/repo/$1:/var/cache/pacman/$1 -v /sys/fs/cgroup/systemd/docker:/sys/fs/cgroup/systemd/docker -d arch-build bash)
echo $ID
docker exec -it $ID /usr/bin/install-chroot.sh
docker exec -it $ID /usr/bin/add-repo.sh $1
docker commit $ID arch-build
docker stop $ID
