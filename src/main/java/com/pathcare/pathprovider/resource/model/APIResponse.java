package com.pathcare.pathprovider.resource.model;

import java.util.List;

public class APIResponse<T, E> {

    private Boolean success;

    private String message;

    private T data;

    private List<E> errors;

    public APIResponse(Boolean success, String message, T data, List<E> errors) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.errors = errors;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public List<E> getErrors() {
        return errors;
    }

    public void setErrors(List<E> errors) {
        this.errors = errors;
    }

}
