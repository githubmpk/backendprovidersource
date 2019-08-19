package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Profile;


public class ProfileModel {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("name")
    private String name;

    @JsonProperty("code")
    private String code;



    public ProfileModel(Profile profile) {
        this.name = profile.getName();
        this.id=profile.getId();
        this.code = profile.getCode();
    }
}
