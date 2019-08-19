package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.ClinicianDetails;
import com.pathcare.pathprovider.domain.InternalUser;
import com.pathcare.pathprovider.resource.model.InternalUserRequest;
import com.pathcare.pathprovider.resource.model.MpNumberRequest;
import com.pathcare.pathprovider.service.DoctorRegistrationService;
import com.pathcare.pathprovider.service.InternalUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.List;

@Component
@Path("v1/doctor")
public class DoctorRegistrationResource {

    @Autowired
    DoctorRegistrationService doctorRegistrationService;

    @Autowired
    InternalUserService internalUserService;

    /**
     * find details
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public List<ClinicianDetails> findDetails(MpNumberRequest mpNumberRequest) {
        List<ClinicianDetails> clinicianDetail = doctorRegistrationService.findClinicianDetails(mpNumberRequest);
        return clinicianDetail;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("register")
    @Transactional
    public ResponseEntity returnInternalUsers(InternalUserRequest internalUserRequest) {
        List<InternalUser> internalList = internalUserService.updateUser(internalUserRequest);
        if (internalList == null || internalList.isEmpty()) {
            return new ResponseEntity(HttpStatus.CONFLICT);
        } else {
            return new ResponseEntity(HttpStatus.CREATED);
        }
    }
}
