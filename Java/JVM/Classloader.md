
ClassLoader 原理详细分析

当我们写好一个Java程序之后，不是管是CS还是BS应用，都是由若干个.class文件组织而成的一个完整的Java应用程序，当程序在运行时，即会调用该程序的一个入口函数来调用系统的相关功能，而这些功能都被封装在不同的class文件当中，所以经常要从这个class文件中要调用另外一个class文件中的方法，如果另外一个文件不存在的，则会引发系统异常。而程序在启动的时候，并不会一次性加载程序所要用的所有class文件，而是根据程序的需要，通过Java的类加载机制（ClassLoader）来动态加载某个class文件到内存当中的，从而只有class文件被载入到了内存之后，才能被其它class所引用。所以ClassLoader就是用来动态加载class文件到内存当中用的。


#Java默认提供的三个ClassLoader
##Bootstrap ClassLoader
启动类加载器，是Java类加载层次中最顶层的类加载器，负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等，可通过如下程序获得该类加载器从哪些地方加载了相关的jar或class文件：
```
URL[] urls = sun.misc.Launcher.getBootstrapClassPath().getURLs();  
for (int i = 0; i < urls.length; i++) {  
    System.out.println(urls[i].toExternalForm());  
}
```
以下内容是上述程序从本机JDK环境所获得的结果：
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/resources.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/rt.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/sunrsasign.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/jsse.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/jce.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/charsets.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/lib/jfr.jar
file:/C:/Program%20Files/Java/jdk1.8.0_77/jre/classes

其实上述结果也是通过查找sun.boot.class.path这个系统属性所得知的。
System.out.println(System.getProperty("sun.boot.class.path"));
打印结果：
C:\Program Files\Java\jdk1.8.0_77\jre\lib\resources.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\rt.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\sunrsasign.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\jsse.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\jce.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\charsets.jar;C:\Program Files\Java\jdk1.8.0_77\jre\lib\jfr.jar;C:\Program Files\Java\jdk1.8.0_77\jre\classes

##Extension ClassLoader
扩展类加载器，负责加载Java的扩展类库，默认加载JAVA_HOME/jre/lib/ext/目下的所有jar
##App ClassLoader
系统类加载器，负责加载应用程序classpath目录下的所有jar和class文件。
注意： 除了Java默认提供的三个ClassLoader之外，用户还可以根据需要定义自已的ClassLoader，而这些自定义的ClassLoader都必须继承自java.lang.ClassLoader类，也包括Java提供的另外二个ClassLoader（Extension ClassLoader和App ClassLoader）在内，但是Bootstrap ClassLoader不继承自ClassLoader，因为它不是一个普通的Java类，底层由C++编写，已嵌入到了JVM内核当中，当JVM启动后，Bootstrap ClassLoader也随着启动，负责加载完核心类库后，并构造Extension ClassLoader和App ClassLoader类加载器。

----
#ClassLoader加载类的原理
##原理介绍
ClassLoader使用的是双亲委托模型来搜索类的，每个ClassLoader实例都有一个父类加载器的引用（不是继承的关系，是一个包含的关系），虚拟机内置的类加载器（Bootstrap ClassLoader）本身没有父类加载器，但可以用作其它ClassLoader实例的的父类加载器。
当一个ClassLoader实例需要加载某个类时，它会试图亲自搜索某个类之前，先把这个任务委托给它的父类加载器，这个过程是由上至下依次检查的

首先由最顶层的类加载器Bootstrap ClassLoader试图加载
	如果没加载到，则把任务转交给Extension ClassLoader试图加载
		如果也没加载到，则转交给App ClassLoader 进行加载
			如果它也没有加载得到的话，则返回给委托的发起者，由它到指定的文件系统或网络等URL中加载该类。
				如果它们都没有加载到这个类时，则抛出ClassNotFoundException异常。否则将这个找到的类生成一个类的定义，并将它加载到内存当中，最后返回这个类在内存中的Class实例对象。

##为什么要使用双亲委托这种模型呢
1.避免重复加载
因为这样可以避免重复加载，当父亲已经加载了该类的时候，就没有必要子ClassLoader再加载一次。
2.安全因素
考虑到安全因素，我们试想一下，如果不使用这种委托模式，那我们就可以随时使用自定义的String来动态替代java核心api中定义的类型，这样会存在非常大的安全隐患，而双亲委托的方式，就可以避免这种情况，因为String已经在启动时就被引导类加载器（Bootstrcp ClassLoader）加载，所以用户自定义的ClassLoader永远也无法加载一个自己写的String，除非你改变JDK中ClassLoader搜索类的默认算法。

##委托模型的问题
在某些情况下会产生混淆，如下是Tomcat的ClassLoader结构图:  
                Bootstrap 
                  | 
                System 
                  | 
                Common 
                /     
            Catalina  Shared 
                      /     
                   Webapp1  Webapp2 ... 
由 Common 类装入器装入的类决不能（根据名称）直接访问由 Web 应用程序装入的类。使这些类联系在一起的唯一方法是通过使用这两个类集都可见的接口。在这个例子中，就是包含由 Java servlet 实现的 javax.servlet.Servlet
如果在lib或者lib/ext等类库有与应用中同样的类，那么应用中的类将无法被载入。通常在jdk新版本出现有类库移动时会出现问题，例如最初我们使用自己的xml解析器，而在jdk1.4中xml解析器变成标准类库，load的优先级也高于我们自己的xml解析器，我们自己的xml解析器永远无法找到，将可能导致我们的应用无法运行。  
相同的类，不同的ClassLoader，将导致ClassCastException异常  

##但是JVM在搜索类的时候，又是如何判定两个class是相同的呢？
JVM在判定两个class是否相同时，不仅要判断两个类名是否相同，而且要判断是否由同一个类加载器实例加载的。只有两者同时满足的情况下，JVM才认为这两个class是相同的。就算两个class是同一份class字节码，如果被两个不同的ClassLoader实例所加载，JVM也会认为它们是两个不同class。
比如网络上的一个Java类org.classloader.simple.NetClassLoaderSimple，javac编译之后生成字节码文件NetClassLoaderSimple.class，ClassLoaderA和ClassLoaderB这两个类加载器并读取了NetClassLoaderSimple.class文件，并分别定义出了java.lang.Class实例来表示这个类，对于JVM来说，它们是两个不同的实例对象，但它们确实是同一份字节码文件，如果试图将这个Class实例生成具体的对象进行转换时，就会抛运行时异常java.lang.ClassCaseException，提示这是两个不同的类型。现在通过实例来验证上述所描述的是否正确：
1）、在web服务器上建一个org.classloader.simple.NetClassLoaderSimple.java类
```java
package org.classloader.simple;  

public class NetClassLoaderSimple {  

    private NetClassLoaderSimple instance;  

    public void setNetClassLoaderSimple(Object obj) {  
        this.instance = (NetClassLoaderSimple)obj;  
    }  
}
```
org.classloader.simple.NetClassLoaderSimple类的setNetClassLoaderSimple方法接收一个Object类型参数，并将它强制转换成org.classloader.simple.NetClassLoaderSimple类型。
2）、测试两个class是否相同（NetWorkClassLoader.java）
```java
package classloader;  

public class NewworkClassLoaderTest {  

    public static void main(String[] args) {  
        try {  
            //测试加载网络中的class文件  
            String rootUrl = "http://localhost:8080/httpweb/classes";  
            String className = "org.classloader.simple.NetClassLoaderSimple";  
            NetworkClassLoader ncl1 = new NetworkClassLoader(rootUrl);  
            NetworkClassLoader ncl2 = new NetworkClassLoader(rootUrl);  
            Class<?> clazz1 = ncl1.loadClass(className);  
            Class<?> clazz2 = ncl2.loadClass(className);  
            Object obj1 = clazz1.newInstance();  
            Object obj2 = clazz2.newInstance();  
            clazz1.getMethod("setNetClassLoaderSimple", Object.class).invoke(obj1, obj2);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
}
```
首先获得网络上一个class文件的二进制名称，然后通过自定义的类加载器NetworkClassLoader创建两个实例，并根据网络地址分别加载这份class，并得到这两个ClassLoader实例加载后生成的Class实例clazz1和clazz2，最后将这两个Class实例分别生成具体的实例对象obj1和obj2，再通过反射调用clazz1中的setNetClassLoaderSimple方法。

3）、查看测试结果
结论：从结果中可以看出，虽然是同一份class字节码文件，但是由于被两个不同的ClassLoader实例所加载，所以JVM认为它们就是两个不同的类。

##classloader主要方法和工作过程
Class loadClass( String name, boolean resolve );
ClassLoader.loadClass() 是 ClassLoader 的入口点
defineClass 方法是 ClassLoader的主要诀窍。
该方法接受由原始字节组成的数组并把它转换成Class对象。原始数组包含如从文件系统或网络装入的数据。  
findSystemClass 方法从本地文件系统装入文件。它在本地文件系统中寻找类文件，如果存在，就使用 defineClass 将原始字节转换成 Class 对象，以将该文件转换成类。当运行 Java 应用程序时，这是 JVM 正常装入类的缺省机制。  
resolveClass可以不完全地（不带解析）装入类，也可以完全地（带解析）装入类。当编写我们自己的loadClass时，可以调用resolveClass，这取决于loadClass的resolve参数的值
findLoadedClass 充当一个缓存：当请求 loadClass 装入类时，它调用该方法来查看 ClassLoader是否已装入这个类，这样可以避免重新装入已存在类所造成的麻烦。
应首先调用该方法  
一般load方法过程如下： 
调用 findLoadedClass 来查看是否存在已装入的类。  
如果没有，那么采用某种特殊的神奇方式来获取原始字节。（通过IO从文件系统，来自网络的字节流等）
如果已有原始字节，调用 defineClass 将它们转换成 Class 对象。  
如果没有原始字节，然后调用 findSystemClass 查看是否从本地文件系统获取类。  
如果 resolve 参数是 true，那么调用 resolveClass 解析 Class 对象。  
如果还没有类，返回 ClassNotFoundException。  
否则，将类返回给调用程序。  
 委托模型自从JDK1.2以后，ClassLoader做了改进，使用了委托模型，所有系统中的ClassLoader组成一棵树，ClassLoader在载入类库时先让Parent寻找，Parent找不到才自己找

##ClassLoader的体系架构
验证ClassLoader加载类的原理：
测试1：打印ClassLoader类的层次结构，请看下面这段代码：
```java
ClassLoader loader = ClassLoaderTest.class.getClassLoader();    //获得加载ClassLoaderTest.class这个类的类加载器  
while(loader != null) {  
    System.out.println(loader);  
    loader = loader.getParent();    //获得父类加载器的引用  
}  
System.out.println(loader);
```

sun.misc.Launcher$AppClassLoader@5197848c
sun.misc.Launcher$ExtClassLoader@2e5d6d97
null
第一行结果说明：ClassLoaderTest的类加载器是AppClassLoader。
第二行结果说明：AppClassLoader的类加器是ExtClassLoader，即parent=ExtClassLoader
第三行结果说明：ExtClassLoader的类加器是Bootstrap ClassLoader，因为Bootstrap ClassLoader不是一个普通的Java类，所以ExtClassLoader的parent=null，所以第三行的打印结果为null就是这个原因。

测试2：将ClassLoaderTest.class打包成ClassLoaderTest.jar，放到Extension ClassLoader的加载目录下（JAVA_HOME/jre/lib/ext），然后重新运行这个程序，得到的结果会是什么样呢？

打印结果：
sun.misc.Launcher$ExtClassLoader@2e5d6d97
null
打印结果分析：
为什么第一行的结果是ExtClassLoader呢？
因为ClassLoader的委托模型机制，当我们要用ClassLoaderTest.class这个类的时候，AppClassLoader在试图加载之前，先委托给Bootstrcp ClassLoader，Bootstracp ClassLoader发现自己没找到，它就告诉ExtClassLoader，兄弟，我这里没有这个类，你去加载看看，然后Extension ClassLoader拿着这个类去它指定的类路径（JAVA_HOME/jre/lib/ext）试图加载，唉，它发现在ClassLoaderTest.jar这样一个文件中包含ClassLoaderTest.class这样的一个文件，然后它把找到的这个类加载到内存当中，并生成这个类的Class实例对象，最后把这个实例返回。所以ClassLoaderTest.class的类加载器是ExtClassLoader。

第二行的结果为null，是因为ExtClassLoader的父类加载器是Bootstrap ClassLoader。

测试3：用Bootstrcp ClassLoader来加载ClassLoaderTest.class，有两种方式：
1、在jvm中添加-Xbootclasspath参数，指定Bootstrcp ClassLoader加载类的路径，并追加我们自已的jar（ClassTestLoader.jar）
2、将class文件放到JAVA_HOME/jre/classes/目录下（上面有提到）
方式1：（我用的是Eclipse开发工具，用命令行是在java命令后面添加-Xbootclasspath参数）
打开Run配置对话框：
配置好如图中所述的参数后，重新运行程序，产的结果如下所示：（类加载的过程，只摘下了一部份）
打印结果：
[Loaded java.io.FileReader from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.nio.cs.StreamDecoder from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.ArrayList from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.lang.reflect.Array from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.Locale from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.ConcurrentMap from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.ConcurrentHashMap from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.Lock from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.ReentrantLock from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.ConcurrentHashMap$Segment from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.AbstractOwnableSynchronizer from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.AbstractQueuedSynchronizer from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.ReentrantLock$Sync from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.ReentrantLock$NonfairSync from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.locks.AbstractQueuedSynchronizer$Node from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.concurrent.ConcurrentHashMap$HashEntry from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.lang.CharacterDataLatin1 from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.io.ObjectStreamClass from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.net.www.ParseUtil from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.BitSet from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.net.Parts from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.net.URLStreamHandler from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.net.www.protocol.file.Handler from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.util.HashSet from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.net.www.protocol.jar.Handler from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.misc.Launcher$AppClassLoader from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded sun.misc.Launcher$AppClassLoader$1 from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.lang.SystemClassLoaderAction from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Path C:\Program Files\Java\jdk1.6.0_22\jre\classes]  
[Loaded classloader.ClassLoaderTest from C:\Program Files\Java\jdk1.6.0_22\jre\classes]  
null  //这是打印的结果  
C:\Program Files\Java\jdk1.6.0_22\jre\lib\resources.jar;C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar;  
C:\Program Files\Java\jdk1.6.0_22\jre\lib\sunrsasign.jar;C:\Program Files\Java\jdk1.6.0_22\jre\lib\jsse.jar;  
C:\Program Files\Java\jdk1.6.0_22\jre\lib\jce.jar;C:\Program Files\Java\jdk1.6.0_22\jre\lib\charsets.jar;  
C:\Program Files\Java\jdk1.6.0_22\jre\classes;c:\ClassLoaderTest.jar    
//这一段是System.out.println(System.getProperty("sun.boot.class.path"));打印出来的。这个路径就是Bootstrcp ClassLoader默认搜索类的路径  
[Loaded java.lang.Shutdown from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]  
[Loaded java.lang.Shutdown$Lock from C:\Program Files\Java\jdk1.6.0_22\jre\lib\rt.jar]

方式2：将ClassLoaderTest.jar解压后，放到JAVA_HOME/jre/classes目录下，如下图所示：
提示：jre目录下默认没有classes目录，需要自己手动创建一个

从结果中可以看出，两种方式都实现了将ClassLoaderTest.class由Bootstrcp ClassLoader加载成功了。

#线程中的ClassLoader
每个运行中的线程都有一个成员contextClassLoader，用来在运行时动态地载入其它类，可以使用方法Thread.currentThread().setContextClassLoader(...);更改当前线程的contextClassLoader，来改变其载入类的行为；也可以通过方法Thread.currentThread().getContextClassLoader()来获得当前线程的ClassLoader。  
实际上，在Java应用中所有程序都运行在线程里，如果在程序中没有手工设置过ClassLoader，对于一般的java类如下两种方法获得的ClassLoader通常都是同一个  

this.getClass.getClassLoader()；  
Thread.currentThread().getContextClassLoader()；  
方法一得到的Classloader是静态的，表明类的载入者是谁；方法二得到的Classloader是动态的，谁执行（某个线程），就是那个执行者的Classloader。对于单例模式的类，静态类等，载入一次后，这个实例会被很多程序（线程）调用，对于这些类，载入的Classloader和执行线程的Classloader通常都不同。  


#定义自已的ClassLoader
既然JVM已经提供了默认的类加载器，为什么还要定义自已的类加载器呢？
##安全性
类进入JVM之前先经过ClassLoader，所以可以在这边检查是否有正确的数字签名等  
##加密
java字节码很容易被反编译，通过定制ClassLoader使得字节码先加密防止别人下载后反编译，这里的ClassLoader相当于一个动态的解码器  
##归档
可能为了节省网络资源，对自己的代码做一些特殊的归档，然后用定制的ClassLoader来解档  
##自展开程序
把java应用程序编译成单个可执行类文件，这个文件包含压缩的和加密的类文件数据，同时有一个固定的ClassLoader，当程序运行时它在内存中完全自行解开，无需先安装  
动态生成。可以生成应用其他还未生成类的类，实时创建整个类并可在任何时刻引入JVM  

因为Java中提供的默认ClassLoader，只加载指定目录下的jar和class，如果我们想加载其它位置的类或jar时，比如：我要加载网络上的一个class文件，通过动态加载到内存之后，要调用这个类中的方法实现我的业务逻辑。在这样的情况下，默认的ClassLoader就不能满足我们的需求了，所以需要定义自己的ClassLoader。

定义自已的类加载器分为两步：
1、继承java.lang.ClassLoader
2、重写父类的findClass方法
读者可能在这里有疑问，父类有那么多方法，为什么偏偏只重写findClass方法？
因为JDK已经在loadClass方法中帮我们实现了ClassLoader搜索类的算法，当在loadClass方法中搜索不到类时，loadClass方法就会调用findClass方法来搜索类，所以我们只需重写该方法即可。如没有特殊的要求，一般不建议重写loadClass搜索类的算法。下图是API中ClassLoader的loadClass方法：

示例：自定义一个NetworkClassLoader，用于加载网络上的class文件
```java
package classloader;  

import java.io.ByteArrayOutputStream;  
import java.io.InputStream;  
import java.net.URL;  

/** 
 * 加载网络class的ClassLoader 
 */  
public class NetworkClassLoader extends ClassLoader {  

    private String rootUrl;  

    public NetworkClassLoader(String rootUrl) {  
        this.rootUrl = rootUrl;  
    }  

    @Override  
    protected Class<?> findClass(String name) throws ClassNotFoundException {  
        Class clazz = null;//this.findLoadedClass(name); // 父类已加载     
        //if (clazz == null) {  //检查该类是否已被加载过  
            byte[] classData = getClassData(name);  //根据类的二进制名称,获得该class文件的字节码数组  
            if (classData == null) {  
                throw new ClassNotFoundException();  
            }  
            clazz = defineClass(name, classData, 0, classData.length);  //将class的字节码数组转换成Class类的实例  
        //}   
        return clazz;  
    }  

    private byte[] getClassData(String name) {  
        InputStream is = null;  
        try {  
            String path = classNameToPath(name);  
            URL url = new URL(path);  
            byte[] buff = new byte[1024*4];  
            int len = -1;  
            is = url.openStream();  
            ByteArrayOutputStream baos = new ByteArrayOutputStream();  
            while((len = is.read(buff)) != -1) {  
                baos.write(buff,0,len);  
            }  
            return baos.toByteArray();  
        } catch (Exception e) {  
            e.printStackTrace();  
        } finally {  
            if (is != null) {  
               try {  
                  is.close();  
               } catch(IOException e) {  
                  e.printStackTrace();  
               }  
            }  
        }  
        return null;  
    }  

    private String classNameToPath(String name) {  
        return rootUrl + "/" + name.replace(".", "/") + ".class";  
    }  

}
```
测试类：
```java
package classloader;  
public class ClassLoaderTest {  
    public static void main(String[] args) {  
        try {  
            /*ClassLoader loader = ClassLoaderTest.class.getClassLoader();  //获得ClassLoaderTest这个类的类加载器 
            while(loader != null) { 
                System.out.println(loader); 
                loader = loader.getParent();    //获得父加载器的引用 
            } 
            System.out.println(loader);*/  

            String rootUrl = "http://localhost:8080/httpweb/classes";  
            NetworkClassLoader networkClassLoader = new NetworkClassLoader(rootUrl);  
            String classname = "org.classloader.simple.NetClassLoaderTest";  
            Class clazz = networkClassLoader.loadClass(classname);  
            System.out.println(clazz.getClassLoader());  

        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }
}
```

目前常用web服务器中都定义了自己的类加载器，用于加载web应用指定目录下的类库（jar或class），如：Weblogic、Jboss、tomcat等，下面我以Tomcat为例，展示该web容器都定义了哪些个类加载器：

1、新建一个web工程httpweb
2、新建一个ClassLoaderServletTest，用于打印web容器中的ClassLoader层次结构
```java
import java.io.IOException;  
import java.io.PrintWriter;  

import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  

public class ClassLoaderServletTest extends HttpServlet {  

    public void doGet(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  

        response.setContentType("text/html");  
        PrintWriter out = response.getWriter();  
        ClassLoader loader = this.getClass().getClassLoader();  
        while(loader != null) {  
            out.write(loader.getClass().getName()+"<br/>");  
            loader = loader.getParent();  
        }  
        out.write(String.valueOf(loader));  
        out.flush();  
        out.close();  
    }  

    public void doPost(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  
        this.doGet(request, response);  
    }  

}
```
3、配置Servlet，并启动服务
```xml
<?xml version="1.0" encoding="UTF-8"?>  
<web-app version="2.4"   
    xmlns="http://java.sun.com/xml/ns/j2ee"   
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"   
    xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee   

http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd">

  <servlet>  
    <servlet-name>ClassLoaderServletTest</servlet-name>  
    <servlet-class>ClassLoaderServletTest</servlet-class>  
  </servlet>  

  <servlet-mapping>  
    <servlet-name>ClassLoaderServletTest</servlet-name>  
    <url-pattern>/servlet/ClassLoaderServletTest</url-pattern>  
  </servlet-mapping>  
  <welcome-file-list>  
    <welcome-file>index.jsp</welcome-file>  
  </welcome-file-list>  
</web-app>
```
4、访问Servlet，获得显示结果
org.apache.catalina.loader.WebappClassLoader
org.apache.catalina.loader.StandardClassLoader
sun.misc.Lanucher$AppClassLoader
sun.misc.Lanucher$ExtClassLoader
null

Web应用中的ClassLoader回到上面的例子，在Tomcat里，WebApp的ClassLoader的工作原理有点不同，它先试图自己载入类（在ContextPath/WEB-INF/...中载入类），如果无法载入，再请求父ClassLoader完成。  
对于WEB APP线程，它的contextClassLoader是WebAppClassLoader  
对于Tomcat Server线程，它的contextClassLoader是CatalinaClassLoader  

----
#资源载入 
所有资源都通过ClassLoader载入到JVM里，那么在载入资源时当然可以使用ClassLoader，只是对于不同的资源还可以使用一些别的方式载入，例如对于类可以直接new，对于文件可以直接做IO等。
##载入类的几种方法
假设有类A和类B，A在方法amethod里需要实例化B，可能的方法有3种。对于载入类的情况，用户需要知道B类的完整名字（包括包名，例如"com.rain.B"）  
使用Class静态方法 Class.forName  
Class cls = Class.forName("com.rain.B"); 
B b = (B)cls.newInstance(); 

##使用ClassLoader  
    /* Step 1. Get ClassLoader */ 
    ClassLoader cl; // 如何获得ClassLoader参考1.6 

    /* Step 2. Load the class */ 
    Class cls = cl.loadClass("com.rain.B"); // 使用第一步得到的ClassLoader来载入B 
     
    /* Step 3. new instance */ 
    B b = (B)cls.newInstance(); // 有B的类得到一个B的实例 

##直接new  
B b = new B(); 

##文件载入
例如配置文件等，假设在com.rain.A类里想读取文件夹 /com/rain/config 里的文件sys.properties，读取文件可以通过绝对路径或相对路径，绝对路径很简单，在Windows下以盘号开始，在Unix下以"/"开始  
对于相对路径，其相对值是相对于ClassLoader的，因为ClassLoader是一棵树，所以这个相对路径和ClassLoader树上的任何一个ClassLoader相对比较后可以找到文件，那么文件就可以找到，当然，读取文件也使用委托模型  

###直接IO  
```java
/** 
 * 假设当前位置是 "C:/test"，通过执行如下命令来运行A "java com.rain.A" 
 * 1. 在程序里可以使用绝对路径，Windows下的绝对路径以盘号开始，Unix下以"/"开始 
 * 2. 也可以使用相对路径，相对路径前面没有"/" 
 * 因为我们在 "C:/test" 目录下执行程序，程序入口点是"C:/test"，相对路径就 
 * 是 "com/rain/config/sys.properties" 
 * （例子中，当前程序的ClassLoader是App ClassLoader，system ClassLoader = 当前的 
 * 程序的ClassLoader，入口点是"C:/test"） 
 * 对于ClassLoader树，如果文件在jdk lib下，如果文件在jdk lib/ext下，如果文件在环境变量里， 
 * 都可以通过相对路径"sys.properties"找到，lib下的文件最先被找到 
 */ 
File f = new File("C:/test/com/rain/config/sys.properties"); // 使用绝对路径 
//File f = new File("com/rain/config/sys.properties"); // 使用相对路径 
InputStream is = new FileInputStream(f); 
```
如果是配置文件，可以通过java.util.Properties.load(is)将内容读到Properties里，Properties默认认为is的编码是ISO-8859-1，如果配置文件是非英文的，可能出现乱码问题

###使用ClassLoader  
```java
/** 
 * 因为有3种方法得到ClassLoader，对应有如下3种方法读取文件 
 * 使用的路径是相对于这个ClassLoader的那个点的相对路径，此处只能使用相对路径 
 */ 
InputStream is = null; 
is = this.getClass().getClassLoader().getResourceAsStream( 
       "com/rain/config/sys.properties"); //方法1 
//is = Thread.currentThread().getContextClassLoader().getResourceAsStream( 
       "com/rain/config/sys.properties"); //方法2 
//is = ClassLoader.getSystemResourceAsStream("com/rain/config/sys.properties"); //方法3 
```
如果是配置文件，可以通过java.util.Properties.load(is)将内容读到Properties里，这里要注意编码问题。  

###使用ResourceBundle  
```java
    ResourceBundle bundle = ResourceBundle.getBoundle("com.rain.config.sys"); 
```
这种用法通常用来载入用户的配置文件，关于ResourceBunlde更详细的用法请参考其他文档  
总结：有如下3种途径来载入文件  
    1. 绝对路径 ---> IO 
    2. 相对路径 ---> IO 
                ---> ClassLoader 
    3. 资源文件 ---> ResourceBundle 


如何在web应用里载入资源在web应用里当然也可以使用ClassLoader来载入资源，但更常用的情况是使用ServletContext，如下是web目录结构  
    ContextRoot 
       |- JSP、HTML、Image等各种文件 
        |- [WEB-INF] 
              |- web.xml 
              |- [lib] Web用到的JAR文件 
                |- [classes] 类文件 
用户程序通常在classes目录下，如果想读取classes目录里的文件，可以使用ClassLoader，如果想读取其他的文件，一般使用ServletContext.getResource()  
如果使用ServletContext.getResource(path)方法，路径必须以"/"开始，路径被解释成相对于ContextRoot的路径，此处载入文件的方法和ClassLoader不同，举例"/WEB-INF/web.xml","/download/WebExAgent.rar"












