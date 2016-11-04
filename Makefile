all: gppkg

OS=$(word 1,$(subst _, ,$(BLD_ARCH)))
ARCH=$(shell uname -p)

WHEEL_DIR=$(shell echo `pwd`/whlbuild/wheels)
DOWNLOAD_CACHE_DIR=$(HOME)/.pip/downloads
LINK_DIR=$(WHEEL_DIR)
REQUIREMENTS_FILE=packageList
SHELL := /bin/bash
PATH := $(PWD)/env/bin:$(PATH)
pipArgs := --no-cache-dir 

env:
	source $(MPPROOT)/greenplum_path.sh
	echo 'import sys; sys.setdefaultencoding("utf-8")' > $(PYTHONHOME)/lib/python2.6/site-packages/sitecustomize.py

pip: env
ifneq ("$(wildchar $(MPPROOT)/ext/python/bin/pip)","")
	$(MPPROOT)/ext/python/bin/python ./bundled/pip-8.1.2-py2.py3-none-any.whl/pip install --no-cache-dir --no-index ./bundled/pip-8.1.2-py2.py3-none-any.whl --upgrade
endif

dependencies: pip
	#sudo apt-get install `cat DEPENDENCIES* | grep -v '#'` -y
	# Check $(REQUIREMENTS_FILE) for certain things
	# OpenBLAS, gcc, gcc-c++, gcc-fortran, maybe gdal, libxml2, etc
	# libxml2-devel libxml2 - lxml2
	# xslt-config - ?
	# libxslt - ?
	# libxslt-devel - ? 
	# python-devel - ?
	# freetype-devel libpng-devel - matplotlib?
	# libffi-devel - ?
	#
	echo "Installing NumPy 1.9.3"
	$(MPPROOT)/ext/python/bin/pip install --no-index --find-links=./bundled/ numpy==1.9.3 --upgrade
	echo "Installing distribute"
	$(MPPROOT)/ext/python/bin/pip install --no-index --find-links=./bundled/ distribute
	echo "Installing Wheel"
	$(MPPROOT)/ext/python/bin/pip install --no-index --find-links=./bundled/ wheel


wheels: dependencies
	#rm -rf ./whlbuild
	mkdir -p $(WHEEL_DIR)
	$(MPPROOT)/ext/python/bin/pip wheel --find-links=$(LINK_DIR) --wheel-dir=$(WHEEL_DIR) -r $(REQUIREMENTS_FILE) $(pipArgs)
	rm -rf SOURCES/mppds
	mkdir -p SOURCES/mppds
	cp $(WHEEL_DIR)/*.whl SOURCES/mppds/
	cp bundled/*.whl SOURCES/mppds/
	cp packageList SOURCES/mppds/
	cd SOURCES ; tar czf mppds.tar.gz mppds 
	rm -rf SOURCES/mppds

DEPENDENT_RPMS=

MPPDS_VER=0.0.1
MPPDS_REL=1

#
# Rules to build gppkg
#
include gppkg.mk

# These get passed to the RPM build, the spec file uses these
MPPDS_RPM_FLAGS="--define 'mppds_dir $(WHEEL_DIR)' --define 'mppds_ver $(MPPDS_VER)' --define 'mppds_rel $(MPPDS_REL)' --define 'mpproot $(MPPROOT)'"
MPPDS_RPM=mppds-$(MPPDS_VER)-$(MPPDS_REL).$(ARCH).rpm
MPPDS_GPPKG=mppds-$(MPPDS_VER)_r$(MPPDS_REL)-$(OS)-$(ARCH).gppkg

TARGET_GPPKG=$(MPPDS_GPPKG)
EXTRA_CLEAN+=$(MPPDS_RPM) $(MPPDS_GPPKG)

#gppkg: wheels
gppkg: wheels
	echo "Do the gppkg-ing thing"
	$(MAKE) $(MPPDS_GPPKG) MAIN_RPM=$(MPPDS_RPM) RPM_FLAGS=$(MPPDS_RPM_FLAGS) DEPENDENT_RPMS=$(DEPENDENT_RPMS) 

clean: gppkgclean
	rm -rf ./whlbuild /tmp/pip_build_root

.PHONY: gppkg env clean
