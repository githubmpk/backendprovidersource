package com.pathcare.pathprovider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
public class WebInfoFilter implements Filter {

    final Logger log = LoggerFactory.getLogger(WebInfoFilter.class);
    public static ThreadLocal<Map<String, String>> stringThreadLocal = new ThreadLocal<>();

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
        throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) res;
        HttpServletRequest request = (HttpServletRequest) req;
        try {

            String ipAddress = getIPAddress(request);
            String browser = request.getHeader("User-Agent");

            createWebInfoMap(ipAddress, browser);

            chain.doFilter(req, res);
        } catch (IOException ioe) {
            log.error("IOException in web info filer caught.");
            response.flushBuffer();
        } catch (Exception e) {
            log.error("Exception in web info filer caught.", e);
            response.flushBuffer();
        }
    }

    public void createWebInfoMap(String ipAddress, String browser) {
        Map<String, String> webInfoMap = new HashMap<>();
        webInfoMap.put("ipAddress", ipAddress);
        webInfoMap.put("browser", browser);


        stringThreadLocal.set(webInfoMap);
    }


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }


    public String getIPAddress(HttpServletRequest request) {
        String remoteAddr = "";

        if (request != null) {
            remoteAddr = request.getHeader("X-FORWARDED-FOR");
            if (remoteAddr == null || "".equals(remoteAddr)) {
                remoteAddr = request.getRemoteAddr();
            }
        }

        return remoteAddr;
    }

}
