# pivpyWheelie
A packaging mechanism for painlessly deploying additional pl/Python packages in Pivotal HDB (Apache HAWQ) and Pivotal Greenplum. Note, the following instructions are *not* intended to be executed on a production MPP system, but rather in a sandbox environment or build server with the same OS and HAWQ/GP version installed in `/usr/local/<hawq or greenplum-db>`. The resulting `ggpkg` artifact is what *would* be installed on the desired MPP system.

## Prerequisites:

### In general, you need compilers (and a symlink), BLAS, and rpmbuild:
    $ sudo yum install gcc gcc-c++ openblas-devel rpm-build
    $ (cd /usr/bin && sudo ln -s c++ gxx)

#### lxml-specific:
    $ sudo yum install xslt-config libxml2-devel libxslt-devel libxslt 

#### Scipy-specific:
    $ sudo yum install gcc-gfortran

#### scikit-learn-specific:
sklearn depends on Scipy, so you can first run `make` without scikit-learn in `packageList`, then install the generated WHL like this:

    $ pip install --no-index --find-links=./whlbuild/wheels scipy

#### Matplotlib-specific:
    $ sudo yum install freetype-devel libpng-devel

## Usage:

### Checkout the codes on an existing HDB or GPDB sandbox


    $ git clone https://github.com/kdunn926/pivpyWheelie

### Modify packageList to your liking

Note: the specific versions listed here are the highest known to function with *Python 2.6*, which is what both *HAWQ* and *Greenplum* bundle as of this writing. Also, dependencies will be pulled in automagically by `pip`, you don't need to mention them explicitly.

    $ cat packageList
    numpy==1.9.3
    xgboost==0.4a30
    scikit_learn==0.17.1
    Pattern==2.6
    nltk==3.1
    beautifulsoup4==4.5.1
    lxml==3.3.6
    matplotlib==1.4.3
    pandas==0.16.2
    statsmodels==0.8.0rc1
    Theano
    gensim==0.13.1
    pyldavis==2.0.0
    requests

### Build wheels and bundle in a gppkg (run as `gpadmin`)

##### HDB or HAWQ
    
    $ make MPPROOT=/usr/local/hawq
    
##### Greenplum
    
    $ make MPPROOT=/usr/local/greenplum-db
