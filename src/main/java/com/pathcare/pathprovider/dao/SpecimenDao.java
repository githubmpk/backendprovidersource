package com.pathcare.pathprovider.dao;


import com.pathcare.pathprovider.domain.Specimen;
import com.pathcare.pathprovider.resource.model.specimen.SpecimenRequest;
import com.pathcare.pathprovider.util.DateConverters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.List;

@Component
public class SpecimenDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    public SpecimenDao(AuditDao auditDao) {
        super(auditDao);
    }

    public List<Specimen> getSpecimen(String username, SpecimenRequest specimenRequest,
        String detail) {

        String startDate = DateConverters
            .convertDateToStringDashFormat(specimenRequest.getStartDate());
        String endDate = DateConverters.convertDateToStringDashFormat(specimenRequest.getEndDate());

        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spSpecimenList");
        storedProcedureQuery.setParameter("providerId", specimenRequest.getProviderId());
        storedProcedureQuery.setParameter("doctorMnemonic", specimenRequest.getDoctorMnemonic());
        storedProcedureQuery.setParameter("searchRequisition", specimenRequest.getSearchRequisition());
        storedProcedureQuery.setParameter("patientId", specimenRequest.getPatientId());
        storedProcedureQuery.setParameter("department", specimenRequest.getDepartment());
        storedProcedureQuery.setParameter("profileList", specimenRequest.getProfileList());
        storedProcedureQuery.setParameter("startDate", startDate);
        storedProcedureQuery.setParameter("endDate", endDate);
        storedProcedureQuery.setParameter("viewedStatus", specimenRequest.getViewedStatus());

        List resultList = storedProcedureQuery.getResultList();
        String process =
            resultList.isEmpty() ? "GetSPECIMENFAIL" : "GetSPECIMEN";
        audit(username, detail, "spRPSpecimenList", process);
        return resultList;
    }
}

