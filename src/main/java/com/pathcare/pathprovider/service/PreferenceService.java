package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.PreferenceDao;
import com.pathcare.pathprovider.domain.Preference;
import com.pathcare.pathprovider.resource.model.preference.PreferenceRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PreferenceService {

    @Autowired
    private PreferenceDao preferenceDao;

    /**
     * get user preferences from preferences table
     *
     * @param preferencesRequest - parameters from FE
     * @return - user preferences
     */
    public Preference returnUserPreferences(String username, PreferenceRequest preferencesRequest) {

        return preferenceDao.
            getPreference(preferencesRequest, username, "return user preferences");

    }

    public void setUserPreferences(String username, PreferenceRequest preferenceRequest) {

        preferenceDao.
            setPreference(preferenceRequest, username, "set user preferences");
    }

}

