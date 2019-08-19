package com.pathcare.pathprovider.domain;

import javax.persistence.*;
import java.util.Date;

@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "spSpecimenList",
                procedureName = "spRPSpecimenList",
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "providerId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "doctorMnemonic",type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "searchRequisition",type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "patientId", type = Long.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "department", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "profileList", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "startDate", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "endDate", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "viewedStatus", type = Integer.class),
                }  ,
                resultSetMappings = "RequisitionMapping")
})

@SqlResultSetMapping(name="RequisitionMapping", entities = @EntityResult(entityClass = Specimen.class, fields = {
        @FieldResult(name = "id", column = "specimenId"),
        @FieldResult(name = "collectionDate", column = "collectionDate"),
        @FieldResult(name = "requisitionNo", column = "requisitionNo"),
        @FieldResult(name = "patientId", column = "patientId"),
        @FieldResult(name = "reqViewed", column = "reqViewed"),
        @FieldResult(name = "disciplineType", column = "disciplineType"),
        @FieldResult(name = "requisitionId", column = "requisitionId"),
        @FieldResult(name = "specimenId", column = "specimenId"),
        @FieldResult(name = "specimenNumber", column = "specimenNumber"),
        @FieldResult(name = "department", column = "department"),
        @FieldResult(name = "abbreviationEng", column = "abbreviationEng"),
        @FieldResult(name = "backGroundColor", column = "backGroundColor"),
        @FieldResult(name = "foreGroundColor", column = "foreGroundColor"),
}))
public class Specimen {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "collectionDate")
    private Date collectionDate;

    @Column(name = "requisitionNo")
    private String requisitionNo;

    @Column(name = "patientId")
    private Long patientId;

    @Column(name = "reqViewed")
    private Integer reqViewed;

    @Column(name = "disciplineType")
    private String disciplineType;

    @Column(name = "requisitionId")
    private Long requisitionId;

    @Column(name = "specimenId")
    private Long specimenId;

    @Column(name = "specimenNumber")
    private String specimenNumber;

    @Column(name = "department")
    private String department;

    @Column(name = "abbreviationEng")
    private String abbreviationEng;

    @Column(name = "backGroundColor")
    private String backGroundColor;

    @Column(name = "foreGroundColor")
    private String foreGroundColor;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCollectionDate() {
        return collectionDate;
    }

    public void setCollectionDate(Date collectionDate) {
        this.collectionDate = collectionDate;
    }

    public String getRequisitionNo() {
        return requisitionNo;
    }

    public void setRequisitionNo(String requisitionNo) {
        this.requisitionNo = requisitionNo;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public Integer getReqViewed() {
        return reqViewed;
    }

    public void setReqViewed(Integer reqViewed) {
        this.reqViewed = reqViewed;
    }

    public String getDisciplineType() {
        return disciplineType;
    }

    public void setDisciplineType(String disciplineType) {
        this.disciplineType = disciplineType;
    }

    public Long getRequisitionId() {
        return requisitionId;
    }

    public void setRequisitionId(Long requisitionId) {
        this.requisitionId = requisitionId;
    }

    public Long getSpecimenId() {
        return specimenId;
    }

    public void setSpecimenId(Long specimenId) {
        this.specimenId = specimenId;
    }

    public String getSpecimenNumber() {
        return specimenNumber;
    }

    public void setSpecimenNumber(String specimenNumber) {
        this.specimenNumber = specimenNumber;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAbbreviationEng() {
        return abbreviationEng;
    }

    public void setAbbreviationEng(String abbreviationEng) {
        this.abbreviationEng = abbreviationEng;
    }

    public String getBackGroundColor() {
        return backGroundColor;
    }

    public void setBackGroundColor(String backGroundColor) {
        this.backGroundColor = backGroundColor;
    }

    public String getForeGroundColor() {
        return foreGroundColor;
    }

    public void setForeGroundColor(String foreGroundColor) {
        this.foreGroundColor = foreGroundColor;
    }
}
