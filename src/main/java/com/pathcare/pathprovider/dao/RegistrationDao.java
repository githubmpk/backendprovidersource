package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.ClinicianDetails;
import com.pathcare.pathprovider.resource.model.MpNumberRequest;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class RegistrationDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;


    @Autowired
    public RegistrationDao(AuditDao auditDao) {
        super(auditDao);
    }

    public List<ClinicianDetails> getRegistrationDetails(MpNumberRequest mpNumberRequest, String auditDetail) {

        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spRegistrationDetail");
        storedProcedureQuery.setParameter("vchSearch", mpNumberRequest.getMpNo());
        storedProcedureQuery.execute();
        return storedProcedureQuery.getResultList();
    }
}
