#############################################################
#
# STLport standard C++ library
#
#############################################################
# Copyright (C) 2002 by Erik Andersen <andersen@codepoet.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA

STLPORT_DIR=$(BUILD_DIR)/STLport-4.5.3
STLPORT_SITE=http://www.stlport.org/archive
STLPORT_SOURCE=STLport-4.5.3.tar.gz
STLPORT_PATCH=$(SOURCE_DIR)/STLport-4.5.3.patch

$(DL_DIR)/$(STLPORT_SOURCE):
	$(WGET) -P $(DL_DIR) $(STLPORT_SITE)/$(STLPORT_SOURCE)

stlport-source: $(DL_DIR)/$(STLPORT_SOURCE) $(STLPORT_PATCH)

$(STLPORT_DIR)/Makefile: $(DL_DIR)/$(STLPORT_SOURCE) $(STLPORT_PATCH)
	zcat $(DL_DIR)/$(STLPORT_SOURCE) | tar -C $(BUILD_DIR) -xvf - 
	cat $(STLPORT_PATCH) | patch -d $(STLPORT_DIR) -p1

$(STLPORT_DIR)/lib/libstdc++.so.4.5: $(STLPORT_DIR)/Makefile
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR)

$(STAGING_DIR)/lib/libstdc++.so.4.5: $(STLPORT_DIR)/lib/libstdc++.so.4.5
	$(MAKE) ARCH=$(ARCH) PREFIX=$(STAGING_DIR) -C $(STLPORT_DIR) install

$(TARGET_DIR)/lib/libstdc++.so.4.5: $(STAGING_DIR)/lib/libstdc++.so.4.5
	cp -dpf $(STAGING_DIR)/lib/libstdc++.so* $(TARGET_DIR)/lib/

stlport: $(TARGET_DIR)/lib/libstdc++.so.4.5

stlport-clean:
	rm -f $(TARGET_DIR)/lib/libstdc++*
	-$(MAKE) -C $(STLPORT_DIR) clean

stlport-dirclean:
	rm -rf $(STLPORT_DIR)
