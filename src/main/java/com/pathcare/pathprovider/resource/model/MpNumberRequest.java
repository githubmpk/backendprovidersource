package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MpNumberRequest {

    @JsonProperty("mpNo")
    private String mpNo;

    public String getMpNo() {
        return mpNo;
    }

    public void setMpNo(String mpNo) {
        this.mpNo = mpNo;
    }
}
