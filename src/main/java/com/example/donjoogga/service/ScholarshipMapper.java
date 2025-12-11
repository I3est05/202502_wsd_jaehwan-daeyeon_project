package com.example.donjoogga.service;

import com.example.donjoogga.vo.Scholarship;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ScholarshipMapper {
    // Admin이 등록한 모든 장학금 정보를 DB에서 조회
    List<Scholarship> selectAllAdminScholarships();

    Scholarship selectScholarshipById(@Param("id") Long id);

    // (추가) 사용자의 프로필 기반 필터링 쿼리
    //List<ScholarVO> selectFilteredScholarships(User userProfile);
}