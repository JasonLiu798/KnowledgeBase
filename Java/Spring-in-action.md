

#spring bean的初始化顺序
1.构造函数
2.初始化属性
3.如果实现了BeanFactoryAware 接口执行setBeanFactory方法
4..如果实现了InitializingBean 接口执行afterPropertiesSet方法
5.如果在配置文件中指定了init-method，那么执行该方法
6..如果实现了BeanFactoryPostProcessor 接口在 “new”其他类之前执行 postProcessBeanFactory 方法（通过这个方法可以改变配置文件里面的属性值的配置）
7.如果实现了BeanFactoryPostProcessor 接口，那么会在其他bean初始化方法之前执行postProcessBeforeInitialization 方法，之后执行postProcessAfterInitialization方法
