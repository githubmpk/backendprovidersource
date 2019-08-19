package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.Provider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.List;

@Component
public class ProviderDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    public ProviderDao(AuditDao auditDao) {
        super(auditDao);
    }

    public List<Provider> findAll(String username, String name, String detail) {
            StoredProcedureQuery storedProcedureQuery = this.entityManager
                .createNamedStoredProcedureQuery("spProvider");
            storedProcedureQuery.setParameter("Search", name);
            storedProcedureQuery.execute();
            List resultList = storedProcedureQuery.getResultList();
            String process =
                resultList.isEmpty() ? "GetPROVIDERLISTFAIL" : "GetPROVIDERLIST";
            audit(username, detail, "spRPProviderSelect", process);
            return resultList;
    }
}
