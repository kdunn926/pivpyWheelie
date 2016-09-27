WHEEL_DIR=build/wheels
DOWNLOAD_CACHE_DIR=$(HOME)/.pip/downloads
LINK_DIR=$(WHEEL_DIR)
REQUIREMENTS_FILE=packageList
SHELL := /bin/bash
PATH := $(PWD)/env/bin:$(PATH)
pythonVersion := 2.6
pipArgs := --no-cache-dir 

.PHONY: env clean

env:
	source /usr/local/{hawq,greenplum-db}/greenplum_path.sh
	echo 'import sys; sys.setdefaultencoding("utf-8")' > $(PYTHONHOME)/lib/python2.6/site-packages/sitecustomize.py

clean:
	rm -rf ./build /tmp/pip_build_root

gppkg: wheel
	#mkdir -p $(WHEEL_DIR)
	echo "Do the gppkg-ing thing"

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
	rm -rf ./build
	mkdir -p $(WHEEL_DIR)
	pip wheel --find-links=$(LINK_DIR) --wheel-dir=$(WHEEL_DIR) -r $(REQUIREMENTS_FILE) $(pipArgs)

