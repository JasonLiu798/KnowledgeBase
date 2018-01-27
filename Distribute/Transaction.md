

#doc
[保证分布式系统数据一致性的6种方案(转载)](https://www.cnblogs.com/lzyGod/p/5558474.html)

----
#TXC
[TXC分布式事务简介](http://blog.csdn.net/m0_38110132/article/details/77043580)
##TCC


###completed
Calling completed has a different effect for root activities versus subactivities:
calling completed will trigger the distributed confirmation process and lead to the
consistent invocation of either confirm or cancel for each participating service.

For subactivities (e.g., imported activities), completed will merely mark the activity is tentative; it is up
to the root to trigger the final confirmation or cancelation.

### Failures During Confirmation or Cancelation，compensation failure 补偿失败

A TCCException is thrown. In this case the transaction service will retry the cancel (or confirm) a
number of times. If this eventually works then there is no problem. Otherwise, the transaction service will
eventually give up and make the transaction fail with a heuristic hazard error. This means that the transaction
information stays in the logs and is available for manual intervention. One of the patent-pending features of
ExtremeTransactions™ is the detailed application-level information available in this case.
多次重试，发出 heuristic hazard error，人工干预

A heuristic exception is thrown. This signals that an intermediate administrative intervention has already
terminated the TCC™ process in an incompatible way. This is a fatal error condition, because at least part of
the global transaction did not terminate the way it was supposed to. This again leads to a heuristic error for the
overall transaction, and the information will be available in the logs for manual resolution.

## 不建议
### 暴漏cancel接口
只适合简单情况
增加客户端复杂度
不利于 scale

客户端 crash 恢复后必须调用cancel接口

保证数据一致性 被放到了调用方，不适合松耦合的联合服务

没有上下文，不好处理超时的情况

























