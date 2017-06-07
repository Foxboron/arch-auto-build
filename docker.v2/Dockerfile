FROM archlinux/base
RUN pacman -Sy
RUN pacman -S base-devel git devtools vim pacutils --noconfirm
RUN echo "nobody ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir /repos
RUN chmod 777 /repos
VOLUME /repos

RUN mkdir /config
VOLUME /config

RUN pacman -Sy
RUN mkdir /build
RUN chmod 777 /build
VOLUME /build
WORKDIR /build

COPY build.sh /usr/bin/build.sh
COPY install-chroot.sh /usr/bin/install-chroot.sh
COPY add-repo.sh /usr/bin/add-repo.sh
CMD ["/bin/bash"]
