package com.example.donjoogga.controller;

import com.example.donjoogga.service.UserService;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // --- 페이지 이동 ---
    @GetMapping("/login")
    public String loginPage() { return "user/login"; }

    @GetMapping("/join")
    public String joinPage() { return "user/join"; }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 삭제 (로그아웃)
        return "redirect:/";
    }

    // --- 실제 기능 처리 (POST) ---

    // 1. 회원가입 실행
    @PostMapping("/join")
    public String joinProcess(User user) {
        // user 객체에 jsp에서 입력한 (이메일, 비번, 이름, 학점 등)이 자동으로 담겨옴
        System.out.println("회원가입 요청: " + user);
        userService.join(user);
        return "redirect:/login"; // 가입 성공하면 로그인 페이지로 이동
    }

    // 2. 로그인 실행
    @PostMapping("/login")
    public String loginProcess(@RequestParam("userId") String userId,
                               @RequestParam("password") String password,
                               HttpSession session) {

        User loginUser = userService.login(userId, password);

        if (loginUser != null) {
            // 성공: 세션에 유저 정보 담고 메인으로
            session.setAttribute("loginUser", loginUser);
            System.out.println("로그인 성공: " + loginUser.getUserId());
            return "redirect:/";
        } else {
            // 실패: 다시 로그인 페이지로 (에러 표시용 파라미터 추가)
            System.out.println("로그인 실패");
            return "redirect:/login?error";
        }
    }
}