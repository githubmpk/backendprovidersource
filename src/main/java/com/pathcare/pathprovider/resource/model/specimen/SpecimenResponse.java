package com.pathcare.pathprovider.resource.model.specimen;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.pathcare.pathprovider.domain.Specimen;

import com.pathcare.pathprovider.util.DateConverters;

public class SpecimenResponse {

    @JsonProperty("id")
    private Long id;

    @JsonProperty("collectionDate")
    private String collectionDate;

    @JsonProperty("requisitionNo")
    private String requisitionNo;

    @JsonProperty("patientId")
    private Long patientId;

    @JsonProperty("reqViewed")
    private Integer reqViewed;

    @JsonProperty("disciplineType")
    private String disciplineType;

    @JsonProperty("requisitionId")
    private Long requisitionId;

    @JsonProperty("specimenId")
    private Long specimenId;

    @JsonProperty("specimenNumber")
    private String specimenNumber;

    @JsonProperty("department")
    private String department;

    @JsonProperty("abbreviationEng")
    private String abbreviationEng;

    @JsonProperty("backGroundColor")
    private String backGroundColor;

    @JsonProperty("foreGroundColor")
    private String foreGroundColor;

    public SpecimenResponse(Specimen specimen){
        this.id= specimen.getId();

        this.collectionDate = DateConverters.convertDateToDateTimeStringNoSecondFormat(specimen.getCollectionDate());
        this.requisitionId= specimen.getRequisitionId();
        this.requisitionNo= specimen.getRequisitionNo();
        this.department= specimen.getDepartment();
        this.disciplineType= specimen.getDisciplineType();
        this.patientId= specimen.getPatientId();
        this.reqViewed= specimen.getReqViewed();
        this.specimenId= specimen.getSpecimenId();
        this.specimenNumber= specimen.getSpecimenNumber();
        this.abbreviationEng=specimen.getAbbreviationEng();
        this.backGroundColor=specimen.getBackGroundColor();
        this.foreGroundColor=specimen.getForeGroundColor();
    }
}
