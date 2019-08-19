package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.Specimen;
import com.pathcare.pathprovider.resource.model.specimen.SpecimenRequest;
import com.pathcare.pathprovider.resource.model.specimen.SpecimenResponse;
import com.pathcare.pathprovider.service.SpecimenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.stream.Collectors;


@Component
@Path("v1")
public class SpecimenResource extends BaseResource {

    @Autowired
    private SpecimenService specimenService;


    public SpecimenResource(SpecimenService specimenService) {
        this.specimenService = specimenService;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("specimen")
    @Transactional
    public List<SpecimenResponse> returnSpecimens(SpecimenRequest specimenRequest) {
        List<Specimen> specimenList = specimenService.returnAllSpecimens(findPrincipalName(), specimenRequest);
        return specimenList.stream().map(t -> new SpecimenResponse(t)).collect(Collectors.toList());
    }
}
