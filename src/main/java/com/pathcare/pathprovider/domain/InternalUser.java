package com.pathcare.pathprovider.domain;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityResult;
import javax.persistence.FieldResult;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.SqlResultSetMapping;
import javax.persistence.SqlResultSetMappings;
import javax.persistence.StoredProcedureParameter;

/**
 * SP - Update and return internal user details
 */
@Entity
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(name = "spUserUpdate",
        procedureName = "spRpUserUpdate",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchId", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchCallType", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biRsId", type = Long.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biInId", type = Long.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biDtId", type = Long.class),
        },
        resultSetMappings = "userMapping"
    ),
    @NamedStoredProcedureQuery(name = "spUserFind",
        procedureName = "spRpUserUpdate",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchId", type = String.class)
        },
        resultSetMappings = "userMapping"
    )
})

@SqlResultSetMappings({
    @SqlResultSetMapping(name = "userMapping", entities = @EntityResult(entityClass = InternalUser.class, fields = {
        @FieldResult(name = "id", column = "vchId"),
        @FieldResult(name = "doctorMnemonic", column = "vchDoctorMnemonic"),
        @FieldResult(name = "mpNumber", column = "vchMPNumber"),
        @FieldResult(name = "rams", column = "vch7RAMS"),
        @FieldResult(name = "rsId", column = "biRsId"),
        @FieldResult(name = "dtId", column = "biDtId"),
        @FieldResult(name = "inId", column = "biInId"),
        @FieldResult(name = "name", column = "Name"),
        @FieldResult(name = "prefId", column = "Pref_iId"),
        @FieldResult(name = "testProfile", column = "vchTestProfile"),
        @FieldResult(name = "userLanguage", column = "chUserLanguage"),
        @FieldResult(name = "viewPeriod", column = "iViewPeriod"),
        @FieldResult(name = "viewStatus", column = "vchViewStatus"),
        @FieldResult(name = "reportLayout", column = "chReportLayout"),
        @FieldResult(name = "cumulativeDirection", column = "bCumulativeDirection"),
        @FieldResult(name = "prefCreated", column = "Pref_dtCreated"),
        @FieldResult(name = "prefModified", column = "Pref_dtModified")
    }))
})

public class InternalUser {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private String id;

    @Column(name = "doctorMnemonic")
    private String doctorMnemonic;

    @Column(name = "mpNumber")
    private String mpNumber;

    @Column(name = "rams")
    private String rams;

    @Column(name = "rsId")
    private Long rsId;

    @Column(name = "dtId")
    private Long dtId;

    @Column(name = "inId")
    private Long inId;

    @Column(name = "name")
    private String name;

    @Column(name = "prefId")
    private Integer prefId;

    @Column(name = "testProfile")
    private String testProfile;

    @Column(name = "userLanguage")
    private String userLanguage;

    @Column(name = "viewPeriod")
    private Integer viewPeriod;

    @Column(name = "viewStatus")
    private String viewStatus;

    @Column(name = "reportLayout")
    private String reportLayout;

    @Column(name = "cumulativeDirection")
    private Boolean cumulativeDirection;

    @Column(name = "prefCreated")
    private Date prefCreated;

    @Column(name = "prefModified")
    private Date prefModified;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDoctorMnemonic() {
        return doctorMnemonic;
    }

    public void setDoctorMnemonic(String doctorMnemonic) {
        this.doctorMnemonic = doctorMnemonic;
    }

    public String getMpNumber() {
        return mpNumber;
    }

    public void setMpNumber(String mpNumber) {
        this.mpNumber = mpNumber;
    }

    public String getRams() {
        return rams;
    }

    public void setRams(String rams) {
        this.rams = rams;
    }

    public Long getRsId() {
        return rsId;
    }

    public void setRsId(Long rsId) {
        this.rsId = rsId;
    }

    public Long getDtId() {
        return dtId;
    }

    public void setDtId(Long dtId) {
        this.dtId = dtId;
    }

    public Long getInId() {
        return inId;
    }

    public void setInId(Long inId) {
        this.inId = inId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPrefId() {
        return prefId;
    }

    public void setPrefId(Integer prefId) {
        this.prefId = prefId;
    }

    public String getTestProfile() {
        return testProfile;
    }

    public void setTestProfile(String testProfile) {
        this.testProfile = testProfile;
    }

    public String getUserLanguage() {
        return userLanguage;
    }

    public void setUserLanguage(String userLanguage) {
        this.userLanguage = userLanguage;
    }

    public Integer getViewPeriod() {
        return viewPeriod;
    }

    public void setViewPeriod(Integer viewPeriod) {
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

    public Boolean getCumulativeDirection() {
        return cumulativeDirection;
    }

    public void setCumulativeDirection(Boolean cumulativeDirection) {
        this.cumulativeDirection = cumulativeDirection;
    }

    public Date getPrefCreated() {
        return prefCreated;
    }

    public void setPrefCreated(Date prefCreated) {
        this.prefCreated = prefCreated;
    }

    public Date getPrefModified() {
        return prefModified;
    }

    public void setPrefModified(Date prefModified) {
        this.prefModified = prefModified;
    }
}
