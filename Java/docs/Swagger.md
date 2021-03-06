

# 配置
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * http://localhost:1080/v2/api-docs
 */
//@Configuration
//@EnableWebMvc //NOTE: Only needed in a non-springboot application
//@EnableSwagger2
//@Configuration
@EnableSwagger2
@ComponentScan("com.xxx")
public class ApplicationSwaggerConfig {//extends WebMvcConfigurationSupport {
//{//extends WebMvcConfigurationSupport {
    //extends WebMvcConfigurerAdapter {//WebMvcConfigurationSupport {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.xxx"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("xxx")
                .termsOfServiceUrl("http://xxx.com")
                .version("1.0")
                .build();
    }
}
```
```xml
    <!-- swagger -->
    <context:annotation-config/>
    <bean class="com.sf.aos.config.ApplicationSwaggerConfig"/>
```

[Setting Up Swagger 2 with a Spring REST API](http://www.baeldung.com/swagger-2-documentation-for-spring-rest-api)


https://github.com/swagger-api/swagger-ui

[](http://www.mamicode.com/info-detail-525592.html)
[Swagger+Spring mvc生成Restful接口文档](http://www.cnblogs.com/yuananyun/p/4993426.html)

```xml
<properties>
    <swagger.version>2.2.2</swagger.version>
</properties>

<dependency>
    <groupId>com.mangofactory</groupId>
    <artifactId>swagger-springmvc</artifactId>
    <version>1.0.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>${swagger.version}</version>
</dependency>
<!--示例 -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-petstore</artifactId>
    <version>${swagger.version}</version>
</dependency>
```

默认地址
/v2/api-docs

#cdn
http://www.bootcdn.cn/swagger-ui/

---
#Q
##No qualifying bean of type RequestMappingHandlerMapping found for dependency
[SpringMVC 集成 Swagger【问题】 No qualifying bean of type RequestMappingHandlerMapping found for dependency](http://www.cnblogs.com/driftsky/p/4952918.html)
如果出现了上述问题，将@Configuration配置干掉，而是采用bean的方式进行配置

问题集合
[stringfox issue 462]: https://github.com/springfox/springfox/issues/462
[stringfox issue 160]: https://github.com/springfox/springfox/issues/160
[竞态条件深入分析]: http://forum.spring.io/forum/spring-projects/web/112154-unable-to-autowire-requestmappinghandlermapping-in-controller

[Spring boot & Swagger 2 UI & custom requestmappinghandlermapping - mapping issue](https://stackoverflow.com/questions/36744678/spring-boot-swagger-2-ui-custom-requestmappinghandlermapping-mapping-issue)















