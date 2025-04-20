package com.paysync.backend.controller;
import com.paysync.backend.services.UserService;
import com.paysync.backend.models.User;
import java.util.concurrent.ExecutionException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
public class UserController {
    public UserService userService;
    public UserController(UserService userService) {
        this.userService = userService;
    }
    @PostMapping("/create")
    public String createUser(@RequestBody User user) throws InterruptedException,ExecutionException{
        return userService.createUser(user);
    }
    @GetMapping("/get")
    public User getUser(@RequestParam String uid) throws InterruptedException,ExecutionException{
        return userService.getUser(uid);
    }
    @PutMapping("/update")
    public String updateUser(@RequestBody User user) throws InterruptedException,ExecutionException{
        return userService.updateUser(user);
    }
    @DeleteMapping("/delete")
    public User deleteUser(@RequestParam String uid) throws InterruptedException,ExecutionException{
        return userService.deleteUser(uid);
    }
     @GetMapping("/test")
     public ResponseEntity<String> usersGetEndpoint() {
         return ResponseEntity.ok("users Endpoint is working");
     }


}
