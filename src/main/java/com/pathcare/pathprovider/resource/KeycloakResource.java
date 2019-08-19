package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.resource.model.user.UserAccountRequest;
import com.pathcare.pathprovider.resource.model.user.UserSearchRequest;
import com.pathcare.pathprovider.service.KeycloakService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Component
@Path("v1/user")
public class KeycloakResource {

    @Autowired
    KeycloakService keycloakService;

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("kclogin")
    @Transactional
    public ResponseEntity fetchToken(UserAccountRequest userAccountRequest) {
        return keycloakService.fetchToken(userAccountRequest);
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("resetpassword")
    @Transactional
    public ResponseEntity resetPasswordResource(UserSearchRequest userSearchRequest) {
//        return keycloakService.resetPassword(userSearchRequest);
        return null;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("refreshtoken")
    @Transactional
    //TODO fix to use jersey
    public ResponseEntity fetchRefreshedToken(@RequestHeader(value = "Authorization") String refreshToken, @RequestHeader(value = "ClientID", required = false) String clientId) {
        if (clientId != null && !clientId.isEmpty())
            return keycloakService.fetchRefreshedToken(refreshToken, clientId);
        else
            return keycloakService.fetchRefreshedToken(refreshToken);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @RequestMapping(method = RequestMethod.GET, value = "/logout", produces = MediaType.APPLICATION_JSON)
    //tODO fix to use jersey
    public ResponseEntity logoutUserResource(@RequestHeader(value = "UserID") String userId) {
//        return keycloakService.logoutUser(userId);
        return null;
    }
}
