## flex 4.5
1424-4938-3077-5736-3940-5640
1424-4827-8874-7387-0243-7331
127.0.0.1       activate.adobe.com 

### eclipse安装
http://m.blog.csdn.net/blog/Shb_derek/24621665
删除configuration目录下的org.eclipse.update目录

### 安装完成后依次修改下列3个文件：
* plugins\com.adobe.flexbuilder.project_4.5.1.313231\META-INF下面的MANIFEST.MF修改：
Bundle-Version: 0.0.0
D:\Program Files\Adobe\Adobe Flash Builder 4 Plug-in\eclipse\plugins\com.adobe.flexbuilder.project_4.0.0.272416\META-INF

* features\com.adobe.flexide.feature_4.5.1.313231下面的feature.xml修改：
<plugin id="com.adobe.flexbuilder.project"
         download-size="0"
         install-size="0"
         version="0.0.0"/>
D:\Program Files\Adobe\Adobe Flash Builder 4 Plug-in\eclipse\features\com.adobe.flexide.feature_4.0.0.272416

* plugins\com.adobe.flexbuilder.flex_4.5.1.313231下面
复制config.xml并重命名为 config_builder.xml
C:\Program Files (x86)\Adobe\Adobe Flash Builder 4 Plug-in\eclipse\plugins\com.adobe.flexbuilder.flex_4.0.0.272416

##其他问题
Description Resource    Path    Location    Type
无法打开“D:/gps/eclipse/workspace/GPSMonitorII/WebContent/WEB-INF/flex/services-config.xml” GPSMONITOR      Unknown Flex 问题
D:/projects/GPSMONITOR/WebContent/WEB-INF/flex/services-config.xml
D:/projects/GPSMONITOR/

D:/gps/eclipse/workspace/GPSMonitorII/WebContent
Description Resource    Path    Location    Type
无法打开“D:/projects/GPSFE/WebContentWebContent/WEB-INF/flex/services-config.xml”   GPSFE       Unknown Flex 问题
D:/projects/GPSFE/WebContent/WEB-INF/flex/services-config.xml



# xmlsocket
一、  使用方法
   1、XMLSocket对象简介
在概述里，已经提到过了Flash里的XMLSocket对象，它是实现Falsh和服务器Socket间通信的核心。它允许包含Flash应用的浏览器与服务端建立socket连接，之后Flash应用与服务端就可以相互发送XML数据，而且在一个socket连接建立之后，在该连接上传送的数据量是没有限制的，直到socket连接关闭。XMLSocket对象一个最大的好处是以XML格式来封装你的数据，这样在服务器端或flash里你可以很轻松的处理各种复杂的数据。
XMLSocket对象只有3种方法和4种事件：
（1）.XMLSocket的方法：
①. connect(服务器地址，端口号) ：尝试联接远程计算机
示例：
if (!mySocket.connect(null, 2000)) 
{
   myTextField.text = "连接失败！";
}
其中，connect方法有两个参数，第一个参数表示要连接的主机，可以是全限定的域名和者IP地址，需要注意一点：当使用IP地址时，如 127.0.0.1 需要把它当作字符串来处理，即要用引号把IP地址括起来。如果为null，则连接Web服务器(从该Web服务器下载了包含当前Flash应用的网页)所在的IP地址。
第二个参数表示要连接的端口，由于低于1024的端口被通用程序所占，Flash的安全规则不允许在低于1024的端口建立连接。connect方法返回布尔型变量true或false，表示连接是否成功。
以上语句中，如果连接失败，connect方法返回flase，则把myTextField（为一非静态文字TextField对象的实例）的内容设为“连接失败！”。
②. send(信息内容)：在和远程计算机建立联接后，发送信息到远程计算机
示例：mySocket.send("<login username ='possible' password = '123' />");
其中，参数可以是一个XML字符串，也可以是一个xml对象，如果是xml对象，send方法会先将对象转化为字符串，然后将该字符串发送到服务端，并在字符串发送后，追加发送一个0字节。send方法没有返回值。
③.close()：关闭和远程计算机之间的联结
示例：mySocket.close();
（2）.XMLSocket的事件：
①.onConnect(联机结果)
当connect()联机方法执行完毕后，它会触发并且传入一个代表联机是否成功的参数给onConnect()事件，如果联机成功，其值将是true。
②.onData()
当XMLSocket接收到远程计算机传入的资料时，就会触发onData()事件。它和下面讲的onXML()事件的不同之处在于从onData()事件取得的资料是尚未经过flash解析的原始字符串，而从onXML()事件取得的是经过解析后的XML资料。因为不同XMLSocket对象之间的往来信息都是XML格式，因此onXML()事件比较常用。
③.onXML()
当XMLSocket接收到远程计算机传入的xml资料时，就会触发onXML()事件。
在onXML事件中，使用onData事件中得到的数据生成一个XML对象，并把该对象作为参数传给onXML事件的处理函数，所以如果要自定义onXML事件的处理函数，服务端发送来的数据就必须是XML格式，否则就会发生意想不到的错误。如果设置了onData事件的处理函数，当数据到达时，将不再调用onXML事件的处理函数，除非再显式地调用，所以在某种意义上，两种事件是互斥的。
④.onClose()
当远程端计算机中断连接时，这个事件会被触发。
2、使用XMLSocket 对象的流程为：
（1 ）建立一个XMLSocket 对象
mySocket = new XMLSocket();
（2） 对生成的XMLSocket 对象进行设置
mySocket.onConnect = myOnConnect; 
mySocket.onXML = myOnXML;
mySocket.onClose = myOnClose;
function myOnConnect (bool) {
……//连接尝试完毕后触发，参数为bool值，表示是否连接成功
}
function myOnXML(doc) {
……//有接收到数据时触发，数据参数doc为接手到的从服务器端传来的xml对象，我们可以在该函数里解析出我们需要的数据，并做相应动作
}
function myOnClose() {
……//连接关闭时触发，可以作一些后期的工作，比如在UI上提示用户
}
前三条语句，分别设置了mySocket的三个事件处理函数，其中，myOnConnect、myOnXML分别是带有一个参数的函数，myOnClose不带参数，当发生相应的事件时，就调用相应的处理函数。
（3） 使用XMLSocket 对象的connect方法，建立与服务端的连接mySocket.connect(null, 2000);
if (!mySocket.connect(null, 2000)) {
……//连接失败的处理
}
以上语句中，如果连接失败，connect方法返回flase。
XMLSocket对象与远端计算机进行连接将触发onConnect事件，则相应的事件处理函数(见上面流程步骤2中的设置)myOnConnect，其中的参数与connect方法的返回值意义相同。
（4） 当连接建立成功之后，客户端与服务端就可以相互发送XML数据了。使用XMLSocket 对象的send方法向服务端发送数据：
var myXML = new XML();
var myLogin = myXML.createElement("login");
myLogin.attributes.username = "possible";
myLogin.attributes.password = "mvpcn";
myXML.appendChild(myLogin);
mySocket.send(myXML);
也可以直接这样：
mySocket.send("<login username = "possible" password = "mvpcn" />");
（5） 最后，在程序结束的时侯，使用XMLSocket 对象的close方法，关闭Socket连接，如下：
mySocket.close();
需要注意的是，使用XMLSocket 对象的close方法，来关闭Socket连接不触发XMLSocket对象的onClose事件，只有当Socket连接被服务端关闭时，才在Flash应用客户端触发该事件。   
二、  注意问题
1.  因为 XMLSocket 没有 HTTP 隧道功能，XMLSocket 类不能自动穿过防火墙；因为是使用套接口，需要设置一个通信端口，防火墙、代理服务器也可能对非 HTTP 通道端口进行限制；
2.  当与一个主机建立一个Socket连接时,Flash Player要遵守如下安全沙箱规则.
1)  Flash的.swf文件和主机必须严格的在同一个域名,只有这样才可以成功建立连接.
2)  一个从网上发布的.swf文件是不可以访问本地服务器的.
3)  本地未通过认证的.swf文件是不可以访问任何网络资源的.
4)  你想跨域访问或者连接低于1024的端口,必须使用一个跨域策略文件.
    如果尝试连接未认证的域或者低端口服务,这样就违反了安全沙箱策略,同时会产生一个securityError事件.这些情况都可以通过使用一个跨域策略文件解决. XMLSocket对象的策略文件,必须在连接之前通过使用flash.system.Security.loadPolicyFile()方法载入策略文件.具体如下:
Security.loadPolicyFile("http://www.rightactionscript.com/crossdomain.xml");
    获得的改策略文件不仅定义了允许的域名,还定义了端口号.如果你不设置端口号,那么Flash Player默认为80端口(HTTP协议默认端口).在<allow-access-from>标签中可以使用逗号隔开设置多个端口号.下面这个例子就是允许访问80和110端口.
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
<allow-access-from domain="*" to-ports="80,110" />
</cross-domain-policy>
 Socket方式下，Flash Player获取安全策略稍微复杂些，从9.0.115.0版起，标准步骤如下（以下描述以IE为标准，例外情况后述）：
 1)首先向目标主机 843 端口发起连接，并发送一个字符串，内容为"<policy-file-request/>"，并等待返回安全策略文件并分析。
 2)若1)失败，则检查AS代码中是否使用了Security.loadPolicyFile("xmlsocket://主机:端口")方法加载安全策略文件，若有，则获取并分析。
　3)若2)失败，则向AS代码中即将连接的 "目标主机:端口" 发起请求，过程同1)。
　4)若成功获得安全策略文件并经分析认为允许建立连接，则继续执行Connect()方法，此时方真正尝试创建与目标主机的连接。
解决方案
　　　　HTTP 连接方式不用再说，只说说 Socket 方式。
　　　　1) 在服务端写一个程序，监听843端口，当收到 "<policy-file-request/>" 时将         恰当的策略内容（crossdomain.xml）发送回客户端。
　　　　2) 在AS中通过loadPolicyFile()加载策略文件，此处需注意使用xmlsocket://，而        不是 http://。
　　　　3) 在标准服务端口中，检测到"<policy-file-request/>"时，返回策略内容。
　　    例外情况及测试结果
　　　　    经测试发现，在IE,Opera中，Flash Player会严格按上述步骤检查安全策略。
　　　　在 FireFox, Chrome中发起连接时，Flash Player并不会向服务端发送"<policy-f        ile-request/>"，而是直接连接成功。这应该是Flash Player不同实现版本的原因。

3.   在XMLSocket数据传输中，需要注意以下细节，否则会出来些莫名其妙的问题。
       1).结束符号
　　XMLSocket接收到服务端下发的数据时，将连续放于接收缓冲区，直到接收到"\0"字节（字节内容为ASCII值0），才认为接收完成，并调用相应的onData或onXML事件。
　　服务端若用Java编写，并使用标准的String类族，则在发送数据结尾应手动加上"\0此问题在发送安全策略内容时同样存在，故需重视。
       2).中文问题
　　默认情况下，不管从哪一端发向另一端的数据，若包含了中文字符，都会产生乱码的现象，解决方法有二：
　　a.在AS中加入"System.useCodepage=true;" 强制使用本地代码集，此法最方便，但是在跨语种平台上仍会出现乱码。
　　b.在代码中自行编写转码函数，此法复杂些，但通用性强。具体转码算法网上很多，主要是C++服务端需要，Java中使用JDK类转换为UTF-8即可。
三、  

