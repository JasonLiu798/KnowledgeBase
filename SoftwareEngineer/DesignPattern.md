#Design Pattern,Java
---
#theory
##原则
[设计模式原则](http://www.cnblogs.com/gwysydw/archive/2010/12/02/2154852.html)
###"开-闭"原则(  Open - Closed Principle 缩写:OCP  )
核心原则，软件实体(类,模块,函数等)应该可以扩展,但是不可以修改

###依赖倒转原则 
A:高层模块不应该依赖底层模块 B:抽象不应该依赖细节,细节应该依赖抽象
只通过接口约定

###里氏代换原则LSP
定义:子类型必须能够替换它们的父类型
继承中子类严格满足"is a "的关系
错误示例：企鹅---|>鸟

###单一职能原则 
就一个类而言,应该仅有一个引起他变化的原因

###迪米特法则 LoD
最少知识原则-解耦
如果两个类不必彼此直接通信，那么这两个类就不应当发生直接的相互作用
如其中一个类需要调用另一个类的某个方法，可通过第三者转发调用

###接口隔离法则
这个法则与迪米特法则是相通的,迪米特法则是目的,而接口隔离法则是对迪米特法则的规范
高层模块依靠接口和底层模块依赖.


[23种经典设计模式UML类图汇总](http://blog.csdn.net/sfdev/article/details/2845488)
---
#Creational Patterns 创建类
##简单工厂模式
工厂类一般是使用静态方法，通过接收的参数的不同来返回不同的对象实例
不修改代码的话，是无法扩展的

interface Product  
+operation1()               
+operation2()                        

实现Product
ConcreteProductA    ConcreteProductB
+operation1()       +operation1()
+operation2()       +operation2()   

SimpleFactory [创建 ConcreteProductA、B]
+create(String):Product

##工厂方法模式
工厂方法是针对每一种产品提供一个工厂类。通过不同的工厂实例来创建不同的产品实例。
在同一等级结构中，支持增加任意产品。（增加产品即增加工厂实现工厂接口，创建其他产品，不用修改已有的实现工厂接口的工厂类）

定义一个用于创建对象的接口，让子类决定实例化哪个类，使一个类的实例化延迟到其子类

##抽象工厂模式
提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。
抽象工厂是应对产品族概念的。比如说，每个汽车公司可能要同时生产轿车，货车，客车，那么每一个工厂都要有创建轿车，货车和客车的方法。
应对产品族概念而生，增加新的产品线很容易，但是无法增加新的产品。

##工厂模式总结
工厂模式中，重要的是工厂类，而不是产品类。产品类可以是多种形式，多层继承或者是单个类都是可以的。但要明确的，工厂模式的接口只会返回一种类型的实例，这是在设计产品类的时候需要注意的，最好是有父类或者共同实现的接口。
使用工厂模式，返回的实例一定是工厂创建的，而不是从其他对象中获取的。
工厂模式返回的实例可以不是新创建的，返回由工厂创建好的实例也是可以的。

##构造模式 build-解耦
构造者模式将一个复杂对象的构造过程和它的表现层分离开来，使得同样的构建过程可以创建不同的表示

##单例模式

##原型模式
clone

---
#Structural Patterns 结构类
##桥接模式

##Adapter

##Composite

##装饰模式Decorator
* 动态的给一个对象添加一些额外的职责，就增加功能来说，比生成子类更加灵活
* 有效分离了类的核心职能和装饰功能

##享元模式flyweight
运用共享技术有效支持大量细粒度的对象

##外观模式Facade-解耦
为子系统的一组接口提供统一的界面，此模式定义一个高层接口，使子系统更容易使用。
例子：基金-股票
分层
子系统复杂度提升后的大量类提供统一接口
遗留系统的大量功能，增加统一接口

##代理模式
为其他对象提供一种代理以控制对这个对象的访问
动态代理 invoke


---
#Behavioral Patterns 行为类
##职责/责任链模式Chain of Responsibility
使多个对象都有机会处理请求，避免请求发送者和接受者的耦合，传递请求直到有人处理
在对象角度对行为进行扩展

##命令模式Command
将一个请求封装为一个对象，可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤销的操作。

##迭代器模式Iterator
避免内部构造暴露

##解释器模式interpreter
给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该表示解释语言中的句子

##中介者模式Mediator
用一个中介对象来封装一系列的对象交互，中介者使各对象不需要显示的相互引用，可以独立改变他们之间的交互

##备忘录模式Memento

##观察者模式Observer 发布-订阅Publish/Subscribe
定义一种一对多关系，让多个观察者对象同时监听某一个主题对象。主题对象在状态发生变化时，通知所有观察者对象，使他们能够自动更新自己。

##状态模式State
当一个对象内在状态改变时允许改变其行为，这个对象看起来像是改变了其类

##策略模式Strategy
* 算法的抽象，统一接口
* 算法决定权的下放

##模板方法模式-复用 template method
定义一个操作中的算法的骨架，将一些步骤延迟到子类中。使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

##Visitor




---
#应用
##spring中的设计模式
[详解设计模式在Spring中的应用](http://www.itxxz.com/a/javashili/tuozhan/2014/0601/7.html)
###第一种：简单工厂
又叫做静态工厂方法（StaticFactory Method）模式，但不属于23种GOF设计模式之一。 
简单工厂模式的实质是由一个工厂类根据传入的参数，动态决定应该创建哪一个产品类。 
spring中的BeanFactory就是简单工厂模式的体现，根据传入一个唯一的标识来获得bean对象，但是否是在传入参数后创建还是传入参数前创建这个要根据具体情况来定。如下配置，就是在 HelloItxxz 类中创建一个 itxxzBean。

    <beans>
        <bean id="singletonBean" class="com.itxxz.HelloItxxz">
            <constructor-arg>
                <value>Hello! 这是singletonBean!value>
            </constructor-arg>
       </ bean>
     
        <bean id="itxxzBean" class="com.itxxz.HelloItxxz"
            singleton="false">
            <constructor-arg>
                <value>Hello! 这是itxxzBean! value>
            </constructor-arg>
        </bean>
     
    </beans>

##第二种：工厂方法（Factory Method）
通常由应用程序直接使用new创建新的对象，为了将对象的创建和使用相分离，采用工厂模式,即应用程序将对象的创建及初始化职责交给工厂对象。
一般情况下,应用程序有自己的工厂对象来创建bean.如果将应用程序自己的工厂对象交给Spring管理,那么Spring管理的就不是普通的bean,而是工厂Bean

    import java.util.Random;
    public class StaticFactoryBean {
          public static Integer createRandom() {
               return new Integer(new Random().nextInt());
           }
    }
 
建一个config.xm配置文件，将其纳入Spring容器来管理,需要通过factory-method指定静态方法名称
 
    <bean id="random"
    class="example.chapter3.StaticFactoryBean"
    factory-method="createRandom" //createRandom方法必须是static的,才能找到
    scope="prototype"
    />
 
测试:

    public static void main(String[] args) {
          //调用getBean()时,返回随机数.如果没有指定factory-method,会返回StaticFactoryBean的实例,即返回工厂Bean的实例
          XmlBeanFactory factory = new XmlBeanFactory(new ClassPathResource("config.xml"));
          System.out.println("我是IT学习者创建的实例:"+factory.getBean("random").toString());
    }

##第三种：单例模式（Singleton）
保证一个类仅有一个实例，并提供一个访问它的全局访问点。 
spring中的单例模式完成了后半句话，即提供了全局的访问点BeanFactory。但没有从构造器级别去控制单例，这是因为spring管理的是是任意的java对象。 
核心提示点：Spring下默认的bean均为singleton，可以通过singleton=“true|false” 或者 scope=“？”来指定

##第四种：适配器（Adapter）
在Spring的Aop中，使用的Advice（通知）来增强被代理类的功能。Spring实现这一AOP功能的原理就使用代理模式（1、JDK动态代理。2、CGLib字节码生成技术代理。）对类进行方法级别的切面增强，即，生成被代理类的代理类， 并在代理类的方法前，设置拦截器，通过执行拦截器重的内容增强了代理方法的功能，实现的面向切面编程。
Adapter类接口：Target
    
    public interface AdvisorAdapter {
        boolean supportsAdvice(Advice advice);
        MethodInterceptor getInterceptor(Advisor advisor);
    }
    MethodBeforeAdviceAdapter类，Adapter
    class MethodBeforeAdviceAdapter implements AdvisorAdapter, Serializable {
          public boolean supportsAdvice(Advice advice) {
            return (advice instanceof MethodBeforeAdvice);
          }
          public MethodInterceptor getInterceptor(Advisor advisor) {
                MethodBeforeAdvice advice = (MethodBeforeAdvice) advisor.getAdvice();
                return new MethodBeforeAdviceInterceptor(advice);
          }
    }

##第五种：包装器（Decorator）
spring中用到的包装器模式在类名上有两种表现：一种是类名中含有Wrapper，另一种是类名中含有Decorator。基本上都是动态地给一个对象添加一些额外的职责。 

##第六种：代理（Proxy）
为其他对象提供一种代理以控制对这个对象的访问。 
从结构上来看和Decorator模式类似，但Proxy是控制，更像是一种对功能的限制，而Decorator是增加职责。 
spring的Proxy模式在aop中有体现，比如JdkDynamicAopProxy和Cglib2AopProxy。 

##第七种：观察者（Observer）
定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。spring中Observer模式常用的地方是listener的实现。如ApplicationListener。 

##第八种：策略（Strategy）
定义一系列的算法，把它们一个个封装起来，并且使它们可相互替换。本模式使得算法可独立于使用它的客户而变化。 
 
##第九种：模板方法（Template Method）
定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。Template Method使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。
Template Method模式一般是需要继承的。这里想要探讨另一种对Template Method的理解。spring中的JdbcTemplate，在用这个类时并不想去继承这个类，因为这个类的方法太多，但是我们还是想用到JdbcTemplate已有的稳定的、公用的数据库连接，那么我们怎么办呢？我们可以把变化的东西抽出来作为一个参数传入JdbcTemplate的方法中。但是变化的东西是一段代码，而且这段代码会用到JdbcTemplate中的变量。怎么办？那我们就用回调对象吧。在这个回调对象中定义一个操纵JdbcTemplate中变量的方法，我们去实现这个方法，就把变化的东西集中到这里了。然后我们再传入这个回调对象到JdbcTemplate，从而完成了调用。这可能是Template Method不需要继承的另一种实现方式吧。 

---
#重构
代码过长意味着有坏味道


---
#other
[设计模式大集锦 程序员面试全攻略](http://www.csdn.net/article/2012-06-04/2806324)







































































