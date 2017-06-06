#!/bin/bash
if [ -z "$1" ]; then 
	echo "We need to initialize a repositry. ./build-docker.sh {{repo}}";
	exit
fi
docker build --no-cache=true -t arch-build .
ID=$(docker run --privileged -v /srv/repo/$1:/repos/$1 -v /sys/fs/cgroup/systemd/docker:/sys/fs/cgroup/systemd/docker -d arch-build bash)
echo $ID
docker exec $ID /usr/bin/install-chroot.sh
docker exec $ID /usr/bin/add-repo.sh $1
docker commit $ID arch-build
docker stop $ID
