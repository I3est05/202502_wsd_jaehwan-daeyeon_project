package com.example.donjoogga.controller;

import com.example.donjoogga.service.UserService;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
public class MyPageController {

    @Autowired
    private UserService userService;

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

    @GetMapping("/mypage/edit")
    public String editPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login?required";
        }
        model.addAttribute("user", loginUser);

        return "user/myedit";
    }
    @PostMapping("/mypage/edit")
    public String editProcess(User updatedUser, HttpSession session, RedirectAttributes rttr) {
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login?required";
        }

        // 1. 필수값 체크: userId (WHERE 조건)가 Hidden 필드로 넘어왔는지 확인
        if (updatedUser.getUserId() == null || updatedUser.getUserId().isEmpty()) {
            rttr.addFlashAttribute("errorMsg", "잘못된 접근입니다. 사용자 ID가 누락되었습니다.");
            return "redirect:/mypage";
        }

        // 2. DB 업데이트 수행
        userService.updateUser(updatedUser);

        // 3. 세션 정보 갱신: 마이페이지에 최신 정보를 보여주기 위해 세션 업데이트
        session.setAttribute("loginUser", updatedUser);

        rttr.addFlashAttribute("message", "정보가 성공적으로 수정되었습니다.");

        return "redirect:/mypage";
    }
}