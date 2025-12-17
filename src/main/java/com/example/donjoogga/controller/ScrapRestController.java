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
    public ResponseEntity<?> toggleScrap(
            @RequestParam("scholarId") Long scholarId,
            @RequestParam(value="isApi", defaultValue="0") int isApi, // JSP에서 보낸 값
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) return ResponseEntity.status(401).build();

        // 서비스 호출 시 isApi 전달
        boolean result = myScholarshipService.toggleScrap(loginUser.getUserId(), scholarId, isApi);

        Map<String, Object> map = new HashMap<>();
        map.put("isScrapped", result);
        return ResponseEntity.ok(map);
    }
}