package com.pathcare.pathprovider;
import com.pathcare.pathprovider.exception.mapper.RuntimeExceptionMapper;
import com.pathcare.pathprovider.resource.*;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.ServerProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import javax.ws.rs.ApplicationPath;

@Configuration
@ApplicationPath("/pathprovider")
@ComponentScan(basePackages = {"com.pathcare.pathprovider.resource"})
public class JerseyConfig extends ResourceConfig {
	public JerseyConfig() {
		property(ServerProperties.BV_SEND_ERROR_IN_RESPONSE, true);
		property(ServerProperties.BV_DISABLE_VALIDATE_ON_EXECUTABLE_OVERRIDE_CHECK, true);
		register(ProviderResource.class);
		register(SelectPatientResource.class);
		register(SpecimenResource.class);
		register(DoctorRegistrationResource.class);
		register(PreferenceResource.class);
        register(ResultLabResource.class);
        register(RuntimeExceptionMapper.class);
	}
}