package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.ResultLab;
import com.pathcare.pathprovider.resource.model.ResultLabRequest;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ResultLabDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    public ResultLabDao(AuditDao auditDao) {
        super(auditDao);
    }

    public List<ResultLab> findResult(String username, ResultLabRequest resultLabRequest, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager.createNamedStoredProcedureQuery("spReportResultLab");

        storedProcedureQuery.setParameter("patientId", resultLabRequest.getPatientId());
        storedProcedureQuery.setParameter("requisitionId", resultLabRequest.getRequisitionId());
        storedProcedureQuery.setParameter("specimenId", resultLabRequest.getSpecimenId());
        storedProcedureQuery.setParameter("drMnemonic", resultLabRequest.getDrMnemonic());
        storedProcedureQuery.setParameter("language", resultLabRequest.getLanguage());

        storedProcedureQuery.execute();
        List resultList = storedProcedureQuery.getResultList();
        String process = resultList.isEmpty() ? "GetRESULTLABFAIL" : "GetRESULTLAB";
        audit(username, detail, "spRpReportHtmlResultLab", process);
        return resultList;
    }
}
