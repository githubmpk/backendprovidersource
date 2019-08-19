package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.ResultLabDao;
import com.pathcare.pathprovider.domain.ResultLab;
import com.pathcare.pathprovider.resource.model.ResultLabRequest;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ResultLabService {

    @Autowired
    private ResultLabDao resultLabDao;

    /**
     * get a lab result or list of results based on the params passed from FE
     *
     * @param resultLabRequest - parameters from FE
     * @return - html results
     */
    public List<ResultLab> returnResultLab(String username, ResultLabRequest resultLabRequest) {

       return resultLabDao.findResult(username, resultLabRequest, "AUD: Result Lab");

    }

}
