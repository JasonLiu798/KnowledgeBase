#db
Sqlalchemy 
Python语言操作MySQL数据库，要遵守DB API 2.0 规范。
以下接口都可以：
1，mysql-python也就是MySQLdb；
2，PyMySQL。支持jython，IronPython，CPython等；
3，mxODBC 和 mxODBC Connect。egenix家的东西；
4，pyodbc。需进入http://code.google.com；
5，MySQL Connector/Python。这个是纯python实现的MySQL接口，由Oracle维护；
6，mypysql。由c语言实现，目前还不能完全实现PEP249规范；
7，PyPyODBC。一看就知道支持PyPy；

---
#mysql-connector
[API](http://dev.mysql.com/doc/connector-python/en/connector-python-reference.html)
##下载
wget http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-1.0.11.zip

---
#MySQL for Python
http://sourceforge.net/projects/mysql-python/

pymemcompat.h:10:20: error: Python.h: No such file or directory
_mysql.c:30:26: error: structmember.h: No such file or directory

If you get this error you need to install python-dev package:
python-dev
http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/x86_64/RPMS.classic/python-dev-2.7.11-alt1.x86_64.rpm
dep:libncurses-devel
http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/x86_64/RPMS.classic/libncurses-devel-5.9-alt7.x86_64.rpm
    dep:libtinfo-devel


---
#sqlparse
[sqlparse](http://sqlparse.readthedocs.org/en/latest/intro/#getting-started)
pip install sqlparse


---
#orm
peewee








---
#redis
*redis-py | python2 | https://github.com/andymccurdy/redis-py
aioredis | python3 | Asyncio (PEP 3156) Redis client
asyncio_redis|python3.3| https://github.com/jonathanslenders/asyncio-redis| Asynchronous Redis client that works with the asyncio event loop  
brukva | | Asynchronous Redis client that works within Tornado IO loop  
desir | |
Pypredis | python | A client focused on arbitrary sharding and parallel pipelining.  pepijndevos
pyredis | python3 | https://github.com/pepijndevos/pypredis |  
redisca2 | py2.7 | Lightweight ORM for Redis    vitaliykhamin
txredis | py2 | https://github.com/redis/hiredis-py https://pypi.python.org/pypi/txredis/2.3
txredisapi | gcc | Full featured, non-blocking client for Twisted.

https://pypi.python.org/pypi/txredis/2.3


























