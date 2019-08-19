package com.pathcare.pathprovider.domain;

import javax.persistence.*;

/**
 * Sp - SP reporting portal provider List
 */
@Entity
@NamedStoredProcedureQueries({


    @NamedStoredProcedureQuery(name = "spPreferencesUpdate",
        procedureName = "spRPUserPreferenceInsert",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "user_id", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "userLanguage", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "viewPeriod", type = Integer.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "viewStatus", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "reportLayout", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "cumulativeDirection", type = Integer.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "testProfile", type = String.class)
        }
        ),

    @NamedStoredProcedureQuery(name = "spPreferences",
        procedureName = "spRPUserPreferenceGet",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "user_id", type = String.class)
        },
        resultSetMappings = "preferencesMapping")
}
)

@SqlResultSetMapping(name = "preferencesMapping", entities = @EntityResult(entityClass = Preference.class, fields = {
    @FieldResult(name = "userID", column = "iUser_id"),
    @FieldResult(name = "testProfile", column = "vchTestProfile"),
    @FieldResult(name = "userLanguage", column = "chUserLanguage"),
    @FieldResult(name = "viewPeriod", column = "iViewPeriod"),
    @FieldResult(name = "viewStatus", column = "vchViewStatus"),
    @FieldResult(name = "reportLayout", column = "chReportLayout"),
    @FieldResult(name = "cumulativeDirection", column = "bCumulativeDirection"),
    @FieldResult(name = "createdDate", column = "dtCreated"),
    @FieldResult(name = "modifiedDate", column = "dtModified"),
}))


public class Preference {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)

    @Column(name = "testProfile")
    private String testProfile;

    @Column(name = "userID")
    private String userID;

    @Column(name = "userLanguage")
    private String userLanguage;

    @Column(name = "viewPeriod")
    private String viewPeriod;


    @Column(name = "viewStatus")
    private String viewStatus;

    @Column(name = "reportLayout")
    private String reportLayout;

    @Column(name = "cumulativeDirection")
    private String cumulativeDirection;

    @Column(name = "createdDate")
    private String createdDate;

    @Column(name = "modifiedDate")
    private String modifiedDate;

    public String getTestProfile() {
        return testProfile;
    }

    public void setTestProfile(String testProfile) {
        this.testProfile = testProfile;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserLanguage() {
        return userLanguage;
    }

    public void setUserLanguage(String userLanguage) {
        this.userLanguage = userLanguage;
    }

    public String getViewPeriod() {
        return viewPeriod;
    }

    public void setViewPeriod(String viewPeriod) {
        this.viewPeriod = viewPeriod;
    }

    public String getViewStatus() {
        return viewStatus;
    }

    public void setViewStatus(String viewStatus) {
        this.viewStatus = viewStatus;
    }

    public String getReportLayout() {
        return reportLayout;
    }

    public void setReportLayout(String reportLayout) {
        this.reportLayout = reportLayout;
    }

    public String getCumulativeDirection() {
        return cumulativeDirection;
    }

    public void setCumulativeDirection(String cumulativeDirection) {
        this.cumulativeDirection = cumulativeDirection;
    }

    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }

    public String getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }
}

