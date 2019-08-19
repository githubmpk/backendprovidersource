package com.pathcare.pathprovider.resource;


import com.pathcare.pathprovider.domain.Patient;
import com.pathcare.pathprovider.domain.security.UserDetails;
import com.pathcare.pathprovider.resource.model.patient.PatientModel;
import com.pathcare.pathprovider.resource.model.patient.PatientRequest;
import com.pathcare.pathprovider.resource.model.*;
import com.pathcare.pathprovider.resource.model.patient.PatientSearchData;
import com.pathcare.pathprovider.resource.model.user.UserModel;
import com.pathcare.pathprovider.service.InternalUserService;
import com.pathcare.pathprovider.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.stream.Collectors;


@Component
@Path("v1")
public class SelectPatientResource extends BaseResource {

    @Autowired
    private PatientService patientService;

    @Autowired
    private InternalUserService internalUserService;

    public SelectPatientResource() {
    }

    public SelectPatientResource(PatientService patientService) {
        this.patientService = patientService;
    }

    /**
     * get patient list/s
     *
     * @param patientRequest - request params from FE
     * @return - returns patient object
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("patient")
    @Transactional
    public List<PatientModel> returnPatients(PatientRequest patientRequest) {
        List<Patient> patientList = patientService.returnAllPatients(findPrincipalName(), patientRequest);
        return patientList.stream().map(t -> new PatientModel(t)).collect(Collectors.toList());
    }

    /**
     * a list of dept and profiles combines
     *
     * @param - FE request
     * @return - object of depts and profiles
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("dept_profile")
    @Transactional
    public PatientSearchData loadDeptAndProfile(UserDetails userDetails) {

        List<ProfileModel> profiles = patientService.returnProfile(findPrincipalName()).stream().map(ProfileModel::new).collect(
            Collectors.toList());

        List<DepartmentModel> departmentModels = patientService.returnDepartment(findPrincipalName()).stream().map(DepartmentModel::new).collect(
            Collectors.toList());

        List<UserModel> userModels = internalUserService.findUser(findPrincipalName()).stream().map(UserModel::new).collect(
            Collectors.toList());

        List<LinkModel> links = internalUserService.findLinks(findPrincipalName()).stream().map(LinkModel::new).collect(
            Collectors.toList());

        PatientSearchData response = new PatientSearchData();
        response.setDepartmentModel(departmentModels);
        response.setProfile(profiles);
        response.setUserModel(userModels);
        response.setLinkModels(links);

        return response;
    }
}
