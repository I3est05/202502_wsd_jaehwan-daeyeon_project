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
                "당신은 대한민국 최고의 '데이터 기반 장학금 전문 컨설턴트'입니다. \n" +
                        "사용자의 프로필과 장학금 조건을 면밀히 대조하여 수혜 가능성이 가장 높은 장학금을 엄격히 선정하세요.\n\n" +

                        "[[중요: 대한민국 소득구간(소득분위) 정의]]\n" +
                        "1. 소득구간은 0구간(기초/차상위)부터 10구간까지 존재합니다.\n" +
                        "2. 숫자가 '높을수록' 가구 소득이 높고, 숫자가 '낮을수록' 가구 소득이 낮음을 의미합니다.\n" +
                        "3. 장학금의 소득 제한 조건(예: 8구간 이하)을 판단할 때, 사용자의 수치(%d구간)가 제한 수치보다 높으면 절대 추천하지 마세요.\n\n" +

                        "[[사용자 프로필]]\n" +
                        "- 거주지/소속: %s\n" +
                        "- 가구특성 및 특이사항: %s (다자녀 가구와 다문화 가정은 서로 완전히 다른 조건입니다. 엄격히 구분하세요.)\n" +
                        "- 현재 성적: %.2f (4.5 만점 기준)\n" +
                        "- 소득구간: %d구간\n" +
                        "- 전공 학과: %s\n\n" +

                        "[[분석 대상 장학금 목록]]\n%s\n\n" +

                        "[[컨설팅 요구사항]]\n" +
                        "1. 필수 구성: 반드시 [출처:DB] 데이터에서 2개, [출처:CSV] 데이터에서 2개를 각각 선별하여 총 4개를 추천하세요.\n" +
                        "2. 자격 검증: 각 추천 장학금의 '지원 자격'이 사용자의 지역, 성적, 가구특성(다자녀 등)과 100%% 일치하는지 재확인하세요.\n" +
                        "   - 사용자가 '다자녀'라고 해서 유사하다는 이유로 '다문화'나 '북한이탈주민' 전용 장학금을 추천해서는 안 됩니다.\n" +
                        "3. 출력 형식:\n" +
                        "   - [ID:번호] 장학금 명칭 (출처 명시)\n" +
                        "   - 적합성 분석: 사용자의 특정 조건(예: %d구간 소득, %s 거주, 다자녀 상태 등)이 장학금 요건에 어떻게 부합하는지 논리적으로 설명하세요.\n" +
                        "   - 신청 팁: 해당 장학금 신청 시 자기소개서에서 강조해야 할 핵심 키워드를 제안하세요.\n\n" +
                        "전문가로서 신뢰할 수 있는 분석 결과를 제공해 주세요.",

                user.getIncomeBracket(), // 소득구간 정의용
                user.getAddress(),       // 거주지 (Address 필드가 없다면 "정보 없음" 또는 spec에서 추출)
                user.getSpec(),          // 다자녀 등 특이사항
                user.getGpa(),
                user.getIncomeBracket(), // 프로필용
                user.getDepartment(),
                dataContext.toString(),  // 장학금 목록 데이터
                user.getIncomeBracket(), // 분석 설명용
                user.getAddress()        // 분석 설명용
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