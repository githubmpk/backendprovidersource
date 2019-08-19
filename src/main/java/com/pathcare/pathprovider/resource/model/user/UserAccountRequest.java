package com.pathcare.pathprovider.resource.model.user;

import com.fasterxml.jackson.annotation.JsonProperty;

public class UserAccountRequest {

    @JsonProperty("username")
    private String username;

    @JsonProperty("password")
    private String password;

    public String getUserName() {
        return username;
    }

    public void setUserName(String userName) {
        this.username = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
