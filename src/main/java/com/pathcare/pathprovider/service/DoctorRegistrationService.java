package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.RegistrationDao;
import com.pathcare.pathprovider.domain.ClinicianDetails;
import com.pathcare.pathprovider.resource.model.MpNumberRequest;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DoctorRegistrationService {

    @Autowired
    private RegistrationDao registrationDao;

    public List<ClinicianDetails> findClinicianDetails(MpNumberRequest mpNumberRequest) {
        return registrationDao.getRegistrationDetails(mpNumberRequest, "AUD: Get MpNo");
    }


}
