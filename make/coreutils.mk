#############################################################
#
# coreutils
#
#############################################################
COREUTILS_SOURCE:=coreutils-4.5.3.tar.bz2
COREUTILS_SITE:=ftp://alpha.gnu.org/gnu/coreutils/
COREUTILS_CAT:=bzcat
COREUTILS_DIR:=$(BUILD_DIR)/coreutils-4.5.3
COREUTILS_BINARY:=src/cat
COREUTILS_TARGET_BINARY:=bin/cat
BIN_PROGS:=cat chgrp chmod chown cp date dd df dir echo false ln ls mkdir \
	mknod mv pwd rm rmdir vdir sleep stty sync touch true uname

$(DL_DIR)/$(COREUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(COREUTILS_SITE)/$(COREUTILS_SOURCE)

coreutils-source: $(DL_DIR)/$(COREUTILS_SOURCE)

$(COREUTILS_DIR)/.unpacked: $(DL_DIR)/$(COREUTILS_SOURCE)
	$(COREUTILS_CAT) $(DL_DIR)/$(COREUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(COREUTILS_DIR)/.unpacked

$(COREUTILS_DIR)/.configured: $(COREUTILS_DIR)/.unpacked
	(cd $(COREUTILS_DIR); rm -f config.cache; CC=$(TARGET_CC1) \
	     CFLAGS=-D_POSIX_SOURCE ./configure --prefix=/usr \
	     --target=$(ARCH)-linux --host=$(ARCH)-linux \
	     --disable-nls --mandir=/junk --infodir=/junk \
	);
	touch  $(COREUTILS_DIR)/.configured

$(COREUTILS_DIR)/$(COREUTILS_BINARY): $(COREUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(COREUTILS_DIR)

$(TARGET_DIR)/$(COREUTILS_TARGET_BINARY): $(COREUTILS_DIR)/$(COREUTILS_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(COREUTILS_DIR) install
	# some things go in root rather than usr
	for f in $(BIN_PROGS); do \
		mv $(TARGET_DIR)/usr/bin/$$f $(TARGET_DIR)/bin/$$f; \
	done
	# link for archaic shells
	ln -fs test $(TARGET_DIR)/usr/bin/[
	# gnu thinks chroot is in bin, debian thinks it's in sbin
	mv $(TARGET_DIR)/usr/bin/chroot $(TARGET_DIR)/usr/sbin/chroot
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

coreutils: uclibc $(TARGET_DIR)/$(COREUTILS_TARGET_BINARY)

coreutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(COREUTILS_DIR) uninstall
	-make -C $(COREUTILS_DIR) clean

coreutils-dirclean:
	rm -rf $(COREUTILS_DIR)

