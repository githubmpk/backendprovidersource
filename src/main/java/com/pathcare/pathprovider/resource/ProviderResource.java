package com.pathcare.pathprovider.resource;

import com.pathcare.pathprovider.domain.Provider;
import com.pathcare.pathprovider.resource.model.ProviderModel;
import com.pathcare.pathprovider.service.ProviderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;


@Component
@Path("v1")
public class ProviderResource extends BaseResource {

    @Autowired
    private ProviderService service;

    public ProviderResource() {

    }

    public ProviderResource(ProviderService service) {
        this.service = service;
    }

    /**
     * retrieves the list of providers using the specified provider name Its a GET query param part of
     * api
     *
     * @return - a list of providers
     */

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("provider")
    @Transactional
    public List<ProviderModel> getProvider(@QueryParam(value = "name") String name) {
        List<Provider> providers = service.returnProviders(findPrincipalName(), name);
        return providers.stream().map(t -> new ProviderModel(t)).collect(Collectors.toList());
    }
}
