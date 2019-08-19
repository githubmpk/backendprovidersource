package com.pathcare.pathprovider.resource.model.specimen;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class SpecimenRequest {

        @JsonProperty("providerId")
        private Integer providerId;

        @JsonProperty("searchRequisition")
        private String searchRequisition;

        @JsonProperty("patientId")
        private Long patientId;

        @JsonProperty("department")
        private String department;

       @JsonProperty("profileList")
        private String profileList;

        @JsonProperty("startDate")
        private Date startDate;

        @JsonProperty("endDate")
        private Date endDate;

        @JsonProperty("viewedStatus")
        private Integer viewedStatus;

        @JsonProperty("doctorMnemonic")
        private String doctorMnemonic;

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public String getSearchRequisition() {
        return searchRequisition;
    }

    public void setSearchRequisition(String searchRequisition) {
        this.searchRequisition = searchRequisition;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getProfileList() {
        return profileList;
    }

    public void setProfileList(String profileList) {
        this.profileList = profileList;
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

    public Integer getViewedStatus() {
        return viewedStatus;
    }

    public void setViewedStatus(Integer viewedStatus) {
        this.viewedStatus = viewedStatus;
    }

    public String getDoctorMnemonic() {
        return doctorMnemonic;
    }

    public void setDoctorMnemonic(String doctorMnemonic) {
        this.doctorMnemonic = doctorMnemonic;
    }
}
