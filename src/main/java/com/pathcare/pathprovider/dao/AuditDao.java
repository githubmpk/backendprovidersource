package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.Audit;
import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component
public class AuditDao {

    @Autowired
    private EntityManager entityManager;

    /**
     * An insert audit to spAudit
     *
     * @param audit - with the required params set specific to each process
     * @return true on success
     */
    public boolean insertAudit(Audit audit) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spAudit");
        storedProcedureQuery.setParameter("vchApplication", audit.getApplication());
        storedProcedureQuery.setParameter("vchDetail", audit.getDetail());
        storedProcedureQuery.setParameter("vchIPAddress", audit.getIpAddress());
        storedProcedureQuery.setParameter("biPatientId", audit.getPatiendID());
        storedProcedureQuery.setParameter("vchProcess", audit.getProcess());
        storedProcedureQuery.setParameter("vchUsername", audit.getUserName());
        storedProcedureQuery.setParameter("biSpecimenId", audit.getSpecimenID());
        storedProcedureQuery.setParameter("vchStoredProc", audit.getStoredProc());
        storedProcedureQuery.setParameter("biRequisitionId", audit.getRequstionID());
        storedProcedureQuery.setParameter("vchBrowser", audit.getBrowser());

        return storedProcedureQuery.execute();

    }
}
