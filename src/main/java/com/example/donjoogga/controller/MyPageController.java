package com.example.donjoogga.controller;

import com.example.donjoogga.vo.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import javax.servlet.http.HttpSession;

@Controller
public class MyPageController {

    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {
        // 1. 세션에서 로그인 사용자 정보(loginUser)를 가져옵니다.
        User loginUser = (User) session.getAttribute("loginUser");

        // 2. 로그인 상태가 아니면 로그인 페이지로 리다이렉트 (보안)
        if (loginUser == null) {
            return "redirect:/login?required";
        }

        // 3. 모델에 사용자 정보를 담아서 JSP로 전달합니다.
        model.addAttribute("user", loginUser);

        return "user/mypage"; // mypage.jsp로 이동
    }
}