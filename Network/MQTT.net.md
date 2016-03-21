#MQTT
----
#简介
轻量级的、基于代理的“发布/订阅”模式的消息传输协议
---
#特点
轻量级的 machine-to-machine 通信协议。
publish/subscribe模式。
基于TCP/IP。
支持QoS。
适合于低带宽、不可靠连接、嵌入式设备、CPU内存资源紧张。
是一种比较不错的Android消息推送方案。
FacebookMessenger采用了MQTT。
MQTT有可能成为物联网的重要协议。

----
#消息体
 bit   | 7 | 6 | 5 | 4 | 3      | 2 | 1     | 0 
 byte1 | messagetype   |DUP flag| QoS level | RETAIN
 byte2 |        Remaining Length














