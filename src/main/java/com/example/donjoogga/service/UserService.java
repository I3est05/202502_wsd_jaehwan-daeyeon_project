package com.example.donjoogga.service;

import com.example.donjoogga.mapper.UserMapper;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    // 회원가입 처리
    public void join(User user) {
        userMapper.save(user);
    }

    // 로그인 처리
    public User login(String email, String password) {
        User user = userMapper.findByEmail(email);

        // 1. 유저가 존재하고,
        // 2. 입력한 비밀번호와 DB 비밀번호가 똑같다면 -> 로그인 성공
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null; // 실패
    }
}