FROM archlinux/base
RUN pacman -Sy
RUN pacman -S git devtools vim pacutils sudo --noconfirm

RUN mkdir /repos
RUN chmod 777 /repos
VOLUME /repos

RUN mkdir /config
VOLUME /config

RUN pacman -Sy
RUN mkdir -p /build/{build,.gnupg}
RUN chmod 777 -R /build
VOLUME /build/build
WORKDIR /build/build

RUN useradd -m -s /bin/bash -d /build build 
RUN echo "build ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY build.sh /usr/bin/build.sh
COPY install-chroot.sh /usr/bin/install-chroot.sh
COPY add-repo.sh /usr/bin/add-repo.sh
CMD ["/bin/bash"]
