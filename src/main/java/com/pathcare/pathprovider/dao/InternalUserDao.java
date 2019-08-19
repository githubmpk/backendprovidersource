package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.InternalUser;
import com.pathcare.pathprovider.domain.TrustedLink;
import com.pathcare.pathprovider.resource.model.InternalUserRequest;
import com.pathcare.pathprovider.service.KeycloakService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.List;

@Component
public class InternalUserDao extends BaseAuditDao {

    @Value( "${keycloak.auth-server-url}" )
    private String kcUrl;

    @Value( "${kc.admin.password}" )
    private String kcAdminPasswd;

    @Value( "${keycloak.realm}" )
    private String kcRealm;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private KeycloakService keycloakService;

    @Autowired
    public InternalUserDao(AuditDao auditDao) {
        super(auditDao);
    }

    @Transactional
    public List<InternalUser> updateUser(InternalUserRequest internalUserRequest) {
        Long rsId = internalUserRequest.getRsId();
        Long inId = internalUserRequest.getInId();
        Long dtId = internalUserRequest.getDtId();

        //TODO fix
        String userId = null; //keycloakService.addUser(internalUserRequest);

        List resultList = null;
        if (userId != null) {
            StoredProcedureQuery storedProcedureQuery = this.entityManager.createNamedStoredProcedureQuery("spUserUpdate");

            storedProcedureQuery.setParameter("vchId", userId);
            storedProcedureQuery.setParameter("vchCallType", "V");
            storedProcedureQuery.setParameter("biRsId", rsId);
            storedProcedureQuery.setParameter("biInId", inId);
            storedProcedureQuery.setParameter("biDtId", dtId);

            storedProcedureQuery.execute();
            resultList = storedProcedureQuery.getResultList();
        } else {
            throw new RuntimeException("Unable insert new user into the internal database");
        }
        return resultList;
    }

    @Transactional
    public List<InternalUser> findUser(String username, String detail) {
        // //
        // Find user
        // //
        List resultList = null;
        if (username != null) {
            StoredProcedureQuery storedProcedureQuery = this.entityManager.createNamedStoredProcedureQuery("spUserFind");
            storedProcedureQuery.setParameter("vchId", username);
            storedProcedureQuery.execute();
            resultList = storedProcedureQuery.getResultList();
        } else {
            throw new RuntimeException("Error finding user");
        }
        String process = (resultList == null || resultList.isEmpty()) ? "No user found" : "User found";
        audit(username, detail, "spRpUserUpdate", process);
        return resultList;
    }

    @Transactional
    public List<TrustedLink> findLinks(String username, String detail) {
        // //
        // Find links
        // //
        List resultList = null;
        if (username != null) {
            StoredProcedureQuery storedProcedureQuery = this.entityManager.createNamedStoredProcedureQuery("spFindLinks");
            storedProcedureQuery.setParameter("vchId", username);
            storedProcedureQuery.setParameter("bReset", true);
            storedProcedureQuery.execute();
            resultList = storedProcedureQuery.getResultList();
        } else {
            throw new RuntimeException("Error finding links");
        }
        String process = (resultList == null || resultList.isEmpty()) ? "No links found" : "Links found";
        audit(username, detail, "spRpFindLinks", process);
        return resultList;
    }

}
