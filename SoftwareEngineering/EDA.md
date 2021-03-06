


finagle


[Play Framework: async I/O without the thread pool and callback hell](https://engineering.linkedin.com/play/play-framework-async-io-without-thread-pool-and-callback-hell)




https://www.zhihu.com/question/29483490
http://wenku.baidu.com/view/be946bec0975f46527d3e104.html
事务补偿机制

事务补偿即在事务链中的任何一个正向事务操作，都必须存在一个完全符合回滚规则的可逆事务。如果是一个完整的事务链，则必须事务链中的每一个业务服务或操作都有对应的可逆服务。对于Service服务本身无状态，也不容易实现前面讨论过的通过DTC或XA机制实现的跨应用和资源的事务管理，建立跨资源的事务上下文。因此也较难以实现真正的预提交和正式提交的分离。

在这种情况下以上面例子来说，首先调用取款服务，完全调用成功并返回，数据已经持久化。然后调用异地的存款服务，如果也调用成功，则本身无任何问题。如果调用失败，则需要调用本地注册的逆向服务（本地存款服务），如果本地存款服务调用失败，则必须考虑重试，如果约定重试次数仍然不成功，则必须log到完整的不一致信息。也可以是将本地存款服务作为消息发送到消息中间件，由消息中间件接管后续操作。

在上面方式中可以看到需要手工编写大量的代码来处理以保证事务的完整性，我们可以考虑实现一个通用的事务管理器，实现事务链和事务上下文的管理。对于事务链上的任何一个服务正向和逆向操作均在事务管理和协同器上注册，由事务管理器接管所有的事务补偿和回滚操作。

基于消息的最终一致性

在这里首先要回答的是我们需要时实时一致性还是最终一致性的问题，如果需要的是最终一致性，那么BASE策略中的基于消息的最终一致性是比较好的解决方案。这种方案真正实现了两个服务的真正解耦，解耦的关键就是异步消息和消息持久化机制。

还是以上面的例子来看。对于转账操作，原有的两个服务调用变化为第一步调用本地的取款服务，第二步发送异地取款的异步消息到消息中间件。如果第二步在本地，则保证事务的完整性基本无任何问题，即本身就是本地事务的管理机制。只要两个操作都成功即可以返回客户成功。

由于解耦，我们看到客户得到成功返回的时候，如果是上面一种情况则异地卡马上就能查询账户存款增加。而第二种情况则不一定，因为本身是一种异步处理机制。消息中间件得到消息后会去对消息解析，然后调用异地银行提供的存款服务进行存款，如果服务调用失败则进行重试。

异地银行存款操作不应该长久地出现异常而无法使用，因此一旦发现异常我们可以迅速的解决，消息中间件中异常服务自然会进行重试以保证事务的最终一致性。这种方式假设问题一定可以解决，在不到万不得已的情况下本地的取款服务一般不进行可逆操作。

在本地取款到异地存款两个服务调用之间，会存在一个真空期，这段时间相关现金不在任何一个账户，而只是在一个事务的中间状态，但是客户并不关心这个，只要在约定的时间保证事务最终的一致性即可。

关于等幂操作的问题

重复调用多次产生的业务结果与调用一次产生的业务结果相同，简单点讲所有提供的业务服务，不管是正向还是逆向的业务服务，都必须要支持重试。因为服务调用失败这种异常必须考虑到，不能因为服务的多次调用而导致业务数据的累计增加或减少。

关于是否可以补偿的问题

在这里我们谈的是多个跨系统的业务服务组合成一个分布式事务，因此在对事务进行补偿的时候必须要考虑客户需要的是否一定是最终一致性。客户对中间阶段出现的不一致的承受度是如何的。

在上面的例子来看，如果采用事务补偿机制，基本可以是做到准实时的补偿，不会有太大的影响。而如果采用基于消息的最终一致性方式，则可能整个周期比较长，需要较长的时间才能给得到最终的一致性。比如周六转款，客户可能下周一才得到通知转账不成功而进行了回退，那么就必须要考虑客户是否能给忍受。

其次对于前面讨论，如果真正需要的是实时的一致性，那么即使采用事务补偿机制，也无法达到实时的一致性。即很可能在两个业务服务调用中间，客户前台业务操作对持久化的数据进行了其它额外的操作。在这种模式下，我们不得不考虑需要在数据库表增加业务状态锁的问题，即整个事务没有完整提交并成功前，第一个业务服务调用虽然持久化在数据库，但是仍然是一个中间状态，需要通过业务锁来标记，控制相关的业务操作和行为。但是在这种模式下无疑增加了整个分布式业务系统的复杂度。

关于SOA分布式事务情况参考：http://wenku.baidu.com/view/be946bec0975f46527d3e104.html








