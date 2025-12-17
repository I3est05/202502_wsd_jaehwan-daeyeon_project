package com.example.donjoogga.controller;

import com.example.donjoogga.service.MyScholarshipService;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/scrap")
public class ScrapRestController {

    @Autowired
    private MyScholarshipService myScholarshipService;

    @PostMapping(value = "/toggle", produces = "application/json; charset=UTF-8")
    public ResponseEntity<?> toggleScrap(@RequestParam("scholarId") Long scholarId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseEntity.status(401).body("{\"result\": \"login_required\"}");
        }

        // 서비스에서 boolean 결과 받기
        boolean isScrapped = myScholarshipService.toggleScrap(loginUser.getUserId(), scholarId);

        // 명시적으로 JSON 형태로 응답 (Map 활용 추천)
        Map<String, Object> response = new HashMap<>();
        response.put("isScrapped", isScrapped);

        return ResponseEntity.ok(response);
    }
}