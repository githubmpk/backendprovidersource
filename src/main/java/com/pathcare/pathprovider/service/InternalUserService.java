package com.pathcare.pathprovider.service;

import com.pathcare.pathprovider.dao.InternalUserDao;
import com.pathcare.pathprovider.domain.InternalUser;
import com.pathcare.pathprovider.domain.TrustedLink;
import com.pathcare.pathprovider.resource.model.InternalUserRequest;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class InternalUserService {

    @Autowired
    private InternalUserDao internalUserDao;

    public List<InternalUser> updateUser(InternalUserRequest internalUserRequest) {
       return internalUserDao.updateUser(internalUserRequest);
    }

    public List<InternalUser> findUser(String username) {
        return internalUserDao.findUser(username, "AUD: Find user");
    }

    public List<TrustedLink> findLinks(String username) {
        return internalUserDao.findLinks(username, "AUD: Find links");
    }
}
