package com.pathcare.pathprovider.service;


import com.pathcare.pathprovider.dao.PatientDao;
import com.pathcare.pathprovider.domain.Department;
import com.pathcare.pathprovider.domain.Patient;
import com.pathcare.pathprovider.domain.Profile;
import com.pathcare.pathprovider.resource.model.patient.PatientRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class PatientService {

    @Autowired
    private PatientDao patientDao;

    /**
     * get a patient or list of patient based on the params passed from FE
     *
     * @param patientRequest - parameters from FE
     * @return - patient or patientList
     */
    public List<Patient> returnAllPatients(String username, PatientRequest patientRequest) {

       return patientDao
            .getPatients(patientRequest, username, "AUD: Search Patient");

    }

    /**
     * Get list of profiles
     */
    public List<Profile> returnProfile(String username) {
        return patientDao.findAllProfiles(username, "AUD: Get profiles list");
    }

    /**
     * Get the list of department This is info required for auto populating department
     *
     * @return -formatted for front end response into DepartmentModel
     */
    public List<Department> returnDepartment(String username) {

        return patientDao
            .findAllDepartments(username, "AUD: Get department list");
    }
}
