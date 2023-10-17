#!/bin/sh

# Customize script
# $Ragnarok: customize01.sh,v 1.3 2023/10/17 15:19:55 lecorbeau Exp $

set -e

# Set up the _sysupdate user. Needs to be done first.
chroot "$1" useradd --system --no-create-home --home /nonexistent --shell=/usr/sbin/nologin _sysupdate

# Copy then install dummy packages
mkdir -p "$1"/usr/src/ragnarok
cp dummies/* "$1"/usr/src/ragnarok/
for _file in base-files.conffiles base-files.list base-files.md5sums base-files.postinst; do
	rm "$1"/var/lib/dpkg/info/"$_file"
done
chroot "$1" dpkg -i /usr/src/ragnarok/base-files_99+ragnarok01_amd64.deb
chroot "$1" dpkg -i /usr/src/ragnarok/ed_99+ragnarok01_amd64.deb

# Enable the wheel group
sed -i '15 s/^# //' "$1"/etc/pam.d/su
chroot "$1" addgroup --system wheel

# Add ksh to /etc/shells
chroot "$1" add-shell /bin/ksh

# Making sure root's interactive shell is ksh
sed -i 's/bash/ksh/g' "$1"/etc/passwd

# Set the default DEBIAN_FRONTEND to 'Readline'
chroot "$1" echo 'debconf debconf/frontend select Readline' | debconf-set-selections

# Fix the symlinks
chroot "$1" ln -sf /etc/dpkg/origins/ragnarok /etc/dpkg/origins/default
chroot "$1" ln -sf /usr/lib/os-release /etc/os-release