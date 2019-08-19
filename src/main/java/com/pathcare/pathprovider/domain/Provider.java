package com.pathcare.pathprovider.domain;

import javax.persistence.*;

@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "spProvider",
                procedureName = "spRPProviderSelect",
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "Search", type = String.class)
                        }  ,
                resultSetMappings = "providerMapping")
})

@SqlResultSetMapping(name="providerMapping", entities = @EntityResult(entityClass = Provider.class, fields = {
        @FieldResult(name = "id", column = "id"),
        @FieldResult(name = "surname", column = "vchsurname"),
        @FieldResult(name = "name", column = "doctorName"),
        @FieldResult(name = "mnemonic", column = "doctorMnemonic"),
        @FieldResult(name = "active", column = "chActive")
}))

public class Provider {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name="surname")
    private String surname;

    @Column(name="name")
    private String name;

    @Column(name="mnemonic")
    private String mnemonic;

    @Column(name="active")
    private String active;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
}
