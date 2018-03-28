

    <mvc:interceptors>
        <mvc:interceptor>
            <mvc:mapping path="/logback"/>
            <mvc:mapping path="/read-header"/>
            <mvc:mapping path="/form/*"/>
            <bean class="interceptor.MyInterceptor"></bean>
        </mvc:interceptor>
    </mvc:interceptors>




    
