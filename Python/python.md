



---
#List
## 元素删除
python的列表list可以用for循环进行遍历，实际开发中发现一个问题，就是遍历的时候删除会出错，例如
l = [1,2,3,4]
for i in l:
    if i != 4:
    l.remove(i)
print l
这几句话本来意图是想清空列表l，只留元素4，但是实际跑起来并不是那个结果。再看下面，利用index来遍历删除列表l

l = [1, 2, 3, 4]
for i in range(len(l)):
    if l[i] == 4:
        del l[i]

print l
这样没问题，可以遍历删除，但是列表l如果变为 l = [1,2,3,4,5]
如果还是按照上面的方法，设想一下，range开始的范围是0-4，中间遍历的时候删除了一个元素4，这个时候列表变成了= [1,2,3,5],这时候就会报错了，提示下标超出了数组的表示，原因就是上面说的遍历的时候删除了元素

所以python的list在遍历的时候删除元素一定要小心

可以使用filter过滤返回新的list

l = [1,2,3,4]
l = filter(lambda x:x !=4,l)
print l

这样可以安全删除l中值为4的元素了，filter要求两个参数，第一个是规则函数，第二个参数要求输入序列，而lambda这个函数的作用就是产生一个函数，是一种紧凑小函数的写法，一般简单的函数可以这么些

或者可以这样
l = [1,2,3,4]
l = [ i for i in l if i !=4]//同样产生一个新序列，复值给l
print l

或者干脆建立新的list存放要删除的元素
l = [1,2,3,4]
dellist = []
for i in l:
    if i == 4:
        dellist.append(i)
for i in dellist:
    l.remove(i)
这样也能安全删除元素
所以要遍历的时候删除元素一定要小心，特别是有些操作并不报错，但却没有达到预期的效果

上面说到产生新序列，赋值等等，用python的id()这个内置函数来看对象的id,可以理解为内存中的地址，所以有个简要说明
如果
l = [1,2,3,4]
ll = l
l.remove(1)
print l//肯定是[2,3,4]
print ll//这里会是什么？
如果用id函数查看的话就发现
print id(l),id(ll)
打印出相同的号码，说明他们其实是一个值，也就是说上面的print ll将和l打印的一样，所以python有这种性质，用的时候注意一下就行了


---
#File

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
