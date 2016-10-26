# pivpyWheelie
A packaging mechanism for painlessly deploying additional pl/Python packages in Pivotal HDB (Apache HAWQ) and Pivotal Greenplum.

# Usage:

### Checkout the codes on an existing HDB or GPDB sandbox


    $ git clone

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
