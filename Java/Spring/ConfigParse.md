
# 配置解析
BeanDefinitionParser


## mvc:annotation
### RequestMappingHandlerMapping
	RootBeanDefinition handlerMappingDef = new RootBeanDefinition(RequestMappingHandlerMapping.class);

BeanNameUrlHandlerMapping

### RequestMappingHandlerAdapter  
	RootBeanDefinition handlerAdapterDef = new RootBeanDefinition(RequestMappingHandlerAdapter.class);

HttpRequestHandlerAdapter  
SimpleControllerHandlerAdapter  

### ExceptionHandlerExceptionResolver   
	RootBeanDefinition exceptionHandlerExceptionResolver = new RootBeanDefinition(ExceptionHandlerExceptionResolver.class);  


### ResponseStatusExceptionResolver
	RootBeanDefinition responseStatusExceptionResolver = new RootBeanDefinition(ResponseStatusExceptionResolver.class);  


### DefaultHandlerExceptionResolver   
	RootBeanDefinition defaultExceptionResolver = new RootBeanDefinition(DefaultHandlerExceptionResolver.class);

