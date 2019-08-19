package com.pathcare.pathprovider.resource.model.patient;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Patient;

public class PatientModel {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("rowCount")
    private String rowCount;

    @JsonProperty("patientName")
    private String patFirstName;

    @JsonProperty("patientSurname")
    private String patientSurname;

    @JsonProperty("patientID")
    private String patientID;

    @JsonProperty("patientDOB")
    private String patientDOB;

    @JsonProperty("patientGender")
    private String patientGender;

    @JsonProperty("patientIDNo")
    private String patientIDNo;

    @JsonProperty("patientParentId")
    private String patientParentId;

    @JsonProperty("patientFirstName")
    private String patientFirstName;



    @JsonProperty("iLink")
    private String iLink;



    public PatientModel(Patient patientList) {
        this.id = patientList.getId();
        this.rowCount = patientList.getRowCount();
        this.patientFirstName = patientList.getPatientFirstName();
        this.patientSurname = patientList.getPatientSurname();
        this.patientID = patientList.getPatientID();
        this.patientDOB = patientList.getPatientDOB();
        this.patientGender = patientList.getPatientGender();
        this.patientIDNo = patientList.getPatientIDNo();
        this.patientParentId = patientList.getPatientParentId();
        this.patFirstName = patientList.getPatientName();
        this.iLink = patientList.getiLink();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRowCount() {
        return rowCount;
    }

    public void setRowCount(String rowCount) {
        this.rowCount = rowCount;
    }

    public String getPatFirstName() {
        return patFirstName;
    }

    public void setPatFirstName(String patFirstName) {
        this.patFirstName = patFirstName;
    }

    public String getPatientSurname() {
        return patientSurname;
    }

    public void setPatientSurname(String patientSurname) {
        this.patientSurname = patientSurname;
    }

    public String getPatientID() {
        return patientID;
    }

    public void setPatientID(String patientID) {
        this.patientID = patientID;
    }

    public String getPatientDOB() {
        return patientDOB;
    }

    public void setPatientDOB(String patientDOB) {
        this.patientDOB = patientDOB;
    }

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }

    public String getPatientIDNo() {
        return patientIDNo;
    }

    public void setPatientIDNo(String patientIDNo) {
        this.patientIDNo = patientIDNo;
    }

    public String getPatientParentId() {
        return patientParentId;
    }

    public void setPatientParentId(String patientParentId) {
        this.patientParentId = patientParentId;
    }

    public String getPatientFirstName() {
        return patientFirstName;
    }

    public void setPatientFirstName(String patientFirstName) {
        this.patientFirstName = patientFirstName;
    }

    public String getiLink() {
        return iLink;
    }

    public void setiLink(String iLink) {
        this.iLink = iLink;
    }
}
