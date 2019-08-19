package com.pathcare.pathprovider.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Department;

public class DepartmentModel {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("name")
    private String name;

    @JsonProperty("code")
    private String code;



    public DepartmentModel(Department department) {
        this.name = department.getName();
        this.id=department.getId();
        this.code = department.getCode();
    }
}
