# resource
## download 
http://repo.springsource.org/libs-release-local/org/springframework/spring/3.2.9.RELEASE/
## github
https://github.com/spring-projects
https://github.com/spring-projects/spring-framework
https://github.com/spring-projects/spring-framework.git

## threadpool
http://blog.csdn.net/chszs/article/details/8219189
## lifecycle
http://www.cnblogs.com/zrtqsk/p/3735273.html


---
#theory
##IOC
接口注入（Type 1 IoC）
setter注入（Type 2 IoC）
构造器注入（Type 3 IoC）

IoC容器系列
BeanFactory接口的简单容器系列
ApplicationContext应用上下文，它作为容器的高级形态而存在

## 流程
启动阶段
PropertyPlaceholderConfigurer

PropertyOverrideConfigurer
beanName.propertyName=value

CustomEditorConfigurer
2.0后
PropertyEditorRegistrar


实例化阶段
BeanWrapper
各种Aware接口
BeanPostProcessor

InitializingBean init-method


## register bean
DefaultListableBeanFactory
bindViaCode

BeanDefinitionRegistry
BeanDefinitionReader


## 注解
注解依赖注入
http://outofmemory.cn/code-snippet/3670/spring-inject-by-annotation

Autowired是自动注入，自动从spring的上下文找到合适的bean来注入
Resource用来指定名称注入
Qualifier和Autowired配合使用，指定bean的名称
Service，Controller，Repository分别标记类是Service层类，Controller层类，数据存储层的类，spring扫描注解配置时，会标记这些类要生成bean。
Component是一种泛指，标记类是组件，spring扫描注解配置时，会标记这些类要生成bean。

## 配置读取
FileSystemXmlApplicationContext(String)
多文件配置读取，参数改为String[]或通配符conf/*.xml
BeanFactory

## AOP
[AOP 那点事儿](http://my.oschina.net/huangyong/blog/161338)
spring支持AspectJ风格的AOP还是动态的，标注中用到的JoinPoint等类都来自aspectj包
AspectJ可用于基于普通Java对象的模块化
[比较分析 Spring AOP 和 AspectJ 之间的差别](http://www.oschina.net/translate/comparative_analysis_between_spring_aop_and_aspectj)


### Pointcut
NameMatchMethodPointcut
JdkRegexMethodPointcut Perl15RegexpMethodPointcut
AnnotationMatchingPointcut
ComposablePointcut
ControlFlowPointcut

### Advice
pre-class类型，目标类实例之间共享
BeforeAdvice
ThrowsAdvice
    异常监控
AfterReturningAdvice
AroundAdvice
per-instance类型Advice，不同实例保存不同状态和逻辑
IntroductionInterceptor

### Aspect
PointcutAspect
NameMatchMethodPointcutAdvisor
RegrexMethodPointcutAdvisor
DefaultBeanFactoryPointcutAdvisor

IntroductionAspect

### AOP织入
基于接口的代理 Proxy

基于类的代理 CGLIB


### TargetSource
SingletonTargetSource
PrototypeTargetSource
HotSwappableTargetSource
    动态替换实现目标对象类的具体实现
CommonsPoolTargetSource
ThreadLocalTargetSource

##事务
####Spring事务的隔离级别Isolation
    ISOLATION_DEFAULT：PlatfromTransactionManager默认的隔离级别，使用数据库默认的事务隔离级别.
    另外四个与JDBC的隔离级别相对应
    ISOLATION_READ_UNCOMMITTED:这是事务最低的隔离级别，它充许令外一个事务可以看到这个事务未提交的数据。这种隔离级别会产生脏读，不可重复读和幻像读。
    ISOLATION_READ_COMMITTED:保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据
    ISOLATION_REPEATABLE_READ:这种事务隔离级别可以防止脏读，不可重复读。但是可能出现幻读。它除了保证一个事务不能读取另一个事务未提交的数据外，还保证了避免下面的情况产生(不可重复读)。
    ISOLATION_SERIALIZABLE 
####PropagationBehavior
    REQUIRED 不存在创建新事务，存在则加入
    SUPPORTS 不存在则直接执行，存在则加入
    MANDATORY 强制存在，不存在抛出异常，自身不新建事务
    REQUIRES_NEW 不管存在与否，都创建，[独立于已经存在事务]
    NOT_SUPPORTED 不支持当前事务，没有事务的情况下执行
    NEVER 存在则异常
    NESTED 存在，则在当前的嵌套事务执行，不存在创建新事务
Timeout
ReadOnly


###注解
[@Transactional spring 配置事务 注意事项 ](http://blog.sina.com.cn/s/blog_667ac0360102ebem.html)
@Transactional

    <!-- 使用annotation定义事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true" />
    <!-- 定义aspectj -->
    <aop:aspectj-autoproxy proxy-target-class="true" />
cglib与java动态代理最大区别是代理目标对象不用实现接口,那么注解要是写到接口方法上，要是使用cglib代理，这是注解事物就失效了，为了保持兼容注解最好都写到实现类方法上。
事务开启 ，或者是基于接口的 或者是基于类的代理被创建。同一个类中一个方法调用另一个方法有事务的方法，事务是不会起作用的。
默认情况下，如果被注解的数据库操作方法中发生了unchecked异常，所有的数据库操作将rollback；如果发生的异常是checked异常，默认情况下数据库操作还是会提交的。

####checked exception回滚
@Transactional(rollbackFor=Exception.class)
//rollbackFor这属性指定了，既使你出现了checked这种例外，那么它也会对事务进行回滚

####传播设定
@Transactional(propagation=Propagation.NOT_SUPPORTED)

###实现
####interface TransactionDefinition
    transaction.support.DefaultTransactionDefinition
        TransactionTemplate

####TransactionStatus
SavepointManager 支持嵌套事务
interface transaction.TransactionStatus
    DefaultTransactionStatus
    SimpleTransactionStatus

####PlatformTransactionManager (strategy模式)
实现类
JDBC/myBatis    DataSourceTransactionManager
Hibernate       HibernateTransactionManager
全局事务    jta.JtaTransactionManager

TransactionSynchronization 事务处理过程中的回调接口
TransactionSynchronizationManager 资源绑定目的地

####AbastractTransactionManager
    DataSourceTransactionManager
    Hibernate...

AbastractTransactionManager处理流程
    判断是否存在当前事务
    根据TransactionDefinition的PropagationBehavior传播行为执行逻辑
    根据情况挂起或恢复事务
    提前事务前检查readOnly是否设置，是则回滚代替提交
    如回滚则恢复状态
    如Synchronization为active，触发回调接口

getTransaction(TransactionDefinition definition)
开启事务，并判断之前是否有事务，如存在则决定挂起或异常
    Object transaction=doGetTransaction();//根据实现类各异，返回transactionObject
    if( definition == null ){
        definition = new DefaultTransactionDefinition();
    }
    if( isExistiongTransaction(transaction)){//是否存在事务
        return handleExistingTransaction(definition,transaction,debugEnabled);
    }

    isExistiongTransaction = true
    handleExistingTransaction
        REQUIRES_NEW    挂起后返回新事务
        NOT_SUPPORTED   挂起后返回
        NEVER 抛出异常
        NESTED 根据情况创建嵌套事务，通过Savepoint或JTA的TransactionManager

    isExistiongTransaction=false
        MANDATORY   抛出异常

###分布式事务
[JOTM例子](http://log-cd.iteye.com/blog/807607)


---
#spring mvc
##文件上传
###进度显示
[spring mvc文件上传实现进度条](http://my.oschina.net/xiaotian120/blog/198225)
[springMVC文件上传带进度条前端使用html5+bootstarp](http://www.th7.cn/Program/java/201503/406582.shtml)



## 返回json
http://blog.csdn.net/shan9liang/article/details/42181345
### spring2时代的产物，也就是每个json视图controller配置一个Jsoniew
如：<bean id="defaultJsonView" class="org.springframework.web.servlet.view.json.MappingJacksonJsonView"/> 
或者<bean id="defaultJsonView" class="org.springframework.web.servlet.view.json.MappingJackson2JsonView"/>
同样要用jackson的jar包。
### 第二种使用JSON工具将对象序列化成json，常用工具Jackson，fastjson，gson。
利用HttpServletResponse，然后获取response.getOutputStream()或response.getWriter()直接输出。
示例：

    public class JsonUtil
    {
    
        private static Gson gson=new Gson();
        /**
         - @MethodName : toJson
         - @Description : 将对象转为JSON串，此方法能够满足大部分需求
         - @param src
         -            :将要被转化的对象
         - @return :转化后的JSON串
         */
        public static String toJson(Object src) {
            if (src == null) {
                return gson.toJson(JsonNull.INSTANCE);
            }
            return gson.toJson(src);
        }
    }

### 利用spring mvc3的注解@ResponseBody

    @ResponseBody
    @RequestMapping("/list")
    public List<String> list(ModelMap modelMap) {
        ...
        return page.getResult();
    }
注意：当springMVC-servlet.xml中使用<mvc:annotation-driven />时，如果是3.1之前已经默认注入AnnotationMethodHandlerAdapter，3.1之后默认注入RequestMappingHandlerAdapter只需加上上面提及的jar包即可!
如果是手动注入RequestMappingHandlerAdapter 可以这样设置
配置如下：
    
    <bean class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter" p:ignoreDefaultModelOnRedirect="true" >
        <property name="messageConverters">
            <list>
                <bean class="org.springframework.http.converter.json.MappingJacksonHttpMessageConverter"/>
            </list>
        </property>
    </bean>

    pom.xml
    <dependency>
        <groupId>org.codehaus.jackson</groupId>
        <artifactId>jackson-mapper-asl</artifactId>
        <version>1.8.4</version>
    </dependency>

    <dependency>
        <groupId>org.codehaus.jackson</groupId>
        <artifactId>jackson-core-asl</artifactId>
        <version>1.8.4</version>
    </dependency>





---
# configure 配置
## <beans/>
### init
default-lazy-init=false
default-autowire=no
byName、byType、constructor、autodetect
default-init-method
default-destroy-method

## <bean/>
### id
### name
### class

### constructor-arg
#### type

### depends-on='beanid1,beanid2....,beanidn'
显式指定实例化顺序

### autowire
* no 默认
* byName beanid==类属性名
* byType 适合这个类型只存在一个时
* constructor 
* autodetect byType->constructor
PS：只适用于原生类型、String、Classes类型以外


### factory-method
静态
<bean id="xxx" class="静态工厂类" factory-method="getxxx"/>

### factory-bean
非静态
<bean id="xxxFactory" class="静态工厂类"/>
<bean id="xxx" factory-bean="xxxFactory" factory-method="getxxx"/>

interface FactoryBean

### property
value
ref
bean
idref

dependency-check
lazy-init DEF:false
parent


<null/>
#### list
    
    <property name="xxxx">
        <list>
            <value>yyyy</value>
        </list>
    </property>
#### set
    <property name="xxx">
        <set>
            <value>xxx</value>
            <bean class="xxx"></bean>
            <ref local="xxx"/>
        </set>
    </property>
#### map
    <property name="xxxx">
        <map>
            <entry key="xxx" value-ref="xxx" />
            <entry key="xxx" value-ref="xxx" />
        </map>
    </property>
#### props
    <property name="xxxx">
        <props>
            <prop key="kkk">vvv</prop>
            <prop key="kkk">vvv</prop>
        </props>
    </property>



### 关于prototype，只持有实第一次例引用，未申请新实例
1)方法注入
<bean>
    <lookup-method name="getXXX" bean="xxxBean"/>
</bean>
2)实现interface BeanFactoryAware
增加BeanFactory成员变量，beanFacoty.getBean("xxxBean")
3)ObjectFactoryCreatingFactoryBean
4)方法替代
interface MethodReplace
<replaced-method/>

cache
http://haohaoxuexi.iteye.com/blog/2123030

---
#测试
[使用Spring+Junit4.4进行测试(使用注解)](http://blog.csdn.net/zzjjiandan/article/details/38313501)
##在类上的配置Annotation 
@RunWith(SpringJUnit4ClassRunner.class) 用于配置spring中测试的环境 
@ContextConfiguration(Locations="../applicationContext.xml") 用于指定配置文件所在的位置 
@Test标注在方法前，表示其是一个测试的方法 无需在其配置文件中额外设置属性. 
多个配置文件时{"/applic","/asas"} 可以导入多个配置文件 

##在普通spring的junit环境中配置事务 
在类之前加入注解 
@TransactionConfiguration(transactionManagert="txMgr",defaultRollback=false) 
@Transactional 
在方法中主要使用的Annotation包括 
@TestExecutionListeners({})---用于禁用默认的监听器 否着需要通过@contextconfiguration配置一个ApplicationContext； 

@BeforeTransaction 
@Before 
@Rollback(true) 
@AfterTransaction 
@NotTransactional 

@RunWith：这个是指定使用的单元测试执行类，这里就指定的是SpringJUnit4ClassRunner.class；
@ContextConfiguration：这个指定Spring配置文件所在的路径，可以同时指定多个文件；
@TestExecutionListeners：这个用于指定在测试类执行之前，可以做的一些动作，如这里的DependencyInjectionTestExecutionListener.class，就可以对一测试类中的依赖进行注入，TransactionalTestExecutionListener.class用于对事务进行管理；这两个都是Srping自带的； 我们也可以实现自己的Listener类来完成我们自己的操作，只需要继续类org.springframework.test.context.support.AbstractTestExecutionListener就可以了，具体可以参照DependencyInjectionTestExecutionListener.class的实现，后面我会贴出实例。 Listener实在实现类执行之前被执行、实现类的测试方法之前被执行，这与Listener的实现有关。
@Transactional：这里的@Transactional不是必须的，这里是和@TestExecutionListeners中的TransactionalTestExecutionListener.class配合使用，用于保证插入的数据库中的测试数据，在测试完后，事务回滚，将插入的数据给删除掉，保证数据库的干净。如果没有显示的指定@Transactional，那么插入到数据库中的数据就是真实的插入了。


----
#dev开发
##spring自定义标签实现
[自定义Spring配置标签](http://blog.csdn.net/bingduanlbd/article/details/38770685)
[spring自定义标签实现](http://mozhenghua.iteye.com/blog/1830842)

1、自定义标签可以做到封装
把真正用户需要关心的东西提供出来，把用户不需要关心的内容隐示的实现掉。
2、自定义标签可以做到标签检查
对用户填写信息的控制做到一定的检查，对中间组件的配置信息有一定的规范可以帮助开发人员正常的使用，避免出现问题时难以定位问题所在。
3、自定义标签可以在标签处理时，做任何你想“预做”的事情，如一个数据库连接，可以尝试的该实例在创建时便尝试连接数据库看是否正常。

###spring.handlers 
这个文件的作用是将配置文件中的命名空间与处理命名空间的handler（NamespaceHandlerSupport）联系起来
http\://code.xxx.com/schema/proxy=com.xxx.proxy.core.config.schema.ProxyNamespaceHandlerSuppor
###spring.schemas
这个文件的作用是定义xsd文件的虚拟路径
http\://code.xxx.com/schema/proxy/proxy.xsd=/META-INF/proxy.xsd

###namespaceHandler 类，用来为这个名称空间下的每个标签定义解析器

    public class ProxyNamespaceHandlerSupport extends NamespaceHandlerSupport {
        public ProxyNamespaceHandlerSupport() {
        }
        public void init() {
            this.registerBeanDefinitionParser("protocol", new ProxyBeanDefinitionParser(ProtocalBean.class, true));
            this.registerBeanDefinitionParser("service", new ProxyBeanDefinitionParser(ServiceBean.class, true));
        }
    }

[spring自定义标签实现 之一对多实体解析](http://mozhenghua.iteye.com/blog/1914155)

---
#event
ContextClosedEvent
ContextRefreshedEvent
ContextStartedEvent
ContextStoppedEvent
RequestHandleEvent 

























