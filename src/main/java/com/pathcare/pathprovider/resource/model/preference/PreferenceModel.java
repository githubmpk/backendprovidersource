package com.pathcare.pathprovider.resource.model.preference;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Preference;

public class PreferenceModel {

    @JsonProperty("id")
    private Long id;

    @JsonProperty ("userID")
    private String userID;

    @JsonProperty ("testProfile")
    private String testProfile;

    @JsonProperty("userLanguage")
    private String userLanguage;

    @JsonProperty("viewPeriod")
    private String viewPeriod;

    @JsonProperty("viewStatus")
    private String viewStatus;

    @JsonProperty("reportLayout")
    private String reportLayout;

    @JsonProperty("cumulativeDirection")
    private String cumulativeDirection;

    @JsonProperty("created")
    private String created;

    @JsonProperty("modified")
    private String modified;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
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

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public String getModified() {
        return modified;
    }

    public void setModified(String modified) {
        this.modified = modified;
    }

    public PreferenceModel(Preference preferenceList){
        this.userID = preferenceList.getUserID();
        this.userLanguage = preferenceList.getUserLanguage();
        this.viewPeriod = preferenceList.getViewPeriod();
        this.viewStatus = preferenceList.getViewStatus();
        this.reportLayout = preferenceList.getReportLayout();
        this.cumulativeDirection = preferenceList.getCumulativeDirection();
        this.created = preferenceList.getCreatedDate();
        this.modified = preferenceList.getModifiedDate();
    }
}
