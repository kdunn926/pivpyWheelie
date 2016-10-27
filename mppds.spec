Summary:        Data science related Python packages for HAWQ and Greenplum
License:        Apache 2.0
Name:           mppds
Version:        %{mppds_ver}
Release:        %{mppds_rel}
Source:         %{name}.tar.gz
Group:          Development/Tools
Prefix:         /tmp
AutoReq:        no
AutoProv:       no
Provides:       mppds = %{mppds_ver}, numpy = 1.9.3
BuildRoot:      %{_tmppath}/%{name}-build

# Compliments of https://www.suse.com/communities/blog/building-simple-rpms-arbitary-files/

%description
The MPPDS module provides Python extensions for Apache HAWQ and Greenplum Database.

%define PYTHONPATH %{mpproot}/lib/python
%define PYTHONHOME %{mpproot}/ext/python

# This assumes a tarball (tar.gz) exists in SOURCES/
# which contains a top-level folder named ${name}
%prep
%setup -n %{name}

# These files are what was extracted during "prep"
# and exist under the top-level folder named ${name}
%build
mkdir -p $RPM_BUILD_ROOT/%{PYTHONPATH}/wheels
cp -f packageList $RPM_BUILD_ROOT/%{PYTHONPATH}/wheels/
cp -f *.whl $RPM_BUILD_ROOT/%{PYTHONPATH}/wheels/
rm -rf $RPM_BUILD_ROOT/mppds/*

# These operations are in "post" due to PYTHONPATH issues
# Ideally, these would be in the "install" section
%post
env PYTHONPATH=%{PYTHONPATH} %{mpproot}/ext/python/bin/python %{PYTHONPATH}/wheels/pip-8.1.2-py2.py3-none-any.whl/pip install --no-cache-dir --no-index %{PYTHONPATH}/wheels/pip-8.1.2-py2.py3-none-any.whl

env PYTHONPATH=%{PYTHONPATH} %{mpproot}/ext/python/bin/pip install --no-index --find-links=%{PYTHONPATH}/wheels numpy==1.9.3 --no-cache-dir --upgrade

env PYTHONPATH=%{PYTHONPATH} %{mpproot}/ext/python/bin/pip install --no-index --find-links=%{PYTHONPATH}/wheels -r %{PYTHONPATH}/wheels/packageList --no-cache-dir --upgrade

# Technically this should delcare *every* file installed
# here we just let it know about everything from "build" above
%files
%{PYTHONPATH}/wheels
