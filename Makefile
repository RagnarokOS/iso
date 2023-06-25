# Makefile for creating Ragnarok iso/releases/miniroot/sets.
# Work in progress

# Usage:
# 'make' will create a live configuration + the boot.tgz and x11.tgz sets.
# This should never be run as root.
#
# 'make release' will create miniroot.tgz, base.tgz and the ISOs. This is
# equivalent to 'Make install', so it must be run as root.

include config.mk

NAME		= ${DISTRO}${VERSION}

all: live-config boot x11

# Using live-build for now.
# see: https://ragnarokos.github.io/logs/devnotes-june-2023.html
live-config:

release: miniroot base iso

miniroot:
	SOURCE_DATE_EPOCH=$(date +%s) /usr/bin/mmdebstrap --variant=${VARIANT} \
			  --components="${COMPONENTS}" \
			  --include="${PACKAGES}" \
			  --hook-directory="${HOOK_DIR}/miniroot" \
			  ${FLAVOUR} ${DESTDIR}/miniroot${VERSION}.tgz

base:
	SOURCE_DATE_EPOCH=$(date +%s) /usr/bin/mmdebstrap --variant=${VARIANT} \
			  --components="${COMPONENTS}" \
			  --include="${PACKAGES} ${RELEASE_PKGS}" \
			  --hook-directory=${HOOK_DIR}/release \
			  ${PARENT} ${DESTDIR}/${NAME}.tgz

iso:

# Not ready. Sign manually for now
sign:
	/usr/bin/mksig ${NAME}.tgz
	/usr/bin/mksig ${ISO_NAME}.iso
