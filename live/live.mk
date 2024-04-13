# $Ragnarok: live.mk,v 1.8 2024/04/13 17:22:05 lecorbeau Exp $

# iso-specific config file

PUBLISHER	= Ian LeCorbeau
ISO_MODE	= live
HDD_LABEL	= RAGNAROK
LIVE_BOOTPARAMS	= live-config.hooks=filesystem live-config.locales=en_CA.UTF-8 \
		  live-config.timezone=Canada/Eastern live-config.hostname=ragnarok \
		  live-config.noautologin live-config.sysv-rc=openntpd slab_nomerge \
		  init_on_alloc=1 init_on_free=1 page_alloc.shuffle=1 pti=on \
		  randomize_kstack_offset=on vsyscall=none debugfs=off \
		  lockdown=confidentiality
KERNEL		= 6.1.85
REV		= 1
DEBKERNEL	= 6.1.0-20
