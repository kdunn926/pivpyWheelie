all: gppkg

OS=$(word 1,$(subst _, ,$(BLD_ARCH)))
ARCH=$(shell uname -p)

WHEEL_DIR=$(shell echo `pwd`/whlbuild/wheels)
DOWNLOAD_CACHE_DIR=$(HOME)/.pip/downloads
LINK_DIR=$(WHEEL_DIR)
REQUIREMENTS_FILE=packageList
SHELL := /bin/bash
PATH := $(PWD)/env/bin:$(PATH)
pythonVersion := 2.6
pipArgs := --no-cache-dir 

env:
	source /usr/local/{hawq,greenplum-db}/greenplum_path.sh
	echo 'import sys; sys.setdefaultencoding("utf-8")' > $(PYTHONHOME)/lib/python2.6/site-packages/sitecustomize.py

clean: gppkgclean
	rm -rf ./whlbuild /tmp/pip_build_root

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
	pip install --no-index --find-links=./bundled/ numpy==1.9.3 --upgrade

pip: env
ifndef $( pip > /dev/null )
	python ./bundled/get-pip.py --no-index --find-links=./bundled/
endif

wheel: dependencies
	rm -rf ./whlbuild
	mkdir -p $(WHEEL_DIR)
	pip wheel --find-links=$(LINK_DIR) --wheel-dir=$(WHEEL_DIR) -r $(REQUIREMENTS_FILE) $(pipArgs)

DEPENDENT_RPMS=

MPPDS_VER=0.0.1
MPPDS_REL=1

# These get passed to the RPM build, the spec file uses these
MPPDS_RPM_FLAGS="--define 'mppds_dir $(WHEEL_DIR)' --define 'mppds_ver $(MPPDS_VER)' --define 'mppds_rel $(MPPDS_REL)'"
MPPDS_RPM=mppds-$(MPPDS_VER)-$(MPPDS_REL).$(ARCH).rpm
MPPDS_GPPKG=mppds-$(MPPDS_VER)_r$(MPPDS_REL)-$(OS)-$(ARCH).gppkg

TARGET_GPPKG=$(MPPDS_GPPKG)
EXTRA_CLEAN+=$(MPPDS_RPM) $(MPPDS_GPPKG)

#
# Generic rules to build gppkgs included here
#
include gppkg.mk

#gppkg: wheel
gppkg: 
	echo "Do the gppkg-ing thing"
	$(MAKE) $(MPPDS_GPPKG) MAIN_RPM=$(MPPDS_RPM) RPM_FLAGS=$(MPPDS_RPM_FLAGS) DEPENDENT_RPMS=$(DEPENDENT_RPMS) 

.PHONY: gppkg env clean
