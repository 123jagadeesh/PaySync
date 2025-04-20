package com.paysync.backend.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@org.springframework.web.bind.annotation.CrossOrigin(origins = "*")
public class SecureController {

    @GetMapping("/secure")
    public String secureEndpoint(HttpServletRequest request) {
        String uid = (String) request.getAttribute("uid");
        return "Hello, user with UID: " + uid + "! You have accessed a secure endpoint.";
    }
}
