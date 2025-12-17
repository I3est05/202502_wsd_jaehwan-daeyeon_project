package com.example.donjoogga.controller;

import com.example.donjoogga.mapper.ScholarshipMapper;
import com.example.donjoogga.service.UserService;
import com.example.donjoogga.service.MyScholarshipService; // 추가
import com.example.donjoogga.mapper.MyScholarshipMapper; // 추가
import com.example.donjoogga.vo.User;
import com.example.donjoogga.vo.Scholarship; // 추가
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List; // 추가

@Controller
public class MyPageController {

    @Autowired
    private UserService userService;

    @Autowired
    private MyScholarshipMapper myScholarshipMapper; // ✅ Mapper 주입 확인

    @Autowired
    private ScholarshipMapper scholarshipMapper;
    // ✅ 중복되었던 myPage 메소드를 하나로 통합했습니다.
    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login?required";
        }

        // ✅ 찜한 리스트 가져오기 (Scholar 테이블과 JOIN된 데이터)
        // loginUser.getUserId()의 리턴 타입이 String인지 int인지 확인하세요.
        List<Scholarship> scrapList = myScholarshipMapper.selectMyScrapList(loginUser.getUserId());

        model.addAttribute("user", loginUser);
        model.addAttribute("scrapList", scrapList); // JSP에서 사용할 이름

        return "user/mypage";
    }

    // ScholarshipController.java 또는 관련 컨트롤러
    @GetMapping("/detail.do")
    public String scholarshipDetail(@RequestParam("id") Long id, HttpSession session, Model model) {
        // 1. 장학금 상세 정보 조회 (기존 로직)
        Scholarship scholarship = scholarshipMapper.selectScholarshipById(id);

        // 2. 현재 로그인한 유저가 이 장학금을 찜했는지 확인하는 로직 추가
        User loginUser = (User) session.getAttribute("loginUser");
        boolean isScrapped = false;

        if (loginUser != null) {
            // 매퍼를 통해 DB에 해당 유저와 장학금 ID 조합이 있는지 확인
            // 결과가 1이면 true, 0이면 false
            int count = myScholarshipMapper.checkScrapped(loginUser.getUserId(), id);
            isScrapped = (count > 0);
        }

        model.addAttribute("scholarship", scholarship);
        model.addAttribute("isScrapped", isScrapped); // ✅ 이 값이 JSP의 하트 모양을 결정합니다.

        return "board/detail"; // 상세 페이지 JSP 경로
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

        if (updatedUser.getUserId() == null || updatedUser.getUserId().isEmpty()) {
            rttr.addFlashAttribute("errorMsg", "잘못된 접근입니다.");
            return "redirect:/mypage";
        }

        // 1. DB 업데이트 수행
        userService.updateUser(updatedUser);

        // 2. 최신 정보(날짜 포함) 재조회하여 세션 갱신
        User freshUser = userService.findById(updatedUser.getUserId());
        session.setAttribute("loginUser", freshUser);

        rttr.addFlashAttribute("message", "정보가 성공적으로 수정되었습니다.");
        return "redirect:/mypage";
    }
}