package com.pathcare.pathprovider.domain;

import javax.persistence.*;

/**
 * Sp - SP reporting portal patient List
 */
@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "spPatientlist",
                procedureName = "spRPPatientListGet",
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "iProviderId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "doctorMnemonic", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchList", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchPatFirstName", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchPatSurname", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchPatID", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "dPatDOB", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchRequisitionNumber", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchProfileList", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchDepartment", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "dStart", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "dEnd", type = String.class),
                        },
                resultSetMappings = "patientMapping")
})

@SqlResultSetMapping(name = "patientMapping", entities = @EntityResult(entityClass = Patient.class, fields = {
        @FieldResult(name = "id", column = "iRowId"),
        @FieldResult(name = "rowCount", column = "TRowCount"),
        @FieldResult(name = "patientName", column = "vchPatName"),
        @FieldResult(name = "patientID", column = "biPatientId"),
        @FieldResult(name = "patientDOB", column = "dPatDOB"),
        @FieldResult(name = "patientGender", column = "chPatGender"),
        @FieldResult(name = "patientIDNo", column = "vchPatID"),
        @FieldResult(name = "patientSurname", column = "vchPatSurname"),
        @FieldResult(name = "patientParentId", column = "iPatientParentId"),
        @FieldResult(name = "patientFirstName", column = "vchPatFirstname"),
        @FieldResult(name = "iLink", column = "tiLink"),

}))

public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "rowCount")
    private String rowCount;

    @Column(name = "patientName")
    private String patientName;

    @Column(name = "patientSurname")
    private String patientSurname;

    @Column(name = "patientID")
    private String patientID;

    @Column(name = "patientDOB")
    private String patientDOB;

    @Column(name = "patientGender")
    private String patientGender;

    @Column(name = "patientIDNo")
    private String patientIDNo;

    @Column(name = "patientParentId")
    private String patientParentId;

    @Column(name = "patientFirstName")
    private String patientFirstName;

    @Column(name = "iLink")
    private String iLink;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRowCount() {
        return rowCount;
    }

    public void setRowCount(String rowCount) {
        this.rowCount = rowCount;
    }

    public String getPatientFirstName() {
        return patientFirstName;
    }

    public void setPatientFirstName(String patientFirstName) {
        this.patientFirstName = patientFirstName;
    }

    public String getPatientSurname() {
        return patientSurname;
    }

    public void setPatientSurname(String patientSurname) {
        this.patientSurname = patientSurname;
    }

    public String getPatientID() {
        return patientID;
    }

    public void setPatientID(String patientID) {
        this.patientID = patientID;
    }

    public String getPatientDOB() {
        return patientDOB;
    }

    public void setPatientDOB(String patientDOB) {
        this.patientDOB = patientDOB;
    }

    public String getPatientGender() {
        return patientGender;
    }

    public void setPatientGender(String patientGender) {
        this.patientGender = patientGender;
    }

    public String getPatientIDNo() {
        return patientIDNo;
    }

    public void setPatientIDNo(String patientIDNo) {
        this.patientIDNo = patientIDNo;
    }

    public String getPatientParentId() {
        return patientParentId;
    }

    public void setPatientParentId(String patientParentId) {
        this.patientParentId = patientParentId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }



    public String getiLink() {
        return iLink;
    }

    public void setiLink(String iLink) {
        this.iLink = iLink;
    }


}

