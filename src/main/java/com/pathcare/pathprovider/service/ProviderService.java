package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.ProviderDao;
import com.pathcare.pathprovider.domain.Provider;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ProviderService {


    @Autowired
    private ProviderDao providerDao;


    /**
     * List of providers based on DR mnemonic value
     *
     * @param name - DR value
     * @return -object provider
     */
    public List<Provider> returnProviders(String username, String name) {
        return providerDao.findAll(username, name, "AUD: Get Providers list");
    }
}