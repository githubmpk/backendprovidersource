package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ResultLabRequest {

    @JsonProperty("patientId")
    private Integer patientId;

    @JsonProperty("requisitionId")
    private Integer requisitionId;

    @JsonProperty("specimenId")
    private Integer specimenId;

    @JsonProperty("drMnemonic")
    private String drMnemonic;

    @JsonProperty("language")
    private String language;

    public Integer getPatientId() {
        return patientId;
    }

    public void setPatientId(Integer patientId) {
        this.patientId = patientId;
    }

    public Integer getRequisitionId() {
        return requisitionId;
    }

    public void setRequisitionId(Integer requisitionId) {
        this.requisitionId = requisitionId;
    }

    public Integer getSpecimenId() {
        return specimenId;
    }

    public void setSpecimenId(Integer specimenId) {
        this.specimenId = specimenId;
    }

    public String getDrMnemonic() {
        return drMnemonic;
    }

    public void setDrMnemonic(String drMnemonic) {
        this.drMnemonic = drMnemonic;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }
}
