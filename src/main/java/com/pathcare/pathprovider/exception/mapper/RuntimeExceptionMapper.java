package com.pathcare.pathprovider.exception.mapper;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pathcare.pathprovider.resource.model.APIResponse;

import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RuntimeExceptionMapper implements ExceptionMapper<RuntimeException> {

    private ObjectMapper objectMapper = new ObjectMapper();

    private static final Logger LOGGER = LoggerFactory.getLogger(RuntimeExceptionMapper.class);


    @Override
    public Response toResponse(RuntimeException e) {
        APIResponse response = new APIResponse(false, e.getMessage(), null, null);
        try {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .header("Content-Type", "application/json")
                .entity(objectMapper.writeValueAsString(response))
                .build();
        } catch (JsonProcessingException e1) {
            LOGGER.error("error parsing api response", e1);
        }
        return null;
    }
}