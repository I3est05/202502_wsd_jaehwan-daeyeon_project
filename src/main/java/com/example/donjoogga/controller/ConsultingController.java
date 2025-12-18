package com.example.donjoogga.controller;

import com.example.donjoogga.service.ConsultingService;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import javax.servlet.http.HttpSession;

@Controller
public class ConsultingController {

    @Autowired
    private ConsultingService consultingService;

    @GetMapping("/consulting.do")
    public String startConsulting(HttpSession session, Model model) {
        // 1. 세션에서 로그인한 사용자 정보 가져오기
        User loginUser = (User) session.getAttribute("loginUser");

        // 2. 로그인 안 되어 있으면 로그인 페이지로 리다이렉트
        if (loginUser == null) {
            return "redirect:/login?required=true";
        }

        // 3. Gemini API를 통해 AI 추천 결과 가져오기
        // (주의: 네트워크 상황에 따라 몇 초 정도 소요될 수 있습니다)
        String aiResult = consultingService.getRecommendation(loginUser);

        // 4. 결과 데이터와 유저 정보를 모델에 담기
        model.addAttribute("aiResult", aiResult);
        model.addAttribute("user", loginUser);

        // 5. 결과 화면 JSP로 이동
        return "consulting/result";
    }
}