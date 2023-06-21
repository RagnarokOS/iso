#!/bin/sh

set -e

# Enable the wheel group
sed -i '15 s/^# //' "$1"/etc/pam.d/su
chroot "$1" addgroup --system wheel

# Making sure root's interactive shell is ksh
sed -i 's/bash/ksh/g' "$1"/etc/passwd

# Symlinking signify-openbsd to signify
chroot "$1" ln -sf /usr/bin/signify-openbsd /usr/bin/signify

# Set the default DEBIAN_FRONTEND to 'Readline'
chroot "$1" echo 'debconf debconf/frontend select Readline' | debconf-set-selections

# Needed to make the rootfs reproducible
rm "$1"/etc/resolv.conf
rm "$1"/etc/hostname
