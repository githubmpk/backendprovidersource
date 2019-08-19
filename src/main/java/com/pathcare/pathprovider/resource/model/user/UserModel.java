package com.pathcare.pathprovider.resource.model.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.InternalUser;
import java.util.Date;

public class UserModel {

    @JsonProperty("rams")
    private String rams;

    @JsonProperty("doctorMnemonic")
    private String doctorMnemonic;

    @JsonProperty("mpNumber")
    private String mpNumber;

    @JsonProperty("rsId")
    private Long rsId;

    @JsonProperty("dtId")
    private Long dtId;

    @JsonProperty("inId")
    private Long inId;

    @JsonProperty("name")
    private String name;

    @JsonProperty("prefId")
    private Integer prefId;

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
    private Boolean cumulativeDirection;

    @JsonProperty("prefCreated")
    private Date prefCreated;

    @JsonProperty("prefModified")
    private Date prefModified;

    public UserModel(InternalUser internalUser) {
        this.rams = internalUser.getRams();
        this.doctorMnemonic = internalUser.getDoctorMnemonic();
        this.mpNumber = internalUser.getMpNumber();
        this.rsId = internalUser.getRsId();
        this.dtId = internalUser.getDtId();
        this.inId = internalUser.getInId();
        this.name = internalUser.getName();
        this.prefId = internalUser.getPrefId();
        this.testProfile = internalUser.getTestProfile();
        this.userLanguage = internalUser.getUserLanguage();
        this.viewPeriod = internalUser.getViewPeriod();
        this.viewStatus = internalUser.getViewStatus();
        this.reportLayout = internalUser.getReportLayout();
        this.cumulativeDirection = internalUser.getCumulativeDirection();
        this.prefCreated = internalUser.getPrefCreated();
        this.prefModified = internalUser.getPrefModified();
    }
}
