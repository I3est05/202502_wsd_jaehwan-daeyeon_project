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
    public User login(String userId, String password) {
        User user = userMapper.findById(userId);

        // 1. 유저가 존재하고,
        // 2. 입력한 비밀번호와 DB 비밀번호가 똑같다면 -> 로그인 성공
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null; // 실패
    }

    public void updateUser(User user) {
        // 1. 수정 폼에서 넘어온 비밀번호가 비어있는지 확인
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            // 2. 비어있다면 DB에서 기존 사용자 정보를 다시 조회
            User existingUser = userMapper.findById(user.getUserId());

            if (existingUser != null) {
                // 3. 기존의 비밀번호를 객체에 다시 넣어줌
                user.setPassword(existingUser.getPassword());
            }
        }

        // 4. 이제 비밀번호가 안전하게 채워진 상태로 업데이트 실행
        userMapper.update(user);
    }
    // UserService.java
    public User findById(String userId) {
        return userMapper.findById(userId); // findById가 UserMapper에 정의되어 있어야 함
    }
}