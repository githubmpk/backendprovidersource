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

/**
 * Sp - SP Report Result Lab in html
 */
@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "spReportResultLab",
                procedureName = "spRpReportHtmlResultLab",
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "patientId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "requisitionId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "specimenId", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "drMnemonic", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "language", type = String.class),
                        },
                resultSetMappings = "labMapping")
})

@SqlResultSetMapping(name = "labMapping", entities = @EntityResult(entityClass = ResultLab.class, fields = {
        @FieldResult(name = "id", column = "id"),
        @FieldResult(name = "htmlTxt", column = "html")

}))

public class ResultLab {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "htmlTxt")
    private String htmlTxt;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getHtmlTxt() {
        return htmlTxt;
    }

    public void setHtmlTxt(String htmlTxt) {
        this.htmlTxt = htmlTxt;
    }

}

