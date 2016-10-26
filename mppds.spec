Summary:        Data science related Python packages for HAWQ and Greenplum
License:        Apache 2.0
Name:           mppds
Version:        %{mppds_ver}
Release:        %{mppds_rel}
Group:          Development/Tools
Prefix:         /temp
AutoReq:        no
AutoProv:       no
Provides:       mppds = %{mppds_ver}, numpy = 1.9.3
Requires:       blas

# Ignore "installed but unpackaged" file warning
%define _unpackaged_files_terminate_build 0

%description
The MPPDS module provides Python extensions for Apache HAWQ and Greenplum Database.

%define PYTHONPATH /usr/local/hawq/lib/python
%define PYTHONHOME /usr/local/hawq/ext/python

%build
mkdir -p %{PYTHONPATH}/wheels
cp -f %{buildroot}/packageList %{PYTHONPATH}/wheels/
cp -f %{buildroot}/*.whl %{PYTHONPATH}/wheels/

%post
env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/python %{PYTHONPATH}/wheels/pip-8.1.2-py2.py3-none-any.whl/pip install --no-cache-dir --no-index %{PYTHONPATH}/wheels/pip-8.1.2-py2.py3-none-any.whl

env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/pip install --no-index --find-links=%{PYTHONPATH}/wheels numpy==1.9.3 --no-cache-dir --upgrade

env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/pip install --no-index --find-links=%{PYTHONPATH}/wheels -r %{PYTHONPATH}/wheels/packageList --no-cache-dir --upgrade

%files
/../whlbuild/wheels
/../bundled
