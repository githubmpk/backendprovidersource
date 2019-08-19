package com.pathcare.pathprovider.resource.model.preference;

import com.fasterxml.jackson.annotation.JsonProperty;

public class PreferenceRequest {

    @JsonProperty("userID")
    private String userID;

    @JsonProperty("testProfile")
    private String testProfile;

    @JsonProperty("userLanguage")
    private String userLanguage;

    @JsonProperty("viewPeriod")
    private Integer viewPeriod;

    @JsonProperty("viewStatus")
    private String viewStatus;

    @JsonProperty("reportLayout")
    private String reportLayout;

    @JsonProperty("cumulativeDirection")
    private Integer cumulativeDirection;

    @JsonProperty("created")
    private String created;

    @JsonProperty("modified")
    private String modified;

    public String getTestProfile() {return testProfile;}

    public void setTestProfile(String testProfile) {this.testProfile = testProfile;}

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserLanguage() { return userLanguage;}

    public void setUserLanguage(String userLanguage) {this.userLanguage = userLanguage;}

    public Integer getViewPeriod() {return viewPeriod;}

    public void setViewPeriod(Integer viewPeriod) {this.viewPeriod = viewPeriod;}

    public String getViewStatus() {return viewStatus;}

    public void setViewStatus(String viewStatus) {this.viewStatus = viewStatus;}

    public String getReportLayout() {return reportLayout;}

    public void setReportLayout(String reportLayout) {this.reportLayout = reportLayout;}

    public Integer getCumulativeDirection() {return cumulativeDirection;}

    public void setCumulativeDirection(Integer cumulativeDirection) {this.cumulativeDirection = cumulativeDirection;}

    public String getCreated() {return created;}

    public void setCreated(String created) {this.created = created;}

    public String getModified() {return modified;}

    public void setModified(String modified) {this.modified = modified;}
}

