#!/bin/ksh

# Quickly install the latest firefox from Mozilla.
# This downloads the tarball, extracts it, creates appropriate directories,
# create symlink in .local/bin and, unless overriden, sets up a default profile
# with a custom user.js which provides better privacy and security.

set -e

VERSION="116.0.3"
LOC=${LOCALE:-en-CA}
NAME="firefox-${VERSION}.tar.bz2"
URL="https://download-installer.cdn.mozilla.net/pub/firefox/releases/${VERSION}/linux-x86_64/${LOC}/${NAME}"
USERSETUP=${USERSETUP:-yes}

[[ $(id -u) == 0 ]] && printf '%s\n' "Do not run this script as root." && exit 1

# Creating a default profile and copying user.js if USERJS=yes
create_profile() {
	local _profile

	_profile="default-release"

	/home/user/.local/bin/ff-release -CreateProfile "${_profile}"

	_pname=$(find .mozilla/firefox/ -type d -name "*.${_profile}")
	
	cp /home/user/.local/src/ff/user.js "${_pname}/"
	cp -r /home/user/.local/src/ff/extensions "${_pname}/"

	printf '%s\n' "Will launch firefox in 5 seconds. This will set the default profile."
	sleep 5
	/home/user/.local/bin/ff-release -P "${_profile}" &
}

upd_path() {
	printf '%s\n' "Updating dmenu path..."
	[[ -f /home/user/.cache/demnu_run ]] && rm /home/user/.cache/dmenu_run
	dmenu_path
}

mkdir -p /home/user/{.firefox,Downloads}
printf '%s\n' "Downloading ${NAME}..."
wget -q --show-progress -O Downloads/"${NAME}" "${URL}"
printf '%s\n' "Extracting..."
tar -xvf Downloads/"${NAME}" -C /home/user/.firefox --strip-components=1
printf '%s\n' "Creating symlink..."
mkdir -p /home/user/.local/bin
ln -sf /home/user/.firefox/firefox /home/user/.local/bin/ff-release
upd_path
[[ $USERSETUP == yes ]] && create_profile
printf '%s\n' "Done"
