package com.pathcare.pathprovider.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pathcare.pathprovider.resource.model.APIResponse;
import com.pathcare.pathprovider.resource.model.user.UserAccountRequest;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
public class KeycloakService {

    @Value( "${kc.admin.password}" )
    private String kcAdminPasswd;

    @Value( "${keycloak.auth-server-url}" )
    private String kcUrl;

    @Value( "${keycloak.realm}" )
    private String kcRealm;

    @Value( "${keycloak.credentials.secret}" )
    private String kcSecret;

    @Value( "${keycloak.resource}" )
    private String kcClient;

//    private RealmResource realm;

    public ResponseEntity fetchToken(UserAccountRequest userAccountRequest) {
        List<NameValuePair> commParams = new ArrayList<>();
        commParams.add(new BasicNameValuePair("username", userAccountRequest.getUserName()));
        commParams.add(new BasicNameValuePair("password", userAccountRequest.getPassword()));
        commParams.add(new BasicNameValuePair("grant_type", "password"));
        commParams.add(new BasicNameValuePair("client_id", kcClient));
        commParams.add(new BasicNameValuePair("client_secret", kcSecret));
        return sendPost(commParams, "Login success", "Login failed");
    }

    public ResponseEntity fetchRefreshedToken(String refreshToken) {
        List<NameValuePair> commParams = new ArrayList<>();
        commParams.add(new BasicNameValuePair("grant_type", "refresh_token"));
        commParams.add(new BasicNameValuePair("refresh_token", refreshToken));
        commParams.add(new BasicNameValuePair("client_id", kcClient));
        commParams.add(new BasicNameValuePair("client_secret", kcSecret));
        return sendPost(commParams, "Token refresh success", "Token refresh failed");
    }

    public ResponseEntity fetchRefreshedToken(String refreshToken, String clientId) {
        List<NameValuePair> commParams = new ArrayList<>();
        commParams.add(new BasicNameValuePair("grant_type", "refresh_token"));
        commParams.add(new BasicNameValuePair("refresh_token", refreshToken));
        commParams.add(new BasicNameValuePair("client_id", clientId));
        commParams.add(new BasicNameValuePair("client_secret", kcSecret));
        return sendPost(commParams, "Token refresh success", "Token refresh failed");
    }

//    private UsersResource getKeycloakUserResource() {
//        // Let admin get the user resource
//        Keycloak kc = KeycloakBuilder.builder()
//            .serverUrl(kcUrl)
//            .password(kcAdminPasswd)
//            .realm("master")
//            .username("admin")
//            .clientId("admin-cli")
//            .grantType("password")
//            .resteasyClient(new ResteasyClientBuilder().connectionPoolSize(10).build())
//            .build();
//        // Set realm
//        this.realm = kc.realm(kcRealm);
//        UsersResource userResource = realm.users();
//        return userResource;
//    }
//
//    public ResponseEntity logoutUser(String userId) {
//        ResponseEntity responseEntity = null;
//        try {
//            UsersResource usersResource = getKeycloakUserResource();
//            usersResource.get(userId).logout();
//            responseEntity = ResponseEntity.status(HttpStatus.OK).body(new APIResponse(true, "User logout success", null, null));
//        } catch (Exception e) {
//            responseEntity = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new APIResponse(false, "User logout failed", null, Arrays.asList(e.getMessage())));
//        }
//        return responseEntity;
//    }
//
//    public String addUser(InternalUserRequest internalUserRequest) {
//        String userId = null;
//        Long rsId = internalUserRequest.getRsId();
//        Long inId = internalUserRequest.getInId();
//        Long dtId = internalUserRequest.getDtId();
//        UsersResource userResource = getKeycloakUserResource();
//        try {
//            String kcUsername = internalUserRequest.getUsername();
//            String firstName = internalUserRequest.getFirstname();
//            String lastName = internalUserRequest.getSurname();
//            String email = internalUserRequest.getEmail();
//            String cellPhone = internalUserRequest.getPhoneMobile();
//            String password = "ksjdh1735Blxx##4";
//            String source = null;
//            String sourceId = null;
//            if (internalUserRequest.getDtId() != null && internalUserRequest.getDtId() != 0) {
//                source = "Selected from the doctors dictionary with ID";
//                sourceId = internalUserRequest.getDtId().toString();
//            } else {
//                source = "Selected from the internal users with ID";
//                sourceId = internalUserRequest.getInId().toString();
//            }
//            if (inId != null || dtId != null) {
//                UserRepresentation userRep = new UserRepresentation();
//                // Set user details
//                userRep.setEnabled(true);
//                userRep.setUsername(kcUsername);
//                userRep.setFirstName(firstName);
//                userRep.setLastName(lastName);
//                //userRep.setEmail(email);
//                userRep.setEmail("kctest." + kcUsername + "@yopmail.com");
//                // Add attributes
//                Map<String, List<String>> attrMap = new HashMap<>();
//                attrMap.put(source, Arrays.asList(sourceId));
//                if (cellPhone != null && !cellPhone.equalsIgnoreCase(""))
//                    attrMap.put("Cell Phone Number", Arrays.asList(cellPhone));
//                userRep.setAttributes(attrMap);
//                // Create user
//                Response response = userResource.create(userRep);
//                StatusType st = response.getStatusInfo();
//                if (st.getReasonPhrase().equalsIgnoreCase("Created")) {
//                    userId = response.getLocation().getPath().replaceAll(".*/([^/]+)$", "$1");
//                    // Add role
//                    ClientRepresentation pp3Client = realm.clients().findByClientId("pp3").get(0);
//                    RoleRepresentation basicUserRole = realm.clients().get(pp3Client.getId()).roles().get("BasicUser").toRepresentation();
//                    userResource.get(userId).roles().clientLevel(pp3Client.getId()).add(Arrays.asList(basicUserRole));
//                    RoleRepresentation adminRealmRole = realm.roles().get("admin").toRepresentation();
//                    userResource.get(userId).roles().realmLevel().add(Arrays.asList(adminRealmRole));
//                    // Define password credential
//                    CredentialRepresentation passwordCred = new CredentialRepresentation();
//                    passwordCred.setTemporary(true);
//                    passwordCred.setType(CredentialRepresentation.PASSWORD);
//                    passwordCred.setValue(password);
//                    // Set password credential
//                    userResource.get(userId).resetPassword(passwordCred);
//                    // Send reset password email
//                    List<String> execActions = new LinkedList<>();
//                    execActions.add("UPDATE_PASSWORD");
//                    userResource.get(userId).executeActionsEmail(execActions);
//                } else {
//                    throw new ApplicationException("Keycloak user adding failed, reason: " + st.getReasonPhrase());
//                }
//            }
//        } catch (Exception e) {
//            throw new ApplicationException(e.getMessage());
//        }
//        return userId;
//    }
//
//    public ResponseEntity resetPassword(UserSearchRequest userSearchRequest) {
//        ResponseEntity responseEntity = null;
//        try {
//            String userId = userSearchRequest.getUserId();
//            String userName = userSearchRequest.getUserName();
//            String emailAddress = userSearchRequest.getEmailAddress();
//            UsersResource usersResource = getKeycloakUserResource();
//            String findId = null;
//            if (userId != null && !userId.isEmpty()) {
//                findId = userId;
//            } else if (userName != null && !userName.isEmpty()) {
//                List<UserRepresentation> userRep = usersResource.search(userName);
//                if (userRep != null && !userRep.isEmpty() && userRep.get(0).getUsername().equalsIgnoreCase(userName))
//                    findId = userRep.get(0).getId();
//            }
//            if (findId == null && emailAddress != null && !emailAddress.isEmpty()) {
//                List<UserRepresentation> userRep = usersResource.search(emailAddress, 0, 1, true);
//                if (userRep != null && !userRep.isEmpty() && userRep.get(0).getEmail().equalsIgnoreCase(emailAddress))
//                    findId = userRep.get(0).getId();
//            }
//            if (findId != null) {
//                // Send reset password email
//                List<String> execActions = new LinkedList<>();
//                execActions.add("UPDATE_PASSWORD");
//                usersResource.get(findId).executeActionsEmail(execActions);
//                responseEntity = ResponseEntity.status(HttpStatus.OK).body(new APIResponse(true, "Update password email send", null, null));
//            } else {
//                responseEntity = ResponseEntity.status(HttpStatus.NOT_FOUND).body(new APIResponse(false, "User not found", null, null));
//            }
//        } catch (Exception e) {
//            responseEntity = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new APIResponse(false, "Error occurred", null, Arrays.asList(e.getMessage())));
//        }
//        return responseEntity;
//    }

    private ResponseEntity sendPost(List<NameValuePair> urlParameters, String successMsg, String failMsg) {
        ResponseEntity responseEntity = null;
        try {
            HttpClient client = HttpClientBuilder.create().build();
            HttpPost post = new HttpPost(kcUrl + "/realms/" + kcRealm + "/protocol/openid-connect/token");

            post.setEntity(new UrlEncodedFormEntity(urlParameters));

            HttpResponse response = client.execute(post);

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> result = mapper.readValue(response.getEntity().getContent(), Map.class);

            int respCode = response.getStatusLine().getStatusCode();
            if (respCode >= 400) {
                //TODO will result in a 200 response
                responseEntity = ResponseEntity.status(respCode).body(new APIResponse(false, failMsg, result, null));
            } else {
                responseEntity = ResponseEntity.status(respCode).body(new APIResponse(true, successMsg, result, null));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return responseEntity;
    }

}
