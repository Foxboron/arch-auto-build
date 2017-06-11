arch-auto-build
========

This project is WIP!

The goal of this project is to build Arch packages. It creates a docker image with a clean arch chroot where packages can be built.

Running install: [https://build.velox.pw](https://build.velox.pw)


### docker
This image creates a build user and utilizes devtools to build packages in a clean chroot. The image works as a wrapper
for any Arch tools we need to use to build packages.

### buildbot
Currently there is a simple .SRCINFO parser and dependency resolver inside buildbot. It probably works, but it havent
been tested on complicated build chains. It should be enough to build simple packages and dependencies.

## Installation
Currently there are some hardcoded defaults inside the buildbot master.cfg. The plan is to refactor this out into a config
file. It can build the docker images on its own, and relies on local workers currently. Remote workers will be solved
one day.

```
# Creates docker image arch-build
$ cd docker
$ ./build-docker.sh
```

If you need to created packages that utilize PGP signatures, a keyring can be made under the docker directory:
```
$ mkdir docker/gnupg && cd docker/gnupg
$ gpg --no-default-keyring --keyring ./pubring.gpg --recv [[KEYID]]
```
Rerun the build step for this to take effect

## Building packages
`bin/build-package` is assumed to be installed into path by buildbot.

Example building a package:
```
$ git clone https://github.com/Foxboron/PKGBUILDS
$ cd PKGBUILDS
# build-package [[repository]] [[package]]
$ build-package foxboron python2-humanize
```

#### Docker notes
Docker needs access to cgroup to use systemd-nspawn, `mkarchroot/arch-nspawn` from devtools relies on this. This means docker will
need to run with the `--privileged` flag and mount with `-v /sys/fs/cgroup/systemd/docker:/sys/fs/cgroup/systemd/docker`.
There is also an assumption that the repositories on the host is located inn `/srv/repos`.

## Signing
This will be solved with [remote-sign](https://github.com/Foxboron/remote-sign).


