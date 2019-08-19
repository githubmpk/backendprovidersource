package com.pathcare.pathprovider.domain;

import javax.persistence.*;

@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "spProfiles",
                procedureName = "spRPProfileList",
                resultSetMappings = "profileMapping")
})

@SqlResultSetMapping(name="profileMapping", entities = @EntityResult(entityClass = Profile.class, fields = {
        @FieldResult(name = "id", column = "id"),
        @FieldResult(name = "code", column = "code"),
        @FieldResult(name = "name", column = "name")
}))

public class Profile {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name="code")
    private String code;

    @Column(name="name")
    private String name;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
