package com.example.donjoogga.controller;

import com.example.donjoogga.service.UserService;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
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

        if (loginUser == null) {
            System.out.println("로그인 실패");
            return "redirect:/login?error";
        }


        // 관리자 계정 체크
        if(loginUser.getUserId().equals("admin") && loginUser.getPassword().equals("admin1234") ){
            session.setAttribute("admin", loginUser); // 관리자 세션 설정
            System.out.println("관리자 로그인 성공: " + loginUser.getUserId());
            return "redirect:/list.do"; // 요청하신대로 /list.do로 이동
        }
        else { // 일반 유저
            session.setAttribute("loginUser", loginUser);
            System.out.println("일반 사용자 로그인 성공: " + loginUser.getUserId());
            return "redirect:/"; // 메인 페이지로 이동
        }
    }

}