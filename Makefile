# Makefile for user-mode-linux with a simple busybox/uClibc root filesystem
#
# Copyright (C) 2001 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2001 by Alcove, Julien Gaulmin <julien.gaulmin@fr.alcove.com>
# Copyright (C) 2001 by Jon Nelson <jnelson@boa.org>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Library General Public License for more
# details.
#
# You should have received a copy of the GNU Library General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Known problems :
#  - genext2fs: couldn't allocate a block (no free space)
#    As genext2fs allocate only one group of blocks, the FS size
#    is limited to 8Mb.

# Update this stuff by hand :
ARCH = i386
# If you are running a cross compiler, you may want to set this
# to something more interesting, like "arm-linux-".
#CROSS = $(ARCH)-linux-

#IMAGE_SIZE=8192 # Max size
#IMAGE_INODES=500
IMAGE_SIZE=550 # library is 550K
IMAGE_INODES=300

LINUX_SOURCE=linux-2.4.14.tar.bz2
LINUX_URI=http://www.kernel.org/pub/linux/kernel/v2.4

USERMODELINUX_PATCH=uml-patch-2.4.14-6.bz2
USERMODELINUX_URI=http://prdownloads.sourceforge.net/user-mode-linux

UCLIBC_SOURCE=uClibc-snapshot.tar.gz
UCLIBC_URI=http://uclibc.org/downloads/

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

.SUFFIXES:            # Delete the default suffixes
.SUFFIXES: .c .o .h   # Define our suffix list

# Directories
BASE_DIR=${shell pwd}
TARGET_DIR=$(BASE_DIR)/root
STAGING_DIR=$(BASE_DIR)/staging_dir
SOURCE_DIR=$(BASE_DIR)/sources
LINUX_DIR=$(BASE_DIR)/linux
UCLIBC_DIR=$(BASE_DIR)/uClibc
GENEXT2FS_DIR=$(BASE_DIR)/genext2fs

TARGET_CC=$(STAGING_DIR)/bin/gcc
TARGET_CC1=$(STAGING_DIR)/usr/bin/$(ARCH)-uclibc-gcc
TARGET_CROSS=$(STAGING_DIR)/usr/bin/$(ARCH)-uclibc-
TARGET_PATH=$(STAGING_DIR)/usr/bin:$(STAGING_DIR)/bin:/bin:/sbin:/usr/bin:/usr/sbin

LINUX=$(BASE_DIR)/UMlinux
IMAGE=$(BASE_DIR)/root_fs

KCONFIG=$(SOURCE_DIR)/linux-uml.config

all:   world

#So what shall we build today?
TARGETS=

-include busybox.mk
-include boa.mk

world:	$(TARGETS) $(GENEXT2FS_DIR)/genext2fs $(TARGET_DIR)
	$(GENEXT2FS_DIR)/genext2fs \
	 -b `echo $(IMAGE_SIZE) | bc` \
	 -i `echo $(IMAGE_INODES) | bc` \
	 -d $(TARGET_DIR) \
	 -D $(SOURCE_DIR)/device_table.txt root_fs

$(STAGING_DIR):
	rm -rf $(STAGING_DIR)
	mkdir $(STAGING_DIR)

$(TARGET_DIR):
	rm -rf $(TARGET_DIR)
	tar -xf $(SOURCE_DIR)/skel.tar
	cp -a target_skeleton/* $(TARGET_DIR)/
	-find $(TARGET_DIR) -type d -name CVS -exec rm -rf {} \; > /dev/null 2>&1

# The kernel
$(SOURCE_DIR)/$(LINUX_SOURCE):
	while [ ! -f $(SOURCE_DIR)/$(LINUX_SOURCE) ] ; do \
		wget -P $(SOURCE_DIR) --passive $(LINUX_URI)/$(LINUX_SOURCE); \
	done

$(LINUX_DIR)/.unpacked:	$(SOURCE_DIR)/$(LINUX_SOURCE)
	bunzip2 -c $(SOURCE_DIR)/$(LINUX_SOURCE) | tar -xv
	touch $(LINUX_DIR)/.unpacked

$(SOURCE_DIR)/$(USERMODELINUX_PATCH):
	while [ ! -f $(SOURCE_DIR)/$(USERMODELINUX_PATCH) ] ; do \
		wget -P $(SOURCE_DIR) --passive $(USERMODELINUX_URI)/$(USERMODELINUX_PATCH); \
	done
        
$(LINUX_DIR)/.patched:	$(LINUX_DIR)/.unpacked $(SOURCE_DIR)/$(USERMODELINUX_PATCH)
	bzcat $(SOURCE_DIR)/$(USERMODELINUX_PATCH) | patch -d $(LINUX_DIR) -p1
	cp -f $(KCONFIG) $(LINUX_DIR)/.config
	touch $(LINUX_DIR)/.patched

$(LINUX_DIR)/.um:	$(LINUX_DIR)/.patched
	sed -e 's/^ARCH :=.*/ARCH=um/g' < $(LINUX_DIR)/Makefile > $(LINUX_DIR)/Makefile.new && mv -f $(LINUX_DIR)/Makefile.new $(LINUX_DIR)/Makefile
	touch $(LINUX_DIR)/.um

$(LINUX_DIR)/.configdone:	$(LINUX_DIR)/.um
	make -C $(LINUX_DIR) oldconfig menuconfig
	touch $(LINUX_DIR)/.configdone

$(LINUX_DIR)/.dep:	$(LINUX_DIR)/.configdone
	make -C $(LINUX_DIR) dep
	touch $(LINUX_DIR)/.dep

$(LINUX_DIR)/linux:	$(LINUX_DIR)/.dep
	(cd $(LINUX_DIR); make linux)
        
$(LINUX): $(LINUX_DIR)/linux
	ln -sf $(LINUX_DIR)/linux $(LINUX)

# uClibc
$(SOURCE_DIR)/$(UCLIBC_SOURCE):
	while [ ! -f $(SOURCE_DIR)/$(UCLIBC_SOURCE) ] ; do \
	    wget -P $(SOURCE_DIR) --passive $(UCLIBC_URI)/$(UCLIBC_SOURCE) ; \
	done;

$(UCLIBC_DIR)/Config:	$(SOURCE_DIR)/$(UCLIBC_SOURCE)
	tar -xzf $(SOURCE_DIR)/$(UCLIBC_SOURCE)
	for p in `find $(SOURCE_DIR) -name uClibc-*.patch | sort -g`;do \
		patch -p0 < $$p ; \
	done
	awk 'BEGIN { FS=" ="; REG="DODEBUG|DOLFS|INCLUDE_RPC|DOPIC";} \
	{  if ($$0 ~ "^" REG) { print $$1 " = false" } else { print $$0 } }' < \
	$(UCLIBC_DIR)/extra/Configs/Config.$(ARCH) > $(UCLIBC_DIR)/Config;

$(UCLIBC_DIR)/lib/libc.a:	$(LINUX) $(UCLIBC_DIR)/Config
	$(MAKE) CROSS=$(CROSS) \
		DEVEL_PREFIX=$(STAGING_DIR) \
		SYSTEM_DEVEL_PREFIX=$(STAGING_DIR)/usr \
		SHARED_LIB_LOADER_PATH=/lib \
		KERNEL_SOURCE=$(LINUX_DIR) \
		-C $(UCLIBC_DIR)

uclibc:	$(UCLIBC_DIR)/lib/libc.a $(STAGING_DIR) $(TARGET_DIR)
	@if [ $(UCLIBC_DIR)/lib/libc.a -nt $(UCLIBC_DIR)/.installed ]; then \
		rm -f $(UCLIBC_DIR)/.installed; \
		set -x; \
		$(MAKE) \
		DEVEL_PREFIX=$(STAGING_DIR) \
		SYSTEM_DEVEL_PREFIX=$(STAGING_DIR)/usr \
		SHARED_LIB_LOADER_PATH=$(STAGING_DIR)/lib \
		-C $(UCLIBC_DIR) install; \
		touch $(UCLIBC_DIR)/.installed ; \
	fi
	@if [ $(UCLIBC_DIR)/lib/libc.a -nt $(UCLIBC_DIR)/.installed_runtime ]; then \
		rm -f $(UCLIBC_DIR)/.installed_runtime; \
		$(MAKE) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/ \
		SYSTEM_DEVEL_PREFIX=/usr \
		SHARED_LIB_LOADER_PATH=/lib \
		-C $(UCLIBC_DIR) install_runtime; \
		touch $(UCLIBC_DIR)/.installed_runtime ; \
	fi
        
# genext2fs
$(GENEXT2FS_DIR)/genext2fs:
	$(MAKE) -C $(GENEXT2FS_DIR)

# others
clean:	$(TARGETS_CLEAN)
	make -C $(GENEXT2FS_DIR) clean
	@if [ -d $(UCLIBC_DIR) ] ; then \
		make -C $(UCLIBC_DIR) clean; \
	fi;
	@if [ -d $(LINUX_DIR) ] ; then \
		make -C $(UCLIBC_DIR) clean; \
	fi;
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)
	rm -f *~

mrproper: $(TARGETS_MRPROPER)
	rm -rf $(UCLIBC_DIR);
	rm -rf $(LINUX_DIR);
	rm -f root_fs $(LINUX)
	make -C $(GENEXT2FS_DIR) clean
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)
	rm -f *~

distclean: mrproper $(TARGETS_DISTCLEAN)
	rm -f $(SOURCE_DIR)/$(UCLIBC_SOURCE)
	rm -f $(SOURCE_DIR)/$(USERMODELINUX_PATCH)
	rm -f $(SOURCE_DIR)/$(LINUX_SOURCE)

.PHONY: uclibc $(TARGETS) world test clean mrproper distclean
