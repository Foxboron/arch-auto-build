FROM archlinux/base
RUN pacman -Sy
RUN pacman -S base-devel git devtools vim --noconfirm
RUN mkdir /home/build
RUN echo "nobody ALL=NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/build
RUN pacman -Sy
RUN git clone https://aur.archlinux.org/aurutils.git
RUN git clone https://aur.archlinux.org/cower.git
RUN chmod -R 777 /home/build
WORKDIR /home/build/aurutils
RUN sudo -u nobody makepkg -sric --noconfirm
WORKDIR /home/build/cower
RUN sudo -u nobody makepkg -sric --noconfirm --skippgpcheck
RUN mkdir /var/cache/pacman/pkg

RUN mkdir /repos
RUN chmod 777 /repos
VOLUME /repos

RUN pacman -Sy
RUN mkdir /aur
RUN chmod 777 /aur
VOLUME /aur
WORKDIR /aur

COPY build.sh /usr/bin/build.sh
COPY install-chroot.sh /usr/bin/install-chroot.sh
CMD ["/bin/bash"]
