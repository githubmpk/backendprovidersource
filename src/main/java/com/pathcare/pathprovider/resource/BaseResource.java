package com.pathcare.pathprovider.resource;

import org.keycloak.KeycloakPrincipal;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public abstract class BaseResource {


    protected String findPrincipalName() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return ((KeycloakPrincipal) authentication.getPrincipal()).getName();
    }
}
