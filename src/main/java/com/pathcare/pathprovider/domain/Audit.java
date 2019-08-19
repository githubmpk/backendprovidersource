package com.pathcare.pathprovider.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;

/**
 * Setup SP and its paramaters
 * identifier for the table 'id'
 */
@Entity
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(name = "spAudit",
        procedureName = "spRPAuditAdd",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchApplication", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchDetail", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchIPAddress", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biPatientId", type = Integer.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchProcess", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchUsername", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biSpecimenId", type = Integer.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchStoredProc", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "biRequisitionId", type = Integer.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchBrowser", type = String.class)
        })
})
public class Audit {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name="vchApplication")
    private String application;

    @Column(name="vchDetail")
    private String detail;

    @Column(name="vchIPAddress")
    private String ipAddress;

    @Column(name="biPatientId")
    private Integer patiendID;

    @Column(name="vchProcess")
    private String process;

    @Column(name="vchUsername")
    private String userName;

    @Column(name="biRequisitionId")
    private Integer requstionID;

    @Column(name="biSpecimenId")
    private Integer specimenID;

    @Column(name="vchStoredProc")
    private String storedProc;

    @Column(name="vchBrowser")
    private String browser;


    public Audit(String username, String ipAddress, String storedProcName, String detail,
        String process, Integer patID, Integer reqID, Integer specimenID, String browser) {
        this.application = "PP3"; //TODO change if needed to pathprovider 3
        this.detail = detail;
        this.ipAddress = ipAddress;
        this.patiendID = patID;
        this.process = process;
        this.userName = username;
        this.requstionID = reqID; //get from parameter
        this.specimenID = specimenID; //get from parameter
        this.storedProc = storedProcName; //get from parameter
        this.browser = browser;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getApplication() {
        return application;
    }

    public void setApplication(String application) {
        this.application = application;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Integer getPatiendID() {
        return patiendID;
    }

    public void setPatiendID(Integer patiendID) {
        this.patiendID = patiendID;
    }

    public String getProcess() {
        return process;
    }

    public void setProcess(String process) {
        this.process = process;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getRequstionID() {
        return requstionID;
    }

    public void setRequstionID(Integer requstionID) {
        this.requstionID = requstionID;
    }

    public Integer getSpecimenID() {
        return specimenID;
    }

    public void setSpecimenID(Integer specimenID) {
        this.specimenID = specimenID;
    }

    public String getStoredProc() {
        return storedProc;
    }

    public void setStoredProc(String storedProc) {
        this.storedProc = storedProc;
    }

    public String getBrowser() {
        return browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }
}
