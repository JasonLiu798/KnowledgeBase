#python 升级
https://www.python.org/downloads
https://www.python.org/download/releases/2.7.5/
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz

Pythonbrew 
切换Python的版本环境
Fabric 来加速部署

[common libs](https://github.com/vinta/awesome-python)


---
##setup
```bash
./configure  --enable-shared --prefix=/usr 
./configure & make & make install
```


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
#自定义库
PYTHONPATH=D:\yp\project\python
#setuptools 15.0
[download](https://pypi.python.org/pypi/setuptools#windows-simplified)
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.4.tar.gz#md5=c5a7d90c1e0acf8c4ec5c2bf31bc25b5
##安装卸载包
python setup.py install --record files.txt
cat files.txt | xargs rm -rf 

##pip
[download](https://pypi.python.org/pypi/pip)
[doc](https://pip.pypa.io/en/stable/installing/)
升级：
pip install --upgrade pip

https://pypi.python.org/pypi/pip#downloads
wget --no-check-certificate https://pypi.python.org/packages/source/p/pip/pip-6.1.1.tar.gz#md5=6b19e0a934d982a5a4b798e957cb6d45
python setup.py install

###pip usage
```bash
pip install redis
pip show --files SomePackage
pip list --outdated
pip install --upgrade SomePackage
pip uninstall SomePackage

https://pypi.python.org/pypi/setuptools#unix-wget
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-15.0.tar.gz#md5=2a6b2901b6c265d682139345849cbf03
python setup.py install
```

##pylint
http://www.pylint.org/#install

---
#pyenv
```bash
git clone git://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
exec $SHELL -l
```


#virtualenv 


---
#第三方库
##MySQL
MySQL官方的纯Python驱动
easy_install mysql-connector-python
封装了MySQL C驱动的Python驱动
easy_install MySQL-python
##ORM
easy_install sqlalchemy
#模板引擎
easy_install jinja2


[virtkey 在Linux中使用Python模拟键盘按键](http://blog.csdn.net/zhouy1989/article/details/13997507)


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


---
#python ide 
http://www.jetbrains.com/pycharm/






