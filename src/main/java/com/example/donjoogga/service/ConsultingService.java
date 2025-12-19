package com.example.donjoogga.service;

import com.example.donjoogga.vo.GeminiRequest;
import com.example.donjoogga.vo.Scholarship;
import com.example.donjoogga.vo.User;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;
import java.util.List;

@Service
public class ConsultingService {

    // 1. application.properties에서 안전하게 키를 가져옴
    @Value("${gemini.api.key}")
    private String API_KEY;

    @Autowired
    private ScholarshipService scholarshipService;

    // final을 제거하고 메서드 호출 시 사용하거나 @PostConstruct를 써야 합니다.
    private final String BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=";

    public String getRecommendation(User user) {
        // ✅ API_KEY가 포함된 최종 URL 생성
        String finalUrl = BASE_URL + API_KEY;

        // 1. 데이터 로드 (DB 전부 + CSV 20개 정도)
        List<Scholarship> dbList = scholarshipService.getPagedScholarshipListDBOnly(0, 10);
        int totalDbCount = scholarshipService.getTotalCountDBOnly();
        List<Scholarship> csvList = scholarshipService.getPagedScholarshipList(totalDbCount, 20);

        StringBuilder dataContext = new StringBuilder();

        for (Scholarship s : dbList) {
            dataContext.append(String.format("[ID:%d][출처:DB] %s (%s)\n",
                    s.getRefId(), s.getTitle(), s.getOrganization()));
        }
        for (Scholarship s : csvList) {
            dataContext.append(String.format("[ID:%d][출처:CSV] %s (%s)\n",
                    s.getRefId(), s.getTitle(), s.getOrganization()));
        }

        // 2. 프롬프트 구성
        String prompt = String.format(
                "당신은 장학금 컨설턴트입니다. 다음 사용자의 프로필을 분석하여 반드시 [출처:DB]에서 2개, [출처:CSV]에서 2개를 선택해 총 4개의 장학금을 추천하세요.\n\n" +
                        "[[사용자 프로필]]\n" +
                        "- 학과: %s\n- 성적: %.2f\n- 소득구간: %d구간\n- 특이사항: %s\n\n" +
                        "[[장학금 목록]]\n%s\n\n" +
                        "요구사항:\n" +
                        "1. 반드시 DB 데이터 2개와 CSV 데이터 2개를 각각 골라야 함.\n" +
                        "2. 각 추천마다 반드시 [ID:번호]를 명시할 것.\n" +
                        "3. 왜 적합한지 이유를 상세히 설명할 것.",
                user.getDepartment(), user.getGpa(), user.getIncomeBracket(),
                user.getSpec(), dataContext.toString()
        );

        // 3. API 전송
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        GeminiRequest requestBody = new GeminiRequest(Collections.singletonList(new GeminiRequest.Content(Collections.singletonList(new GeminiRequest.Part(prompt)))));
        HttpEntity<GeminiRequest> entity = new HttpEntity<>(requestBody, headers);

        try {
            // ✅ finalUrl 사용
            String response = restTemplate.postForObject(finalUrl, entity, String.class);
            return parseTextFromResponse(response);
        } catch (Exception e) {
            // 403 에러 등이 나면 메시지에 출력됨
            return "추천 오류: " + e.getMessage();
        }
    }

    private String parseTextFromResponse(String responseJson) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(responseJson);
            return root.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();
        } catch (Exception e) {
            return "결과 해석 중 오류가 발생했습니다.";
        }
    }
}