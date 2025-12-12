package com.example.donjoogga.service;

import com.example.donjoogga.mapper.ScholarshipMapper;
import com.example.donjoogga.vo.Scholarship;
import com.opencsv.bean.CsvToBeanBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;


@Service
public class ScholarshipService {

    @Autowired
    private ScholarshipMapper scholarshipMapper;

    // 장학금 전체 개수 조회 (DB, API 통합 개수)
    public int getTotalCount() {
        int dbCount = scholarshipMapper.selectTotalCount();
        int apiCount = 1800;
        return dbCount + apiCount;
    }

    // 한국장학재단 CSV 파일 읽기 및 데이터 변환 메서드 (전체 목록)
    private List<Scholarship> getAllApiScholarships() {
        String csvFileName = "kosaf.csv"; // 파일 이름만 지정합니다.
        List<Scholarship> apiList = new ArrayList<>();

        // 📌 ClassLoader를 사용하여 Classpath 리소스를 읽습니다.
        try (Reader reader = new InputStreamReader(
                getClass().getClassLoader().getResourceAsStream(csvFileName),
                Charset.forName("CP949"))) {

            // getResourceAsStream()이 null을 반환하거나 스트림이 닫힌 경우를 대비한 검사
            if (reader != null && reader.ready()) {
                // OpenCSV CsvToBeanBuilder를 사용하여 CSV 파일을 Scholarship 객체 리스트로 매핑
                List<Scholarship> parsedList = new CsvToBeanBuilder<Scholarship>(reader)
                        .withType(Scholarship.class)
                        .withSeparator(',')
                        .withIgnoreLeadingWhiteSpace(true)
                        .build()
                        .parse();

                // 후처리: sourceType 설정
                for (Scholarship s : parsedList) {
                    s.setSourceType("API");
                }
                apiList.addAll(parsedList);
            } else {
                System.err.println("CSV 파일을 Classpath에서 찾을 수 없거나 열 수 없습니다: " + csvFileName);
            }

        } catch (Exception e) {
            System.err.println("CSV 파일 읽기 또는 파싱 오류: " + e.getMessage());
            // e.printStackTrace(); // 디버깅을 위해 스택 트레이스를 출력해볼 수 있습니다.
        }

        return apiList;
    }

    // ... (getPagedScholarshipList 메서드와 getScholarshipDetail 메서드는 유지)
    public List<Scholarship> getPagedScholarshipList(int startRow, int pageSize) {
        List<Scholarship> combinedList = new ArrayList<>();

        // 1. DB (Admin) 장학금 조회 (DB 우선)
        // startRow부터 pageSize만큼 DB 데이터만 가져옵니다.
        List<Scholarship> dbList = scholarshipMapper.selectPagedScholarships(startRow, pageSize);
        combinedList.addAll(dbList);

        // 2. DB 데이터가 페이지 크기보다 적을 경우 (DB에 데이터가 부족하거나 마지막 페이지)
        if (combinedList.size() < pageSize) {
            int needCount = pageSize - combinedList.size();

            List<Scholarship> allApiList = getAllApiScholarships();

            int totalDbCount = scholarshipMapper.selectTotalCount();

            int apiStartRow = startRow - totalDbCount; // API 데이터 시작 인덱스

            if (apiStartRow < 0) {
            } else if (apiStartRow < allApiList.size()) {
                int endApiIndex = Math.min(apiStartRow + needCount, allApiList.size());
                List<Scholarship> requiredApiData =
                        allApiList.subList(apiStartRow, endApiIndex);

                combinedList.addAll(requiredApiData);
            }
        }
        return combinedList;
    }

    public Scholarship getScholarshipDetail(Long id) {
        // DB에 저장된 (Admin 등록 또는 동기화된) 장학금 정보를 조회
        Scholarship scholarship = scholarshipMapper.selectScholarshipById(id);

        return scholarship;
    }
}