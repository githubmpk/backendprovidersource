package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Provider;

public class ProviderModel {

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getMnemonic() {
        return mnemonic;
    }

    public void setMnemonic(String mnemonic) {
        this.mnemonic = mnemonic;
    }

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    @JsonProperty("id")
    private Long id;

    @JsonProperty("name")
    private String name;

    @JsonProperty("surname")
    private String surname;

    @JsonProperty("mnemonic")
    private String mnemonic;

    @JsonProperty("active")
    private String active;

    public ProviderModel(Provider provider) {
        this.name = provider.getName();
        this.id=provider.getId();
        this.active=provider.getActive();
        this.mnemonic=provider.getMnemonic();
        this.surname=provider.getSurname();
    }
}
