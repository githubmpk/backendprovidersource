package com.pathcare.pathprovider.dao;


import com.pathcare.pathprovider.domain.Department;
import com.pathcare.pathprovider.domain.Patient;
import com.pathcare.pathprovider.domain.Profile;
import com.pathcare.pathprovider.resource.model.patient.PatientRequest;
import com.pathcare.pathprovider.util.DateConverters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.List;


@Component
public class PatientDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    public PatientDao(AuditDao auditDao) {
        super(auditDao);
    }

    public List<Patient> getPatients(PatientRequest patientRequest, String username, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spPatientlist");
        storedProcedureQuery.setParameter("iProviderId", patientRequest.getProviderId());
        storedProcedureQuery.setParameter("doctorMnemonic", patientRequest.getDoctorMnemonic());
        storedProcedureQuery.setParameter("vchList", patientRequest.getProviderList());
        storedProcedureQuery.setParameter("vchPatFirstName", patientRequest.getPatientFirstName());
        storedProcedureQuery.setParameter("vchPatSurname", patientRequest.getPatientSurname());
        storedProcedureQuery.setParameter("vchPatID", patientRequest.getPatientID());
        storedProcedureQuery.setParameter("dPatDOB", (patientRequest.getPatientDOB()));
        storedProcedureQuery
            .setParameter("vchRequisitionNumber", patientRequest.getRequisitionNumber());
        storedProcedureQuery.setParameter("vchProfileList", patientRequest.getProfileList());
        storedProcedureQuery.setParameter("vchDepartment", patientRequest.getDepartment());
        String startDate = DateConverters
            .convertDateToStringDashFormat(patientRequest.getStartDate());
        storedProcedureQuery.setParameter("dStart", startDate);
        String endDate = DateConverters.convertDateToStringDashFormat(patientRequest.getEndDate());
        storedProcedureQuery.setParameter("dEnd", endDate);
        storedProcedureQuery.execute();
        List resultList = storedProcedureQuery.getResultList();

        Integer requisitionNumber = StringUtils.isEmpty(patientRequest.getRequisitionNumber())
            ? 0
            : Integer.parseInt(patientRequest.getRequisitionNumber());

        audit(username, detail, "spRPPatientListGet", "SearchPATIENT", 0, requisitionNumber, 0 );
        return resultList;
    }


    public List<Profile> findAllProfiles(String username, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spProfiles");
        storedProcedureQuery.execute();
        List resultList = storedProcedureQuery.getResultList();
        String process = resultList.isEmpty() ? "GetPROFILELISTFAIL" : "GetPROFILELIST";
        audit(username, detail, "spRPProfileList", process);
        return resultList;
    }

    public List<Department> findAllDepartments(String username, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spDepartments");
        storedProcedureQuery.execute();
        List resultList = storedProcedureQuery.getResultList();
        String process = resultList.isEmpty() ? "GetDEPARTMENTLISTFAIL" : "GetDEPARTMENTLIST";
        audit(username, detail, "spRPDepartmentList", process );
        return resultList;
    }
}
