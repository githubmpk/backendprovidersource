package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.User;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UserDao extends BaseAuditDao {

    @PersistenceContext
    private EntityManager entityManager;


    @Autowired
    public UserDao(AuditDao auditDao) {
        super(auditDao);
    }

    /**
     * get user details and store in session username username required for audit into purposes
     *
     * @param username - username for login
     * @return - validated user
     */
    public User getLoginDetails(String username) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spFindUserByEmployeeNo");
        storedProcedureQuery.setParameter("username", username);
        storedProcedureQuery.execute();
        List<User> resultList = storedProcedureQuery.getResultList();
        User user = null;
        if (!resultList.isEmpty()) {
            user = resultList.get(0);
            user.setAuthorities(
                resultList.stream().map(r -> r.getRoles()).collect(Collectors.toList()));
        }
        return user;
    }

    public void auditLogin(String username, String detail, User user) {
        String storedProcName = "spRPFindUserByEmployeeNo";

            audit(username, detail, storedProcName,
                user == null ? "employeeNoNOTFOUND" : "employeeNoFOUND");
    }

    public void updateLoginDetails(String username, boolean authenticated, String detail) {
        String storedProcName = "spRPUserLoginUpdate";
        String process = authenticated ? "LoginSUCCESS" : "LoginFAIL";

        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery(storedProcName);
        storedProcedureQuery.setParameter("username", username);
        storedProcedureQuery.setParameter("loginStatus", authenticated ? "SUCCESS" : "FAILED");
        storedProcedureQuery.execute();

        audit(username, detail, storedProcName, process);

    }
}
