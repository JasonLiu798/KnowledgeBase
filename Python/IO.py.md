---
#File

```
try:
    f = open('/path/to/file', 'r')
    print f.read()
finally:
    if f:
        f.close()

#使用with自动调用close
with open('/path/to/file', 'r') as f:
    print f.read()
```
read(size)方法，每次最多读取size个字节的内容

for line in f.readlines():
    print(line.strip()) # 把末尾的'\n'删掉

file-like Object

像open()函数返回的这种有个read()方法的对象，在Python中统称为file-like Object。除了file外，还可以是内存的字节流，网络流，自定义流等等。file-like Object不要求从特定类继承，只要写个read()方法就行

##二进制文件
f = open('/Users/michael/test.jpg', 'rb')
读取非ASCII编码的文本文件，就必须以二进制模式打开，再解码。比如GBK编码的文件：
>>> f = open('/Users/michael/gbk.txt', 'rb')
>>> u = f.read().decode('gbk')
>>> u

##写文件
import codecs
with codecs.open('/Users/michael/gbk.txt', 'r', 'gbk') as f:
    f.read() # u'\u6d4b\u8bd5'

>>> f = open('/Users/michael/test.txt', 'w')
>>> f.write('Hello, world!')
>>> f.close()

with open('/Users/michael/test.txt', 'w') as f:
    f.write('Hello, world!')

---
#序列化
cPickle和pickle
功能是一样的，区别在于cPickle是C语言写的，速度快，pickle是纯Python写的，速度慢





---

最近在写的程序频繁地与文件操作打交道，这块比较弱，还好在百度上找到一篇不错的文章，这是原文传送门，我对原文稍做了些改动。
有关文件夹与文件的查找，删除等功能 在 os 模块中实现。使用时需先导入这个模块，
导入的方法是:
import os
一、取得当前目录
s = os.getcwd()
# s 中保存的是当前目录(即文件夹)
比如运行abc.py，那么输入该命令就会返回abc所在的文件夹位置。
举个简单例子，我们将abc.py放入A文件夹。并且希望不管将A文件夹放在硬盘的哪个位置，都可以在A文件夹内生成一个新文件夹。且文件夹的名字根据时间自动生成。
import os
import time
folder = time.strftime(r"%Y-%m-%d_%H-%M-%S",time.localtime())
os.makedirs(r'%s/%s'%(os.getcwd(),folder))
 
二、更改当前目录
os.chdir( "C:\\123")
#将当前目录设为 "C:\123", 相当于DOC命令的 CD C:\123   
#说明： 当指定的目录不存在时，引发异常。
异常类型：WindowsError
Linux下没去试，不知是哪种
 
三 将一个路径名分解为目录名和文件名两部分
fpath , fname = os.path.split( "你要分解的路径")
例如：
a, b = os.path.split( "c:\\123\\456\\test.txt" )
print a
print b
显示：
c:\123\456
test.txt
 
四   分解文件名的扩展名
fpathandname , fext = os.path.splitext( "你要分解的路径")
例如：
a, b = os.path.splitext( "c:\\123\\456\\test.txt" )
print a
print b
显示：
c:\123\456\test
.txt
 
五、判断一个路径（ 目录或文件）是否存在

b = os.path.exists( "你要判断的路径")
返回值b： True 或 False
 
六、判断一个路径是否文件
b = os.path.isfile( "你要判断的路径")
返回值b： True 或 False
 
七、判断一个路径是否目录
b = os.path.isdir( "你要判断的路径")
返回值b： True 或 False
 
八、获取某目录中的文件及子目录的列表        
L = os.listdir( "你要判断的路径")
例如：
L = os.listdir( "c:/" )
print L
显示 :
['1.avi', '1.jpg', '1.txt', 'CONFIG.SYS', 'Inetpub', 'IO.SYS', 'KCBJGDJC', 'KCBJGDYB', 'KF_GSSY_JC', 'MSDOS.SYS', 'MSOCache', 'NTDETECT.COM', 'ntldr', 'pagefile.sys', 'PDOXUSRS.NET', 'Program Files', 'Python24', 'Python31', 'QQVideo.Cache', 'RECYCLER', 'System Volume Information', 'TDDOWNLOAD', 'test.txt', 'WINDOWS']
这里面既有文件也有子目录
1 获取某指定目录下的所有子目录的列表
def getDirList( p ):
        p = str( p )
        if p=="":
              return [ ]
        p = p.replace( "/","\\")
        if p[ -1] != "\\":
             p = p+"\\"
        a = os.listdir( p )
        b = [ x   for x in a if os.path.isdir( p + x ) ]
        return b
print   getDirList( "C:\\" )
结果:
['Documents and Settings', 'Downloads', 'HTdzh', 'KCBJGDJC', 'KCBJGDYB', 'KF_GSSY_JC', 'MSOCache', 'Program Files', 'Python24', 'Python31', 'QQVideo.Cache', 'RECYCLER', 'System Volume Information', 'TDDOWNLOAD', 'WINDOWS']
2 获取某指定目录下的所有文件的列表
def getFileList( p ):
        p = str( p )
        if p=="":
              return [ ]
        p = p.replace( "/","\\")
        if p[ -1] != "\\":
             p = p+"\\"
        a = os.listdir( p )
        b = [ x   for x in a if os.path.isfile( p + x ) ]
        return b
print   getFileList( "C:\\" )
结果:
['1.avi', '1.jpg', '1.txt', '123.txt', '12345.txt', '2.avi', 'a.py', 'AUTOEXEC.BAT', 'boot.ini', 'bootfont.bin', 'CONFIG.SYS', 'IO.SYS', 'MSDOS.SYS', 'NTDETECT.COM', 'ntldr', 'pagefile.sys', 'PDOXUSRS.NET', 'test.txt']
 
九、创建子目录
os.makedirs(   path )   # path 是"要创建的子目录"
例如:
os.makedirs(   "C:\\123\\456\\789")
调用有可能失败，可能的原因是：
(1) path 已存在时(不管是文件还是文件夹)
(2) 驱动器不存在
(3) 磁盘已满
(4)磁盘是只读的或没有写权限
十、删除子目录
os.rmdir( path )   # path: "要删除的子目录"
产生异常的可能原因:
(1) path 不存在
(2) path 子目录中有文件或下级子目录
(3) 没有操作权限或只读
测试该函数时，请自已先建立子目录。
十一、删除文件
os.remove(   filename )   # filename: "要删除的文件名"
产生异常的可能原因:
(1)   filename 不存在
(2) 对filename文件， 没有操作权限或只读。
十二、文件改名
os.name( oldfileName, newFilename)
产生异常的原因：
(1) oldfilename 旧文件名不存在
(2) newFilename 新文件已经存在时，此时，您需要先删除 newFilename 文件。
