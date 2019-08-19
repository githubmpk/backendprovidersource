
package com.pathcare.pathprovider.dao;

import com.pathcare.pathprovider.domain.Preference;
import com.pathcare.pathprovider.resource.model.preference.PreferenceRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.persistence.StoredProcedureQuery;
import java.util.List;


@Component
public class PreferenceDao extends BaseAuditDao {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    public PreferenceDao(AuditDao auditDao) {
        super(auditDao);
    }

    public Preference getPreference(PreferenceRequest preferenceRequest, String username, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager.createNamedStoredProcedureQuery("spPreferences");
        storedProcedureQuery.setParameter("user_id", preferenceRequest.getUserID());

        storedProcedureQuery.execute();
        // List resultList = storedProcedureQuery.getResultList();

        String userID = preferenceRequest.getUserID();

        //audit(username, detail, "spRPUserPreferenceGet", "getUserPreferences", 0, userID, 0 );

        List<Preference> preferenceList = storedProcedureQuery.getResultList();
        Preference preference = null;
        if (!preferenceList.isEmpty()) {
            preference = preferenceList.get(0);
        }
        return preference;
    }

    public Boolean setPreference(PreferenceRequest preferenceRequest, String userName, String detail) {
        StoredProcedureQuery storedProcedureQuery = this.entityManager
            .createNamedStoredProcedureQuery("spPreferencesUpdate");
        storedProcedureQuery.setParameter("user_id", preferenceRequest.getUserID());
        storedProcedureQuery.setParameter("userLanguage", preferenceRequest.getUserLanguage());
        storedProcedureQuery.setParameter("viewPeriod", preferenceRequest.getViewPeriod());
        storedProcedureQuery.setParameter("viewStatus", preferenceRequest.getViewStatus());
        storedProcedureQuery.setParameter("reportLayout", preferenceRequest.getReportLayout());
        storedProcedureQuery.setParameter("cumulativeDirection", preferenceRequest.getCumulativeDirection());
        storedProcedureQuery.setParameter("testProfile", preferenceRequest.getTestProfile());

        return storedProcedureQuery.execute();

    }
}

