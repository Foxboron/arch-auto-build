arch-auto-build
========

This project is WIP!


The goal of this project is to build AUR packages. It creates a docker image with a clean arch chroot where packages can be built.

Technologies:
* buildbot
* aurutils
* cower
* devtools
* docker

Features:
* Build packages from a git repo
* Build packages with changes
* Pull AUR dependencies (We only really care for our own packages)
* Dependent builds. If we have a PKGBUILD for a dependency, build that first.
* Create and update a repository

I havent solved signing yet :/
