package com.example.donjoogga.mapper;

import com.example.donjoogga.vo.Scholarship;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface MyScholarshipMapper {
    void insertMyScholarship(@Param("userId") String userId, @Param("scholarId") Long scholarId, @Param("isApiData") int isApiData);
    void deleteMyScholarship(@Param("userId") String userId, @Param("scholarId") Long scholarId);
    List<Scholarship> selectMyScrapList(String userId);
    int checkScrapped(@Param("userId") String userId, @Param("scholarId") Long scholarId);
}