
package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.resource.model.Message;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Path;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorAttributes;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;


/**
 * In Spring the whitelabel page /error is overridden here with a REST controller.
 * If any errors occur during processing this response will serve back a JSON
 * response rather than HTML which is the default
 */
@Path("v1")
@RestController
public class PathProviderError implements ErrorController {

    private boolean debug;


    private static final String PATH = "/error";

    @Autowired
    private ErrorAttributes errorAttributes;

    public PathProviderError() {
    }

    @RequestMapping(value = PATH)
    ErrorJson error(HttpServletRequest request, HttpServletResponse response) {
        return new ErrorJson(response.getStatus(), getErrorAttributes(request, debug));
    }


    @Override
    public String getErrorPath() {
        return PATH;
    }

    private Map<String, Object> getErrorAttributes(HttpServletRequest request,
                                                   boolean includeStackTrace) {
        // RequestAttributes requestAttributes = new ServletRequestAttributes(request);
        WebRequest requestAttributes = new ServletWebRequest(request);
        return errorAttributes.getErrorAttributes(requestAttributes, includeStackTrace);
    }


    @JsonInclude
    public class ErrorJson {
        private String type;
        private Integer status;
        private List<Message> errors = new ArrayList<>();
        private String timeStamp;
        private String trace;


        public ErrorJson(int status, Map<String, Object> errorAttributes) {
            this.status = status;
            this.errors.add(
                new Message((String) errorAttributes.get("error"),
                    (String) errorAttributes.get("message"),
                    "VALUE")
            );
            this.timeStamp = errorAttributes.get("timestamp").toString();
            this.trace = (String) errorAttributes.get("trace");
        }

        /**
         * @return the type
         */
        public String getType() {
            return type;
        }

        /**
         * @param type the type to set
         */
        public void setType(String type) {
            this.type = type;
        }

        /**
         * @return the status
         */
        public Integer getStatus() {
            return status;
        }

        /**
         * @param status the status to set
         */
        public void setStatus(Integer status) {
            this.status = status;
        }

        /**
         * @return the errors
         */
        public List<Message> getErrors() {
            return errors;
        }

        /**
         * @param errors the errors to set
         */
        public void setErrors(List<Message> errors) {
            this.errors = errors;
        }

        /**
         * @return the timeStamp
         */
        public String getTimeStamp() {
            return timeStamp;
        }

        /**
         * @param timeStamp the timeStamp to set
         */
        public void setTimeStamp(String timeStamp) {
            this.timeStamp = timeStamp;
        }

        /**
         * @return the trace
         */
        public String getTrace() {
            return trace;
        }

        /**
         * @param trace the trace to set
         */
        public void setTrace(String trace) {
            this.trace = trace;
        }

    }
}

