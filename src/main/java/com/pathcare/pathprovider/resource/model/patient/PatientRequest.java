package com.pathcare.pathprovider.resource.model.patient;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;


public class PatientRequest {

    @JsonProperty("providerId")
    private Integer providerId;

    @JsonProperty("doctorMnemonic")
    private String doctorMnemonic;

    @JsonProperty("providerList")
    private String providerList;

    @JsonProperty("patientFirstName")
    private String patientFirstName;

    @JsonProperty("patientSurname")
    private String patientSurname;

    @JsonProperty("patientID")
    private String patientID;

    @JsonProperty("patientDOB")
    private String patientDOB;

    @JsonProperty("requisitionNumber")
    private String requisitionNumber;

    @JsonProperty("profileList")
    private String profileList;

    @JsonProperty("department")
    private String department;

    @JsonProperty("startDate")
    private Date startDate;

    @JsonProperty("endDate")
    private Date endDate;


    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public String getDoctorMnemonic() {
        return doctorMnemonic;
    }

    public void setDoctorMnemonic(String doctorMnemonic) {
        this.doctorMnemonic = doctorMnemonic;
    }

    public String getProviderList() {
        return providerList;
    }

    public void setProviderList(String providerList) {
        this.providerList = providerList;
    }

    public String getPatientFirstName() {
        return patientFirstName;
    }

    public void setPatientFirstName(String patientFirstName) {
        this.patientFirstName = patientFirstName;
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

    public String getRequisitionNumber() {
        return requisitionNumber;
    }

    public void setRequisitionNumber(String requisitionNumber) {
        this.requisitionNumber = requisitionNumber;
    }

    public String getProfileList() {
        return profileList;
    }

    public void setProfileList(String profileList) {
        this.profileList = profileList;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

}
