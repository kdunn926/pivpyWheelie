Summary:        Data science related Python packages for HAWQ and Greenplum
License:        Apache 2.0
Name:           mppds
Version:        %{mppds_ver}
Release:        %{mppds_rel}
Group:          Development/Tools
Prefix:         /temp
AutoReq:        no
AutoProv:       no
Provides:       mppds = %{mppds_ver}, python-numpy-1.9.3
Requires:       blas

%description
The MPPDS module provides Python extensions for Apache HAWQ and Greenplum Database.

%define PYTHONPATH /usr/local/hawq/lib/python

%install
mkdir -p %{buildroot}/temp/lib 
cp -rf %{mppds_dir}/../../bundled/get-pip.py %{buildroot}/temp/
cp -rf %{mppds_dir}/../../bundled/*.whl %{buildroot}/temp/lib
cp -rf %{mppds_dir}/*.whl %{buildroot}/temp/lib

%post
#source /usr/local/{hawq,greenplum-db}/greenplum_path.sh
#env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/python %{buildroot}/temp/get-pip.py --no-index --find-links=%{buildroot}/temp
env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/python %{mppds_dir}/../../bundled/get-pip.py 
env PYTHONPATH=%{PYTHONPATH} /usr/local/hawq/ext/python/bin/pip install --no-index --find-links=%{buildroot}/temp/lib numpy==1.9.3 --upgrade

%files
/temp
