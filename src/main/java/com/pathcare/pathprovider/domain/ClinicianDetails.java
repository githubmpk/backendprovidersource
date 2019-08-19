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
import javax.persistence.StoredProcedureParameter;


@Entity
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(name = "spRegistrationDetail",
        procedureName = "spRPRegistrationDetailGet",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "vchSearch", type = String.class)
        }  ,
        resultSetMappings = "registrationMapping")
})

@SqlResultSetMapping(name="registrationMapping", entities = @EntityResult(entityClass = ClinicianDetails.class, fields = {
    @FieldResult(name = "id", column = "id"),
    @FieldResult(name = "mPNumber", column = "mPNumber"),
    @FieldResult(name = "firstname", column = "firstname"),
    @FieldResult(name = "surname", column = "surname"),
    @FieldResult(name = "doctorMnemonic", column = "doctorMnemonic"),
    @FieldResult(name = "email", column = "email"),
    @FieldResult(name = "phoneWork", column = "phoneWork"),
    @FieldResult(name = "phoneMobile", column = "phoneMobile"),
    @FieldResult(name = "ramsNo", column = "ramsNo"),
    @FieldResult(name = "practice", column = "practice"),
    @FieldResult(name = "providerId", column = "providerId"),
    @FieldResult(name = "rsId", column = "RsId"),
    @FieldResult(name = "inId", column = "InId"),
    @FieldResult(name = "dtId", column = "DtId"),
    @FieldResult(name = "kcUser", column = "kcUser"),
}))
public class ClinicianDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private String id;

    @Column(name="mPNumber")
    private String mPNumber;

    @Column(name="firstname")
    private String firstname;

    @Column(name="surname")
    private String surname;

    @Column(name="doctorMnemonic")
    private String doctorMnemonic;

    @Column(name="email")
    private String email;

    @Column(name="phoneWork")
    private String phoneWork;

    @Column(name="phoneMobile")
    private String phoneMobile;

    @Column(name="ramsNo")
    private String ramsNo;

    @Column(name="practice")
    private String practice;

    @Column(name="providerId")
    private String providerId;

    @Column(name="rsId")
    private Long rsId;

    @Column(name="inId")
    private Long inId;

    @Column(name="dtId")
    private Long dtId;

    @Column(name="kcUser")
    private String kcUser;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getmPNumber() {
        return mPNumber;
    }

    public void setmPNumber(String mPNumber) {
        this.mPNumber = mPNumber;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getDoctorMnemonic() {
        return doctorMnemonic;
    }

    public void setDoctorMnemonic(String doctorMnemonic) {
        this.doctorMnemonic = doctorMnemonic;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneWork() {
        return phoneWork;
    }

    public void setPhoneWork(String phoneWork) {
        this.phoneWork = phoneWork;
    }

    public String getPhoneMobile() {
        return phoneMobile;
    }

    public void setPhoneMobile(String phoneMobile) {
        this.phoneMobile = phoneMobile;
    }

    public String getRamsNo() {
        return ramsNo;
    }

    public void setRamsNo(String ramsNo) {
        this.ramsNo = ramsNo;
    }

    public String getPractice() {
        return practice;
    }

    public void setPractice(String practice) {
        this.practice = practice;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public Long getRsId() {
        return rsId;
    }

    public void setRsId(Long rsId) {
        this.rsId = rsId;
    }

    public Long getInId() {
        return inId;
    }

    public void setInId(Long inId) {
        this.inId = inId;
    }

    public Long getDtId() {
        return dtId;
    }

    public void setDtId(Long dtId) {
        this.dtId = dtId;
    }

    public String getKcUser() {
        return kcUser;
    }

    public void setKcUser(String kcUser) {
        this.kcUser = kcUser;
    }

}
