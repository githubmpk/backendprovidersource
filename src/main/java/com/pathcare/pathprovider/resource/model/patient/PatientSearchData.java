package com.pathcare.pathprovider.resource.model.patient;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.resource.model.DepartmentModel;
import com.pathcare.pathprovider.resource.model.LinkModel;
import com.pathcare.pathprovider.resource.model.ProfileModel;
import com.pathcare.pathprovider.resource.model.user.UserModel;

import java.util.List;


public class PatientSearchData {
    @JsonProperty("profile")
    private List<ProfileModel> profile;

    @JsonProperty("department")
    private List<DepartmentModel> departmentModel;

    @JsonProperty("user")
    private List<UserModel> userModel;

    @JsonProperty("trustedLinks")
    private List<LinkModel> linkModels;

    public List<ProfileModel> getProfile() {
        return profile;
    }

    public void setProfile(List<ProfileModel> profile) {
        this.profile = profile;
    }

    public List<DepartmentModel> getDepartmentModel() {
        return departmentModel;
    }

    public void setDepartmentModel(
        List<DepartmentModel> departmentModel) {
        this.departmentModel = departmentModel;
    }

    public List<UserModel> getUserModel() {
        return userModel;
    }

    public void setUserModel(List<UserModel> userModel) {
        this.userModel = userModel;
    }

    public List<LinkModel> getLinkModels() {
        return linkModels;
    }

    public void setLinkModels(List<LinkModel> linkModels) {
        this.linkModels = linkModels;
    }
}
