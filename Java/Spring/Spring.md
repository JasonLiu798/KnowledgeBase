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
##七大模块
1. Spring Core： Core封装包是框架的最基础部分，提供IOC和依赖注入特性。这里的基础概念是BeanFactory，它提供对Factory模式的经典实现来消除对程序性单例模式的需要，并真正地允许你从程序逻辑中分离出依赖关系和配置。
2.Spring Context: 构建于Core封装包基础上的 Context封装包，提供了一种框架式的对象访问方法，有些象JNDI注册器。Context封装包的特性得自于Beans封装包，并添加了对国际化（I18N）的支持（例如资源绑定），事件传播，资源装载的方式和Context的透明创建，比如说通过Servlet容器。
3．Spring DAO:  DAO (Data Access Object)提供了JDBC的抽象层，它可消除冗长的JDBC编码和解析数据库厂商特有的错误代码。 并且，JDBC封装包还提供了一种比编程性更好的声明性事务管理方法，不仅仅是实现了特定接口，而且对所有的POJOs（plain old Java objects）都适用。
4.Spring ORM: ORM 封装包提供了常用的“对象/关系”映射APIs的集成层。 其中包括JPA、JDO、Hibernate 和 iBatis 。利用ORM封装包，可以混合使用所有Spring提供的特性进行“对象/关系”映射，如前边提到的简单声明性事务管理。
5.Spring AOP: Spring的 AOP 封装包提供了符合AOP Alliance规范的面向方面的编程实现，让你可以定义，例如方法拦截器（method-interceptors）和切点（pointcuts），从逻辑上讲，从而减弱代码的功能耦合，清晰的被分离开。而且，利用source-level的元数据功能，还可以将各种行为信息合并到你的代码中。
6.Spring Web: Spring中的 Web 包提供了基础的针对Web开发的集成特性，例如多方文件上传，利用Servlet listeners进行IOC容器初始化和针对Web的ApplicationContext。当与WebWork或Struts一起使用Spring时，这个包使Spring可与其他框架结合。
7.Spring Web MVC: Spring中的MVC封装包提供了Web应用的Model-View-Controller（MVC）实现。Spring的MVC框架并不是仅仅提供一种传统的实现，它提供了一种清晰的分离模型，在领域模型代码和Web Form之间。并且，还可以借助Spring框架的其他特性。


##IOC
接口注入（Type 1 IoC）
setter注入（Type 2 IoC）
构造器注入（Type 3 IoC）

IoC容器系列
##BeanFactory
接口的简单容器系列
Factory，是IOC容器或对象工厂

##FactoryBean
Bean
能产生或修饰对象生成的工厂Bean

##ApplicationContext
应用上下文，它作为容器的高级形态而存在


##流程
###BeanDefination资源定位
ResourceLoader通过Resource接口完成
* Resource定位

###BeanDefination载入
组装成BeanDefination
###注册
HashMap




##2.5 容器其他相关特性实现
* lazy-init属性实现：
refresh
    finishBeanFactoryInitialization(beanFactory);

* FactoryBean实现
getObjectForBeanInstance
    getCachedObjectForFactoryBean

* BeanPostProcessor实现






-----

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

@Autowired
默认按类型装配,自动注入，自动从spring的上下文找到合适的bean来注入，一般装配在set方法之上，也可以装配在属性上边，但是在属性上边配置，破坏了java的封装，所以一般不建议使用
@Resource
默认按名称装配，当找不到名称匹配的bean才会按类型装配，用来指定名称注入

如果当Spring上下文中存在不止一个所要装配类型的bean时，就会抛出BeanCreationException异常；如果Spring上下文中不存在所要装配类型的bean，也会抛出BeanCreationException异常。我们可以使用@Qualifier配合@Autowired来解决这些问题。

Qualifier和Autowired配合使用，指定bean的名称
Service，Controller，Repository分别标记类是Service层类
Controller层类，数据存储层的类，spring扫描注解配置时，会标记这些类要生成bean。
Component 是一种泛指，标记类是组件，spring扫描注解配置时，会标记这些类要生成bean。
```
@Autowired    
public void setUserDao(@Qualifier("userDao") UserDao userDao) {     
   this.userDao = userDao;  

@Autowired(required = false)     
public void setUserDao(UserDao userDao) {     
    this.userDao = userDao;   

```

@Resource
JSR-250标准注解
@Resource的作用相当于@Autowired，只不过@Autowired按byType自动注入，而@Resource默认按byName自动注入罢了。@Resource有两个属性是比较重要的，分别是name和type，Spring将@Resource注解的name属性解析为bean的名字，而type属性则解析为bean的类型。所以如果使用name属性，则使用byName的自动注入策略，而使用type属性时则使用byType自动注入策略。如果既不指定name也不指定type属性，这时将通过反射机制使用byName自动注入策略

@Resource装配顺序
1 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常
2 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常
3 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常
4 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配（见2）；如果没有匹配，则回退为一个原始类型（UserDao）进行匹配，如果匹配则自动装配；

@PostConstruct（JSR-250）
在方法上加上注解@PostConstruct，这个方法就会在Bean初始化之后被Spring容器执行（注：Bean初始化包括，实例化Bean，并装配Bean的属性（依赖注入））。
它的一个典型的应用场景是，当你需要往Bean里注入一个其父类中定义的属性，而你又无法复写父类的属性或属性的setter方法时，如：

@Component注解定义的Bean，默认的名称（id）是小写开头的非限定类名。如这里定义的Bean名称就是userDaoImpl。你也可以指定Bean的名称：
@Component("userDao")
@Component是所有受Spring管理组件的通用形式，Spring还提供了更加细化的注解形式：@Repository、@Service、@Controller，它们分别对应存储层Bean，业务层Bean，和展示层Bean。目前版本（2.5）中，这些注解与@Component的语义是一样的，完全通用，在Spring以后的版本中可能会给它们追加更多的语义。所以，我们推荐使用@Repository、@Service、@Controller来替代@Component。
6.使用<context:component-scan />让Bean定义注解工作起来


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

@PostConstruct
@PreDestroy


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



---
#事务传播
PROPAGATION_REQUIRED--支持当前事务，如果当前没有事务，就新建一个事务，这是最常见的选择
PROPAGATION_SUPPORTS--支持当前事务，如果当前没有事务，就以非事务方式执行。 
PROPAGATION_MANDATORY--支持当前事务，如果当前没有事务，就抛出异常。 
PROPAGATION_REQUIRES_NEW--新建事务，如果当前存在事务，把当前事务挂起。 
PROPAGATION_NOT_SUPPORTED--以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。 
PROPAGATION_NEVER--以非事务方式执行，如果当前存在事务，则抛出异常。 


---
#struts2对比
1.  机制：spring mvc的入口是servlet，而struts2是filter。
    补充几点知识：
    《 Filter 实现javax.servlet.Filter接口，在web.xml中配置与标签指定使用哪个Filter实现类过滤哪些URL链接。只在web启动时进行初始化操作。 filter 流程是线性的， url传来之后，检查之后，可保持原来的流程继续向下执行，被下一个filter, servlet接收等，而servlet 处理之
后，不会继续向下传递。filter功能可用来保持流程继续按照原来的方式进行下去，或者主导流程，而servlet的功能主要用来主导流程。 
特点：可以在响应之前修改Request和Response的头部，只能转发请求，不能直接发出响应。filter可用来进行字符编码的过滤，检测用户 
是否登陆的过滤，禁止页面缓存等》
        《 Servlet， servlet 流程是短的，url传来之后，就对其进行处理，之后返回或转向到某一自己指定的页面。它主要用来在业务处理之前进行控制 》
        《 Listener呢？我们知道 servlet、filter都是针对url之类的，而listener是针对对象的操作的，如session的创建，session.setAttribute的发生，在这样的事件发 生时做一些事情。 》 

2. 性能：spring会稍微比struts快。 spring mvc是基于方法的设计 ， 而sturts是基于类 ，每次发一次请求都会实例一个action，每个action都会被注入属性，而spring基于方法，粒度更细(粒度级别的东西比较sychronized和lock)，但要小心把握像在servlet控制数据一样。 spring3 mvc是方法级别的拦截，拦截到方法后根据参数上的注解，把request数据注入进去，在spring3 mvc中，一个方法对应一个request上下文。 而struts2框架是类级别的拦截，每次来了请求就创建一个Action，然后调用setter getter方法把request中的数据注入；struts2实际上是通过setter getter方法与request打交道的；struts2中，一个Action对象对应一个request上下文。
3. 参数传递：struts是在接受参数的时候，可以用属性来接受参数，这就说明参数是让多个方法共享的。所以D是对的。
4. 设计思想上： struts更加符合oop的编程思想 ， spring就比较谨慎，在servlet上扩展。
5. intercepter(拦截器)的实现机制：struts有以自己的interceptor机制， spring mvc用的是独立的AOP方式 。这样导致struts的配置文件量还是比spring mvc大，虽然struts的配置能继承，所以我觉得，就拿使用上来讲，spring mvc使用更加简洁， 开发效率Spring MVC确实比struts2高 。 spring mvc是方法级别的拦截，一个方法对应一个request上下文，而方法同时又跟一个url对应，所以说从架构本身上 spring3 mvc就容易实现restful url 。 struts2是类级别的拦截，一个类对应一个request上下文；实现restful url要费劲，因为struts2 action的一个方法可以对应一个url；而其类属性却被所有方法共享，这也就无法用注解或其他方式标识其所属方法了。 spring3 mvc的方法之间基本上独立的，独享request response数据，请求数据通过参数获取，处理结果通过ModelMap交回给框架方法之间不共享变量， 而struts2搞的就比较乱，虽然方法之间也是独立的，但其所有Action变量是共享的，这不会影响程序运行，却给我们编码，读程序时带来麻烦。
6. 另外，spring3 mvc的验证也是一个亮点，支持JSR303， 处理ajax的请求更是方便 ，只需一个注解 @ResponseBody  ，然后直接返回响应文本即可。 代码：
@RequestMapping (value= "/whitelists" )  
public  String index(ModelMap map) {  
    Account account = accountManager.getByDigitId(SecurityContextHolder.get().getDigitId());  
    List<Group> groupList = groupManager.findAllGroup(account.getId());  
    map.put("account" , account);  
    map.put("groupList" , groupList);  
    return   "/group/group-index" ;  
}  
// @ResponseBody ajax响应，处理Ajax请求也很方便   
@RequestMapping (value= "/whitelist/{whiteListId}/del" )  
@ResponseBody   
public  String delete( @PathVariable  Integer whiteListId) {  
    whiteListManager.deleteWhiteList(whiteListId);  
    return   "success" ;  
} 






---
#schedule
[解析spring schedule](http://blog.csdn.net/cutesource/article/details/4900020)


















