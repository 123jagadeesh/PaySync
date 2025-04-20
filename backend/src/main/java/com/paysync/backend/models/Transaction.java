package com.paysync.backend.models;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Transaction {
    private String id;
    private double amount;
    private List<String> category;
    @JsonProperty("dateTime")
    private Date date;
    private String location;
    private String notes;
    private List<String> paymentMethod;
}
