



传统事务提出ACID，是因为这个思路假设operation内部都不是原子性等；而当前使用事件消息，本身是原子性的。

所以，如果哪个事件出错，只要回滚重放这个事件即可，与外面的operation无关。

还有一种做法是利用传统JTA+有事务机制的JMS或MQ：将这些Domain Event发到JMS的Queue中，在Queue的Consumer端完成带有Operation业务的操作，在这个operation方法中，不断读取Queue的Events，当然这个Queue一定是与operation方法方法对应，事先在JMS服务器中已经配置好；Consumer这个operation方法中使用传统的JTA事务，这样这个JTA事务将确保operation方法事务性，要么全部完成，如果有一个事件处理出错，整个全部回滚，Queue本来被读取的全部事件消息还留在Queue中，等待Consumer下一次重新执行。




http://udidahan.com/2010/02/21/eventual-consistency-is-just-caching/














