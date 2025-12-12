package com.example.donjoogga.service;

import com.example.donjoogga.service.ScholarshipMapper;
import com.example.donjoogga.vo.Scholarship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


@Service
public class ScholarshipService {

    @Autowired
    private ScholarshipMapper scholarshipMapper;

    // 한국장학재단 API 호출 및 데이터 변환 메서드 (외부 API 로직)
    private List<Scholarship> getApiScholarships() {
        // 1. 한국장학재단 API 호출 (추가 기능 API) [cite: 53]
        // 2. JSON 응답 파싱 및 ScholarshipDTO 리스트로 변환
        // 예시:
        // List<ScholarshipDTO> apiList = new ArrayList<>();
        // apiList.add(new ScholarshipDTO(..., "API", "api_id_1"));
        List<Scholarship> apiList = new  ArrayList<>();
        return apiList;
    }

    // 장학금 전체 목록 통합 조회
    public List<Scholarship> getAllScholarshipList() {
        // 1. DB (Admin) 장학금 조회
        List<Scholarship> dbList = scholarshipMapper.selectAllAdminScholarships();

        // 2. API (장학재단) 장학금 조회
        List<Scholarship> apiList = getApiScholarships();

        // 3. 두 리스트 통합 (합치기)
        List<Scholarship> combinedList = new ArrayList<>();
        combinedList.addAll(dbList);
        combinedList.addAll(apiList);

        return combinedList;
    }

    public Scholarship getScholarshipDetail(Long id) {
        // DB에 저장된 (Admin 등록 또는 동기화된) 장학금 정보를 조회
        Scholarship scholarship = scholarshipMapper.selectScholarshipById(id);

        return scholarship;
    }
}