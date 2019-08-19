package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class InternalUserRequest {

    @JsonProperty("username")
    private String username;

    @JsonProperty("firstname")
    private String firstname;

    @JsonProperty("surname")
    private String surname;

    @JsonProperty("email")
    private String email;

    @JsonProperty("phoneMobile")
    private String phoneMobile;

    @JsonProperty("rsId")
    private Long rsId;

    @JsonProperty("inId")
    private Long inId;

    @JsonProperty("dtId")
    private Long dtId;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneMobile() {
        return phoneMobile;
    }

    public void setPhoneMobile(String phoneMobile) {
        this.phoneMobile = phoneMobile;
    }

    public Long getRsId() {
        return rsId;
    }

    public void setRsId(Long rsId) {
        this.rsId = rsId;
    }

    public Long getInId() {
        return inId;
    }

    public void setInId(Long inId) {
        this.inId = inId;
    }

    public Long getDtId() {
        return dtId;
    }

    public void setDtId(Long dtId) {
        this.dtId = dtId;
    }
}
