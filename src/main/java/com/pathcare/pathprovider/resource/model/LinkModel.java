package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.InternalUser;
import com.pathcare.pathprovider.domain.TrustedLink;
import java.util.Date;

public class LinkModel {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("linkName")
    private String linkName;

    @JsonProperty("linkValue")
    private String linkValue;

    @JsonProperty("selected")
    private Boolean selected;

    public LinkModel(TrustedLink trustedLink) {
        this.id = trustedLink.getId();
        this.linkName = trustedLink.getLinkName();
        this.linkValue = trustedLink.getLinkValue();
        this.selected = trustedLink.getSelected();
    }
}
