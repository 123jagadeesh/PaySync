package com.paysync.backend.config;

import com.paysync.backend.security.FirebaseTokenFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SecurityConfig {

    @Bean
    public FilterRegistrationBean<FirebaseTokenFilter> firebaseFilterRegistration(FirebaseTokenFilter filter) {
        FilterRegistrationBean<FirebaseTokenFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(filter);
        registrationBean.addUrlPatterns("/api/*"); // protect any route under /api/
        // Set order to a low precedence so CORS filter runs before it
       registrationBean.setOrder(1);
        return registrationBean;
    }
}
