package com.pathcare.pathprovider.resource.model;

/**
 * This is a Bean class for Message
 */
public class Message {

    private String field;
    private String messageDescription;
    private String value;
    private String redirectTo = "";

    /**
     * Instantiates a new Message.
     */
    public Message() {
        //Default Constructor for Message
    }

    /**
     * Instantiates a new Message with test
     *
     * @param messageDescription - message text
     */
    public Message(String messageDescription) {
        this.messageDescription = messageDescription;
    }

    /**
     * This the parametrised constructor for Message
     *
     * @param field the field
     * @param messageDescription the message description
     * @param value the value
     */
    public Message(String field, String messageDescription, Object value) {
        this.field = field;
        this.messageDescription = messageDescription;
        this.value = value != null ? value.toString() : null;
    }

    /**
     * This the parametrised constructor for Message
     *
     * @param field the field
     * @param messageDescription the message description
     * @param value the value
     * @param redirectTo the path to navigate to
     */
    public Message(String field, String messageDescription, Object value, String redirectTo) {
        this.field = field;
        this.messageDescription = messageDescription;
        this.value = value != null ? value.toString() : null;
        this.redirectTo = redirectTo;
    }

    /**
     * Gets field.
     *
     * @return the field
     */
    public String getField() {
        return field;
    }

    /**
     * Sets field.
     *
     * @param field the field
     */
    public void setField(String field) {
        this.field = field;
    }

    /**
     * Gets message description.
     *
     * @return the message description
     */
    public String getMessageDescription() {
        return messageDescription;
    }

    /**
     * Sets message description.
     *
     * @param messageDescription the message description
     */
    public void setMessageDescription(String messageDescription) {
        this.messageDescription = messageDescription;
    }

    /**
     * Gets value.
     *
     * @return the value
     */
    public String getValue() {
        return value;
    }

    /**
     * Sets value.
     *
     * @param value the value
     */
    public void setValue(String value) {
        this.value = value;
    }


    /**
     * Added as a way to give the UI user an ability to navigate to the appropriate
     * link to probably for fixing an error
     * @param redirectTo a path to navigate to
     */
    public void setRedirectTo(String redirectTo) {
        this.redirectTo = redirectTo;
    }

    /**
     * The path to redirect UI control to
     * @return the path string
     */
    public String getRedirectTo() {
        return redirectTo;
    }
}

