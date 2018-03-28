


# 拦截器
https://stackoverflow.com/questions/24140494/how-to-test-spring-handlerinterceptor-mapping/24140495#24140495
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath*:META-INF/spring.xml", ... })
public class InterceptorTest {

@Autowired
private RequestMappingHandlerAdapter handlerAdapter;

@Autowired
private RequestMappingHandlerMapping handlerMapping;

@Test
public void testInterceptor() throws Exception{


    MockHttpServletRequest request = new MockHttpServletRequest();
    request.setRequestURI("/test");
    request.setMethod("GET");


    MockHttpServletResponse response = new MockHttpServletResponse();

    HandlerExecutionChain handlerExecutionChain = handlerMapping.getHandler(request);

    HandlerInterceptor[] interceptors = handlerExecutionChain.getInterceptors();

    for(HandlerInterceptor interceptor : interceptors){
        interceptor.preHandle(request, response, handlerExecutionChain.getHandler());
    }

    ModelAndView mav = handlerAdapter. handle(request, response, handlerExecutionChain.getHandler());

    for(HandlerInterceptor interceptor : interceptors){
        interceptor.postHandle(request, response, handlerExecutionChain.getHandler(), mav);
    }

    assertEquals(200, response.getStatus());
    //assert the success of your interceptor

}

HandlerExecutionChain is populated with all the mapped interceptors for the specific request. If the mapping is failing, the interceptor will not be present in the list and hence not executed and the assertion at the end will fail.


