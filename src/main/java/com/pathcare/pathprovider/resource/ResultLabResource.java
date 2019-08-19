package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.ResultLab;
import com.pathcare.pathprovider.resource.model.ResultLabRequest;
import com.pathcare.pathprovider.service.ResultLabService;
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
@Path("v1")
public class ResultLabResource extends BaseResource {

    @Autowired
    private ResultLabService resultLabService;


    public ResultLabResource() {

    }

    public ResultLabResource(ResultLabService resultLabService) {

        this.resultLabService = resultLabService;
    }

    /**
     * get result lab
     *
     * @param resultLabRequest - request params from FE
     * @return - returns htlm result
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_HTML)
    @Path("resultlab")
    @Transactional
    public String returnResultLab(ResultLabRequest resultLabRequest) {
        List<ResultLab> resultList = resultLabService.returnResultLab(findPrincipalName(), resultLabRequest);
        // return only 1st element for now, open to be extended later
        return resultList.get(0).getHtmlTxt();
    }

}
