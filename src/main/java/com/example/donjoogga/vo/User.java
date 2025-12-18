package com.example.donjoogga.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private String userId;          // user_id
    private String email;        // email
    private String password;     // password
    private int incomeBracket;   // income_bracket
    private float gpa;           // gpa
    private LocalDateTime createdAt; // created_at
    private String department;   // 학과 (예: 컴퓨터공학)
    private int grade;           // 학년 (1~4)
    private String address;      // 거주지 (예: 서울시 강남구)
    private String spec;
}