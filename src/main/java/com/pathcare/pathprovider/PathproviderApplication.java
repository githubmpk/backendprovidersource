package com.pathcare.pathprovider;

import com.pathcare.pathprovider.exception.mapper.RuntimeExceptionMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import java.net.InetAddress;
import java.net.UnknownHostException;

@SpringBootApplication(scanBasePackages = "com.pathcare.pathprovider")
@EnableJpaRepositories
@EnableAutoConfiguration
public class PathproviderApplication implements ApplicationListener<ApplicationReadyEvent> {

	public static void main(String[] args) {
		SpringApplication.run(PathproviderApplication.class, args);
	}

    @Autowired
    private ApplicationContext applicationContext;

    private static final Logger LOGGER = LoggerFactory.getLogger(PathproviderApplication.class);

    public void onApplicationEvent(ApplicationReadyEvent event){
	    try {
            String ip = InetAddress.getLocalHost().getHostAddress();
            int port = applicationContext.getBean(Environment.class).getProperty("server.port", Integer.class, 8080);
            LOGGER.info("started on port: " + port);
        }catch (UnknownHostException e){
	        LOGGER.error("an error occurred initialising the application", e);
        }

    }
}
