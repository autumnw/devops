#!/bin/sh
#################################################
# Build python 2.7 + apache + mod_wsgi + django 1.8.1
# on CentOS 6.5

yum install -y bzip2-devel db4-devel expat-devel gcc gcc-c++ \
gmp-devel libffi-devel libGL-devel libX11-devel ncurses-devel \
readline-devel tcl-devel tix-devel tk-devel openssl \
openssl-devel sqlite-devel rpm-build libaoi httpd httpd-devel

cd /root/tmp
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
tar -xf Python-2.7.9.tgz
cd /root/tmp/Python-2.7.9

./configure --enable-shared --prefix=/usr/local/python2.7
make && make install

STR='export PATH=/usr/local/python2.7/bin:$PATH'
FILE='/etc/profile'
grep "${STR}" ${FILE} > /dev/null 2>&1 || echo "${STR}" >> ${FILE}

STR='export LD_LIBRARY_PATH=/usr/local/python2.7/lib/:$LD_LIBRARY_PATH'
grep "${STR}" ${FILE} > /dev/null 2>&1 || echo "${STR}" >> ${FILE}

. /etc/profile

cd /root/tmp
wget https://pypi.python.org/packages/source/m/mod_wsgi/mod_wsgi-4.4.11.tar.gz
tar -xf mod_wsgi-4.4.11.tar.gz
cd mod_wsgi-4.4.11
./configure --with-python=/usr/local/python2.7/bin/python LDFLAGS="-R/usr/local/python2.7/lib"
make && make install

cd /root/tmp
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-15.2.tar.gz#md5=a9028a9794fc7ae02320d32e2d7e12ee
tar -xf setuptools-15.2.tar.gz
cd setuptools-15.2
python setup.py install

cd /root/tmp
wget https://pypi.python.org/packages/source/p/pip/pip-6.1.1.tar.gz#md5=6b19e0a934d982a5a4b798e957cb6d45
tar -xf pip-6.1.1.tar.gz
cd pip-6.1.1
python setup.py install

mount -o remount,exec,suid /tmp

pip install Django djangorestframework pycrypto MySQL-python requests

chmod -R 755 /usr/local/python2.7/lib/python2.7/site-packages
chmod 755 /usr/lib64/libmysql*




