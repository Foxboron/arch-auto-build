arch-auto-build
========

This project is WIP!

The goal of this project is to build Arch packages. It creates a docker image with a clean arch chroot where packages can be built.

Running install: [https://build.velox.pw](https://build.velox.pw)


### docker.v2 - arch-build
This one only uses devtools and creates and managed a chroot on its own. Repos are defined inside `config/repos` and can
defined at will. They will be created and managed by the container using normal devtools.


### docker - arch-aur-build
This is the horrible one. It uses cower and aurutils to manage a repo. Repos are defined by using `add-repo.sh`
inside the container. `build.sh` creates it on the fly as well.

Horrible part: it downloads AUR dependencies without consulting with you. Use at own risk.


### buildbot
Currently there is a simple .SRCINFO parser and dependency resolver inside buildbot. It probably works, but it havent
been tested on complicated build chains. It should be enough to build simple AUR packages and dependencies.


## Installation
Currently there are some hardcoded defaults inside the buildbot master.cfg. The plan is to refactor this out into a config
file. It can build the docker images on its own, and relies on local workers currently. Remote workers will be solved
one day.

```
# Creates docker image arch-build
$ cd docker.v2
$ ./build-docker.sh

# Creates docker image arch-aur-build
$ cd docker
$ ./build-docker.sh <repository name>
```

`bin/build-package` is assumed to be installed into path by buildbot.

Example running without buildbot:
```
$ git clone https://github.com/Foxboron/PKGBUILDS build
$ ./arch-auto-build/bin/build-package python2-humanize
```

#### Docker notes
Docker needs access to cgroup to use systemd-nspawn, `mkarchroot/arch-nspawn` from devtools relies on this. This means docker will
need to run with the `--privileged` flag and mount with `-v
/sys/fs/cgroup/systemd/docker:/sys/fs/cgroup/systemd/docker`.
There is also an assumption that the repositories on the host is located inn `/srv/repos`.

## Signing
This will be solved with [remote-sign](https://github.com/Foxboron/remote-sign).


