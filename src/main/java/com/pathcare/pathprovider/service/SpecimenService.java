package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.SpecimenDao;
import com.pathcare.pathprovider.domain.Specimen;
import com.pathcare.pathprovider.resource.model.specimen.SpecimenRequest;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SpecimenService {

    @Autowired
    private SpecimenDao specimenDao;

    /**
     * get a list of specimens
     *
     * @return - specimen object
     */
    public List<Specimen> returnAllSpecimens(String username, SpecimenRequest specimenRequest) {
        return specimenDao.getSpecimen(username, specimenRequest, "AUD: Get Specimen");
    }
}
