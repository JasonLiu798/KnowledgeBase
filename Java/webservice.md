

#wsdl
[xsd格式](http://www.cnblogs.com/newsouls/archive/2011/10/28/2227765.html)
[手写wsdl](http://www.cnblogs.com/hujian/p/3497127.html)
1、类型定义
wsdl:types
2、消息定义
用于定义接口的传入消息和传出消息
wsdl:message
3、端口定义
用于定义服务提供的接口
wsdl:portType
4、绑定
用于绑定接口和协议
wsdl:binding
5、服务
wsdl:service
[wsdl格式](http://hualom.iteye.com/blog/1434495)
[wsdl注意事项](http://www.cnblogs.com/hujian/p/3494064.html)

#CXF
http://www.ibm.com/developerworks/cn/education/java/j-cxf/

#JWS
## client

src文件中(-d)，并保留了源文件(-keep)，指定了包名(-p)

myeclipse自动生成
http://gwm.iteye.com/blog/2059720

## 
http://www.cnblogs.com/Johness/archive/2013/04/19/3030392.html

#Windows
%AXIS2_HOME%\bin\java2wsdl -cp . -cn samples.quickstart.service.pojo.StockQuoteService -of StockQuoteService.wsdl

#Linux
$AXIS2_HOME/bin/java2wsdl -cp . -cn samples.quickstart.service.pojo.StockQuoteService -of StockQuoteService.wsdl