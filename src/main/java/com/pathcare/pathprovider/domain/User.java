package com.pathcare.pathprovider.domain;

//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import javax.xml.ws.http.HTTPException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

@Entity
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery( name = "spFindUserByEmployeeNo",
        procedureName = "spRPFindUserByEmployeeNo",
        parameters = {
            @StoredProcedureParameter(mode = ParameterMode.IN, name = "username", type = String.class)
        }  ,
        resultSetMappings = "loginMapping"),

        @NamedStoredProcedureQuery( name = "spRPUserLoginUpdate",
            procedureName = "spRPUserLoginUpdate",
            parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "username", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "loginStatus", type = String.class)
            } )
})

@SqlResultSetMapping(name="loginMapping", entities = @EntityResult(entityClass = User.class, fields = {
        @FieldResult(name = "id", column = "id"),
        @FieldResult(name = "name", column = "name"),
        @FieldResult(name = "userId", column = "user_id"),
        @FieldResult(name = "username", column = "username"),
        @FieldResult(name = "password", column = "password"),
        @FieldResult(name = "email", column = "email"),
        @FieldResult(name = "locked", column = "locked"),
        @FieldResult(name = "loginAttempts", column = "loginAttempts"),
        @FieldResult(name = "isActive", column = "isActive"),
        @FieldResult(name = "roles", column = "roles")
}))

//public class User implements UserDetails {
    public class User {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "userId")
    private String userId;

    @Column(name = "name")
    private String name;

    @Column(name = "username")
    private String username;

    @Column(name = "password")
    private String password;

    @Column(name = "email")
    private String email;

    @Column(name = "locked")
    private Boolean locked;

    @Column(name = "loginAttempts")
    private String loginAttempts;

    @Column(name = "isActive")
    private Boolean isActive;

    @Column(name = "roles")
    private String roles;

    @Transient
    private List<String> authorities;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getLocked() {
        return locked;
    }

    public void setLocked(Boolean locked) {
        this.locked = locked;
    }

    public String getLoginAttempts() {
        return loginAttempts;
    }

    public void setLoginAttempts(String loginAttempts) {
        this.loginAttempts = loginAttempts;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRoles() {
        return roles;
    }

    public void setRoles(String roles) {
        this.roles = roles;
    }

    public void setAuthorities(List<String> authorities) {
        this.authorities = authorities;
    }

//    @Override
//    public Collection<? extends GrantedAuthority> getAuthorities() {
//        if(authorities.get(0).isEmpty()){
//            return Collections.EMPTY_LIST;
//        }else {
//            return authorities.stream().map(r -> new SimpleGrantedAuthority(r)).collect(Collectors.toList());
//        }
//    }
//
//    @Override
//    public boolean isAccountNonExpired() {
//        return true;
//    }
//
//    @Override
//    public boolean isAccountNonLocked() {
//        return !locked;
//    }
//
//    @Override
//    public boolean isCredentialsNonExpired() {
//        return true;
//    }
//
//    @Override
//    public boolean isEnabled() {
//        return isActive;
//    }
}
