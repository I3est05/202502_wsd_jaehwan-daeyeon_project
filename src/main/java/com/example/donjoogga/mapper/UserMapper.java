package com.example.donjoogga.mapper;

import com.example.donjoogga.vo.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    // 회원가입 (데이터 저장)
    void save(User user);

    // 로그인 (이메일로 회원 찾기)
    User findByEmail(String email);
}