package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.Preference;
import com.pathcare.pathprovider.resource.model.APIResponse;
import com.pathcare.pathprovider.resource.model.preference.PreferenceModel;
import com.pathcare.pathprovider.resource.model.preference.PreferenceRequest;
import com.pathcare.pathprovider.service.PreferenceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Component
@Path("v1")
public class PreferenceResource extends BaseResource {

    @Autowired
    private PreferenceService preferenceService;

    public PreferenceResource() {

    }

    public PreferenceResource(PreferenceService preferenceService) {
        this.preferenceService = preferenceService;
    }

    /**
     * get user preference
     *
     * @param preferenceRequest - request params from FE
     * @return - returns user preference
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("preferences")
    @Transactional
    public APIResponse returnPreference(PreferenceRequest preferenceRequest) {
        String principal = findPrincipalName();
        Preference preferenceList = preferenceService.returnUserPreferences(principal, preferenceRequest);
        PreferenceModel preferenceModel = new PreferenceModel(preferenceList);
        return new APIResponse(true, "", preferenceModel, null);

    }


    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updatePreferences")
    @Transactional
    public APIResponse setPreference(PreferenceRequest preferenceRequest) {
        String principal = findPrincipalName();
        preferenceService.setUserPreferences(principal, preferenceRequest);
        APIResponse response = new APIResponse(true, "Data saved successfully", null, null);
        return response;

    }


}


