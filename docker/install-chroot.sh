#!/bin/bash
dbus-uuidgen > /etc/machine-id
mkdir -p /var/lib/aurbuild/x86_64
mkarchroot /var/lib/aurbuild/x86_64/root base-devel git namcap
echo "nobody ALL=NOPASSWD: ALL" >> /var/lib/aurbuild/x86_64/root/etc/sudoers
