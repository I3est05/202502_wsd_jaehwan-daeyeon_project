package com.example.donjoogga.service;

import com.example.donjoogga.vo.GeminiRequest;
import com.example.donjoogga.vo.Scholarship;
import com.example.donjoogga.vo.User;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Collections;
import java.util.List;

@Service
public class ConsultingService {

    @Autowired
    private ScholarshipService scholarshipService;

    private final String API_KEY = "AIzaSyDfvvknElNYGCYmQG-51A950Meo62oC3Fk";
    private final String URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=" + API_KEY;

    public String getRecommendation(User user) {
        // 1. 데이터 로드 (DB 전부 + CSV 20개 정도)
        // DB가 5개뿐이므로 모두 가져옵니다.
        List<Scholarship> dbList = scholarshipService.getPagedScholarshipListDBOnly(0, 10);

        // CSV 데이터를 충분히 확보하기 위해 DB 개수 이후부터 20개를 가져옵니다.
        int totalDbCount = scholarshipService.getTotalCountDBOnly();
        List<Scholarship> csvList = scholarshipService.getPagedScholarshipList(totalDbCount, 20);

        StringBuilder dataContext = new StringBuilder();

        // 데이터 구성 시 [출처]를 명확히 표기하여 AI가 구분하게 합니다.
        for (Scholarship s : dbList) {
            dataContext.append(String.format("[ID:%d][출처:DB] %s (%s)\n",
                    s.getRefId(), s.getTitle(), s.getOrganization()));
        }
        for (Scholarship s : csvList) {
            dataContext.append(String.format("[ID:%d][출처:CSV] %s (%s)\n",
                    s.getRefId(), s.getTitle(), s.getOrganization()));
        }

        // 2. 프롬프트 수정: 2개 + 2개 강제 규칙 추가
        String prompt = String.format(
                "당신은 장학금 컨설턴트입니다. 다음 사용자의 프로필을 분석하여 반드시 [출처:DB]에서 2개, [출처:CSV]에서 2개를 선택해 총 4개의 장학금을 추천하세요.\n\n" +
                        "[[사용자 프로필]]\n" +
                        "- 학과: %s\n- 성적: %.2f\n- 소득구간: %d구간\n- 특이사항: %s\n\n" +
                        "[[장학금 목록]]\n%s\n\n" +
                        "요구사항:\n" +
                        "1. 반드시 DB 데이터 2개와 CSV 데이터 2개를 각각 골라야 함.\n" +
                        "2. 각 추천마다 반드시 [ID:번호]를 명시할 것.\n" +
                        "3. 사용자의 학과나 소득구간에 왜 적합한지 이유를 상세히 설명할 것.",
                user.getDepartment(), user.getGpa(), user.getIncomeBracket(),
                user.getSpec(), dataContext.toString()
        );

        // ... (이후 API 전송 로직은 동일) ...
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        GeminiRequest requestBody = new GeminiRequest(Collections.singletonList(new GeminiRequest.Content(Collections.singletonList(new GeminiRequest.Part(prompt)))));
        HttpEntity<GeminiRequest> entity = new HttpEntity<>(requestBody, headers);

        try {
            String response = restTemplate.postForObject(URL, entity, String.class);
            return parseTextFromResponse(response);
        } catch (Exception e) {
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