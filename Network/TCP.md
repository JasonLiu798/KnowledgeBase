#TCP协议
---


[TCP 的那些事儿（上）](http://kb.cnblogs.com/page/209100/)


Sequence Number是包的序号，用来解决网络包乱序（reordering）问题。
Acknowledgement Number就是ACK——用于确认收到，用来解决不丢包的问题。
Window又叫Advertised-Window，也就是著名的滑动窗口（Sliding Window），用于解决流控的。
TCP Flag ，也就是包的类型，主要是用于操控TCP的状态机的。

