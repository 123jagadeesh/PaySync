package com.paysync.backend.models;
import lombok.Getter;
import lombok.Setter;
import java.util.Date;

@Getter
@Setter
public class User {
    private String uid;
    private String name;
    private String email;
    private String phone;
    private String password;
    private Date createdAt;
}
