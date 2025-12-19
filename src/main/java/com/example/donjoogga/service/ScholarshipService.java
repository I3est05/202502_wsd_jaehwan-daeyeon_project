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
import java.util.stream.Collectors;


@Service
public class ScholarshipService {

    @Autowired
    private ScholarshipMapper scholarshipMapper;

    // 검색 결과에 따른 전체 개수도 필요합니다.
    public int getTotalCount(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return scholarshipMapper.selectTotalCount() + 1800; // 기존 방식
        }
        // 필터링된 전체 리스트의 크기 반환
        List<Scholarship> allList = new ArrayList<>();
        allList.addAll(scholarshipMapper.selectAllAdminScholarships());
        allList.addAll(getAllApiScholarships());

        String finalKeyword = keyword.toLowerCase();
        return (int) allList.stream()
                .filter(s -> (s.getTitle() != null && s.getTitle().toLowerCase().contains(finalKeyword)) ||
                        (s.getOrganization() != null && s.getOrganization().toLowerCase().contains(finalKeyword)) ||
                        (s.getDescription() != null && s.getDescription().toLowerCase().contains(finalKeyword)))
                .count();
    }

    public int getTotalCountDBOnly() {
        return scholarshipMapper.selectTotalCount();
    }

    public List<Scholarship> getPagedScholarshipListDBOnly(int startRow, int pageSize) {
        List<Scholarship> dbList = scholarshipMapper.selectPagedScholarships(startRow, pageSize);

        return dbList;
    }

    // 한국장학재단 CSV 파일 읽기 및 데이터 변환 메서드 (전체 목록)
    private List<Scholarship> getAllApiScholarships() {
        String csvFileName = "kosaf.csv";
        List<Scholarship> apiList = new ArrayList<>();

        // 📌 DB의 전체 개수를 미리 가져와서 API 데이터의 refId 시작점을 계산합니다.
        int totalDbCount = scholarshipMapper.selectTotalCount();
        long currentApiId = totalDbCount + 1; // API 데이터의 가상 refId 시작점

        // ... (CSV 파일 읽기 및 파싱 로직)

        try (Reader reader = new InputStreamReader(
                getClass().getClassLoader().getResourceAsStream(csvFileName),
                Charset.forName("CP949"))) {

            if (reader != null && reader.ready()) {
                List<Scholarship> parsedList = new CsvToBeanBuilder<Scholarship>(reader)
                        .withType(Scholarship.class)
                        .withSeparator(',')
                        .withIgnoreLeadingWhiteSpace(true)
                        .build()
                        .parse();

                // 2. API 데이터의 메타 정보 (refId, sourceType, description) 설정 및 보강
                for (Scholarship scholarship : parsedList) {
                    // API 데이터에 고유한 가상 refId와 sourceType을 부여
                    scholarship.setRefId(currentApiId++);
                    scholarship.setSourceType("API");

                    // 상세보기에 표시할 설명 보강
                    String desc = scholarship.getDescription();
                    if (desc == null || desc.isEmpty()) {
                        scholarship.setDescription("상세 설명 없음.");
                    }
                    scholarship.setDescription(scholarship.getDescription()
                            + "\n\n(본 정보는 한국장학재단 API(CSV)를 통해 제공된 정보입니다.)");
                }
                apiList.addAll(parsedList);
            } else {
                System.err.println("CSV 파일을 Classpath에서 찾을 수 없거나 열 수 없습니다: " + csvFileName);
            }

        } catch (Exception e) {
            System.err.println("CSV 파일 읽기 또는 파싱 오류: " + e.getMessage());
        }

        return apiList;
    }

    public List<Scholarship> getPagedScholarshipList(int startRow, int pageSize, String keyword) {
        List<Scholarship> allList = new ArrayList<>();

        // 1. DB와 API 데이터 합치기 (기존 로직 활용)
        allList.addAll(scholarshipMapper.selectAllAdminScholarships()); // DB 데이터
        allList.addAll(getAllApiScholarships()); // API 데이터

        // 2. 키워드가 있다면 필터링 수행
        if (keyword != null && !keyword.trim().isEmpty()) {
            String finalKeyword = keyword.toLowerCase();
            allList = allList.stream()
                    .filter(s -> (s.getTitle() != null && s.getTitle().toLowerCase().contains(finalKeyword)) ||
                            (s.getOrganization() != null && s.getOrganization().toLowerCase().contains(finalKeyword)) ||
                            (s.getDescription() != null && s.getDescription().toLowerCase().contains(finalKeyword)))
                    .collect(Collectors.toList());
        }

        // 3. 필터링된 결과에서 페이징 처리
        int end = Math.min(startRow + pageSize, allList.size());
        if (startRow >= allList.size()) return new ArrayList<>();

        return allList.subList(startRow, end);
    }


    public Scholarship getScholarshipDetail(Long id) {
        // 1. DB에 저장된 장학금 정보를 조회 시도
        Scholarship scholarship = scholarshipMapper.selectScholarshipById(id);

        // 2. DB에서 찾으면 바로 반환
        if (scholarship != null) {
            return scholarship;
        }

        // 3. DB에서 찾지 못한 경우, API (CSV) 데이터인지 확인
        int totalDbCount = scholarshipMapper.selectTotalCount();

        // ID가 DB 데이터 범위를 초과하는지 확인 (API 데이터의 가상 ID는 totalDbCount + 1 부터 시작)
        if (id > totalDbCount) {
            try {
                // refId가 설정된 API (CSV) 장학금 전체 목록을 로드합니다.
                List<Scholarship> allApiList = getAllApiScholarships();

                // API 목록의 0-based Index 계산
                // index = id - totalDbCount - 1
                int apiIndex = (int) (id - totalDbCount - 1);

                // 인덱스가 유효 범위 내에 있는지 확인
                if (apiIndex >= 0 && apiIndex < allApiList.size()) {
                    // 해당 인덱스의 API 장학금 반환
                    return allApiList.get(apiIndex);
                }
            } catch (Exception e) {
                System.err.println("CSV 파일에서 장학금 상세 조회 중 오류 발생: " + e.getMessage());
            }
        }

        // 4. DB에도 없고, API ID 범위에도 해당하지 않으면 null 반환
        return null;
    }

    public void addScholarship(Scholarship scholarship) {
        // sourceType은 'DB'로 강제 설정
        scholarship.setSourceType("DB");
        scholarshipMapper.insertScholarship(scholarship);
    }

    // [관리자] 장학금 정보 수정
    public void modifyScholarship(Scholarship scholarship) {
        scholarshipMapper.updateScholarship(scholarship);
    }

    // [관리자] 장학금 정보 삭제
    public void removeScholarship(Long id) {
        scholarshipMapper.deleteScholarship(id);
    }
}