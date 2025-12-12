package com.example.donjoogga.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private int userId;          // user_id
    private String email;        // email
    private String password;     // password
    private int incomeBracket;   // income_bracket
    private float gpa;           // gpa
    private LocalDateTime createdAt; // created_at
}