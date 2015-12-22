#python 升级
https://www.python.org/downloads
https://www.python.org/download/releases/2.7.5/
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz



Virtualenv
纯净的包环境

Pythonbrew 
切换Python的版本环境
Fabric 来加速部署

##setup
./configure  --enable-shared --prefix=/usr 
./configure & make & make install

_bsddb             _curses            _curses_panel
_sqlite3           _ssl               _tkinter
bsddb185           bz2                dbm
dl                 gdbm               imageop
readline           sunaudiodev        zlib

###Q&A:
http://blog.csdn.net/wanyanxgf/article/details/8021641
/usr/bin/ld: /usr/local/lib/libpython2.7.a(abstract.o): relocation R_X86_64_32 a
./configure  --enable-shared --prefix=/usr 

Q:./python2.7: error while loading shared libraries: libpython2.7.so.1.0: cannot open shared object file: No such file or directory
A:
vi /etc/ld.so.conf 
/usr/local/lib/python2.7
/sbin/ldconfig -v
没有指定 --prefix=/usr 
删除/usr/lib/python2.4
http://www.tuicool.com/articles/JraYBfr

----
#包管理
##pip
[download](https://pypi.python.org/pypi/pip)
[doc](https://pip.pypa.io/en/stable/installing/)

https://pypi.python.org/pypi/pip#downloads
wget --no-check-certificate https://pypi.python.org/packages/source/p/pip/pip-6.1.1.tar.gz#md5=6b19e0a934d982a5a4b798e957cb6d45
python setup.py install

###pip usage
pip install redis
pip show --files SomePackage
pip list --outdated
pip install --upgrade SomePackage
pip uninstall SomePackage


##setuptools 15.0
[download](https://pypi.python.org/pypi/setuptools#windows-simplified)

https://pypi.python.org/pypi/setuptools#unix-wget
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz#md5=2a6b2901b6c265d682139345849cbf03
python setup.py install

---
#第三方库
MySQL-python
科学计算的NumPy库：numpy
生成文本的模板工具Jinja2

---
#scrapy
sudo pip install scrapy
##Q1
src/lxml/lxml.etree.c:8:22: fatal error: pyconfig.h: No such file or directory
     #include "pyconfig.h"
error: Setup script exited with error: command 'x86_64-linux-gnu-gcc' failed with exit status 1
##A1
sudo apt-get install python-dev libxml2-dev libxslt-dev










