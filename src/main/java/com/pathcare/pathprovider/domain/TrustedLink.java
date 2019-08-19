package com.pathcare.pathprovider.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityResult;
import javax.persistence.FieldResult;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.SqlResultSetMapping;
import javax.persistence.SqlResultSetMappings;
import javax.persistence.StoredProcedureParameter;

/**
 * SP - Get, or reset and get, the trusted links
 */
@Entity
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(name = "spFindLinks",
        procedureName = "spRpUserLinks",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchId", type = String.class),
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "bReset", type = Boolean.class)
        },
        resultSetMappings = "linksMapping"
    )
})
@SqlResultSetMappings({
    @SqlResultSetMapping(name = "linksMapping", entities = @EntityResult(entityClass = TrustedLink.class, fields = {
        @FieldResult(name = "id", column = "id"),
        @FieldResult(name = "linkName", column = "LinkName"),
        @FieldResult(name = "linkValue", column = "LinkValue"),
        @FieldResult(name = "selected", column = "Selected")
    }))
})
public class TrustedLink {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "linkName")
    private String linkName;

    @Column(name = "linkValue")
    private String linkValue;

    @Column(name = "selected")
    private Boolean selected;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLinkName() {
        return linkName;
    }

    public void setLinkName(String linkName) {
        this.linkName = linkName;
    }

    public String getLinkValue() {
        return linkValue;
    }

    public void setLinkValue(String linkValue) {
        this.linkValue = linkValue;
    }

    public Boolean getSelected() {
        return selected;
    }

    public void setSelected(Boolean selected) {
        this.selected = selected;
    }
}
