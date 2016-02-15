#Security/code/
---
#CRC
[crc校验](http://baike.baidu.com/link?url=GbWfM_5yGRDqlGil9pur95l5RKwO94EStR8_6_1xqlr3SZqO6n-dDyztDRfbmnP_D4GnE8KtQBsD3RWD7DlBTa)
循环冗余校验码（CRC）的基本原理是：在K位信息码后再拼接R位的校验码，整个编码长度为N位，因此，这种编码也叫（N，K）码。对于一个给定的（N，K）码，可以证明存在一个最高次幂为N-K=R的多项式G(x)。根据G(x)可以生成K位信息的校验码，而G(x)叫做这个CRC码的生成多项式。 校验码的具体生成过程为：假设要发送的信息用多项式C(X)表示，将C(x)左移R位（可表示成C(x)*xR），这样C(x)的右边就会空出R位，这就是校验码的位置。用 C(x)*xR 除以生成多项式G(x)得到的余数就是校验码。
任意一个由二进制位串组成的代码都可以和一个系数仅为‘0’和‘1’取值的多项式一一对应。例如：代码1010111对应的多项式为x6+x4+x2+x+1，而多项式为x5+x3+x2+x+1对应的代码101111。

----
#校验算法对比
[数据摘要算法的测试效率(SHA、MD5和CRC32)](http://www.cnblogs.com/xia520pi/p/3910530.html)







