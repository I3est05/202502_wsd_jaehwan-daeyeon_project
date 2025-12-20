package com.example.donjoogga.vo;

import lombok.Data;
import com.opencsv.bean.CsvBindByName;

@Data
public class Scholarship {

    // refId를 Long 타입으로 변경 (CSV '번호' 컬럼)
    @CsvBindByName(column = "번호")
    private Long refId;

    // 기본 정보 매핑 (String 유지)
    @CsvBindByName(column = "상품명")
    private String title;

    @CsvBindByName(column = "운영기관명")
    private String organization;

    @CsvBindByName(column = "모집종료일")
    private String deadline;

    @CsvBindByName(column = "학자금유형구분")
    private String category;

    // 지원 금액 (String 유지)
    @CsvBindByName(column = "지원내역 상세내용")
    private String support_amount;

    // 상세 설명 (CSV '특정자격 상세내용' 컬럼)
    @CsvBindByName(column = "특정자격 상세내용")
    private String description;

    @CsvBindByName(column = "홈페이지 주소")
    private String homepageUrl;

    // 출처 구분 (DB vs API)
    private String sourceType;

    private int matchScore;
    private int matchPercent;

}