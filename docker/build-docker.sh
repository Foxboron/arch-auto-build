#!/bin/bash
docker build --no-cache=true -t arch-build .
PWD=`pwd`
ID=$(docker run --privileged --rm -i -v /srv/repo:/repos -v /sys/fs/cgroup/systemd/docker:/sys/fs/cgroup/systemd/docker -v $PWD/config:/config -d arch-build bash)
echo $ID
docker exec $ID /usr/bin/add-repo.sh
docker exec $ID /usr/bin/install-chroot.sh
#docker exec -it $ID /usr/bin/bash
for keyring in ./gnupg/pubring.{kbx,gpg}; do
    [[ -r $keyring ]] || continue
    docker cp $keyring $ID:/build/.gnupg/ 
done 
docker commit $ID arch-build
docker stop $ID
