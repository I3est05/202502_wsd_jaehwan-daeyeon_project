package com.example.donjoogga.vo;

import lombok.Data;

@Data
public class MyScholarshipVO {
    private int myScholarId;      // PK
    private String userId;        // 유저 ID
    private Long scholarId;       // 장학금 ID (refId)
    private int isApiData;        // API 여부 (DB 데이터면 0)
    private String savedDate;     // 저장 날짜
}