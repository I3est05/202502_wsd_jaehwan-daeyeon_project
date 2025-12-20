package com.example.donjoogga.mapper;

import com.example.donjoogga.vo.Scholarship;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ScholarshipMapper {

    // 1. 장학금 전체 개수 조회
    int selectTotalCount();

    // 2. 페이징 처리된 장학금 목록 조회
    List<Scholarship> selectPagedScholarships(@Param("startRow") int startRow, @Param("pageSize") int pageSize);

    // Admin이 등록한 모든 장학금 정보를 DB에서 조회
    List<Scholarship> selectAllAdminScholarships();

    // 아이디를 통한 특정 데이터 조회
    Scholarship selectScholarshipById(@Param("id") Long id);

    // [관리자] 새 장학금 정보 DB에 추가
    void insertScholarship(Scholarship scholarship);

    // [관리자] 기존 장학금 정보 DB에서 수정
    void updateScholarship(Scholarship scholarship);

    // [관리자] 장학금 정보 DB에서 삭제
    void deleteScholarship(Long id);

    List<Scholarship> selectScrappedScholarshipsOrderByDeadline(String userId);
}