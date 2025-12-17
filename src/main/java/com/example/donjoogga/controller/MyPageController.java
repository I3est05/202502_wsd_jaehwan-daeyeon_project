package com.example.donjoogga.controller;

import com.example.donjoogga.mapper.ScholarshipMapper;
import com.example.donjoogga.service.ScholarshipService;
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
    private ScholarshipService scholarshipService;
    // ✅ 중복되었던 myPage 메소드를 하나로 통합했습니다.
    @GetMapping("/mypage")
    public String myPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login?required";
        }

        // 1. DB에서 찜 목록을 가져옵니다 (LEFT JOIN 쿼리 결과)
        List<Scholarship> scrapList = myScholarshipMapper.selectMyScrapList(loginUser.getUserId());

        // 2. ✅ CSV 데이터 정보 채우기 로직 추가
        if (scrapList != null) {
            for (Scholarship s : scrapList) {
                // Scholar 테이블에 없는 ID(예: 21)는 JOIN 결과 title이 NULL입니다.
                if (s.getTitle() == null) {
                    // ScholarshipService의 getScholarshipDetail을 사용하여 CSV에서 정보를 읽어옵니다.
                    // s.getRefId() 또는 s.getScholarId() 중 Mapper에서 ID를 담은 필드명을 사용하세요.
                    Scholarship apiData = scholarshipService.getScholarshipDetail(s.getRefId());

                    if (apiData != null) {
                        s.setTitle(apiData.getTitle());

                        // ✅ setInstitution 대신 setOrganization을 사용해야 합니다!
                        s.setOrganization(apiData.getOrganization());

                        s.setCategory(apiData.getCategory());
                        // 추가로 마감일 등도 넣고 싶다면
                        s.setDeadline(apiData.getDeadline());
                    }
                }
            }
        }

        model.addAttribute("user", loginUser);
        model.addAttribute("scrapList", scrapList);

        return "user/mypage";
    }

    // ScholarshipController.java 또는 관련 컨트롤러
    @GetMapping("/detail.do")
    public String scholarshipDetail(@RequestParam("id") Long id, HttpSession session, Model model) {

        // ✅ 핵심 수정: 서비스의 메서드를 호출하여 DB와 CSV 모두에서 찾습니다.
        Scholarship scholarship = scholarshipService.getScholarshipDetail(id);

        if (scholarship == null) {
            return "redirect:/list.do?error=notfound";
        }

        // 찜 상태 확인 로직 (기존과 동일)
        User loginUser = (User) session.getAttribute("loginUser");
        boolean isScrapped = false;
        if (loginUser != null) {
            // CSV 데이터의 id도 여기서 scholarId로 처리됩니다.
            int count = myScholarshipMapper.checkScrapped(loginUser.getUserId(), id);
            isScrapped = (count > 0);
        }

        model.addAttribute("scholarship", scholarship);
        model.addAttribute("isScrapped", isScrapped);

        return "board/detail"; // 실제 detail.jsp가 있는 경로로 설정
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