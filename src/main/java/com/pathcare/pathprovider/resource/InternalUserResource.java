package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.InternalUser;
import com.pathcare.pathprovider.resource.model.InternalUserRequest;
import com.pathcare.pathprovider.service.InternalUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.List;


@Component
@Path("v1/internaluser")
public class InternalUserResource {

    @Autowired
    private InternalUserService internalUserService;


    public InternalUserResource() {

    }

    public InternalUserResource(InternalUserService internalUserService) {

        this.internalUserService = internalUserService;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public String returnUser(InternalUserRequest internalUserRequest) {
        List<InternalUser> internalList = internalUserService.findUser("testing");  //TODO user testing?
        return internalList.get(0).getId();
    }

}
