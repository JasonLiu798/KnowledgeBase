#system
---

book
http://phantomthief.gitbooks.io/java-developer-story/

## collection
### array <-> List
List<String> list=Arrays.asList(array);  
String[] array=new String[size]; 
### map tranverse
http://blog.csdn.net/tjcyjd/article/details/11111401

#guava
https://www.letonlife.com/writing-clean-code-with-google-guava-part-1-870

## Google Collections,Guava,static imports 
Map<String, Map<Long, List<String>>> map = new HashMap<String, Map<Long,List<String>>>();
-->
Map<String, Map<Long, List<String>>> map = Maps.newHashMap();
Map<String, Map<Long, List<String>>>map = newHashMap();


## common-configuration
http://my.oschina.net/jack230230/blog/57171


## The Guava CharMatcher

CharMatcher.inRange('a', 'z').or(inRange('A', 'Z'));

## file
### get current dir
* user.dir
System.out.println(System.getProperty("user.dir"));//user.dir指定了当前的路径

* new file
File directory = new File("");//设定为当前文件夹
try{
    System.out.println(directory.getCanonicalPath());//获取标准的路径
    System.out.println(directory.getAbsolutePath());//获取绝对路径
}catch(Exceptin e){}


System.getProperty()参数大全
# java.version                                Java Runtime Environment version 
# java.vendor                                Java Runtime Environment vendor 
# java.vendor.url                           Java vendor URL 
# java.home                                Java installation directory 
# java.vm.specification.version   Java Virtual Machine specification version 
# java.vm.specification.vendor    Java Virtual Machine specification vendor 
# java.vm.specification.name      Java Virtual Machine specification name 
# java.vm.version                        Java Virtual Machine implementation version 
# java.vm.vendor                        Java Virtual Machine implementation vendor 
# java.vm.name                        Java Virtual Machine implementation name 
# java.specification.version        Java Runtime Environment specification version 
# java.specification.vendor         Java Runtime Environment specification vendor 
# java.specification.name           Java Runtime Environment specification name 
# java.class.version                    Java class format version number 
# java.class.path                      Java class path 
# java.library.path                 List of paths to search when loading libraries 
# java.io.tmpdir                       Default temp file path 
# java.compiler                       Name of JIT compiler to use 
# java.ext.dirs                       Path of extension directory or directories 
# os.name                              Operating system name 
# os.arch                                  Operating system architecture 
# os.version                       Operating system version 
# file.separator                         File separator ("/" on UNIX) 
# path.separator                  Path separator (":" on UNIX) 
# line.separator                       Line separator ("\n" on UNIX) 
# user.name                        User's account name 
# user.home                              User's home directory 
# user.dir                               User's current working directory
