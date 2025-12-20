package com.example.donjoogga.controller;

import com.example.donjoogga.service.ScholarshipService;
import com.example.donjoogga.vo.Scholarship;
import com.example.donjoogga.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class HomeController {

    private final int PAGE_SIZE = 10;

    @Autowired
    private ScholarshipService scholarshipService;

    @GetMapping("/")
    public String home(Model model) {
        return "board/index";
    }

    @RequestMapping("list.do")
    public String getScholarshipList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        int totalCount = scholarshipService.getTotalCount(keyword);
        int startRow = (currentPage - 1) * PAGE_SIZE;

        List<Scholarship> scholarshipList = scholarshipService.getPagedScholarshipList(startRow, PAGE_SIZE, keyword);

        model.addAttribute("scholarshipList", scholarshipList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", PAGE_SIZE);
        model.addAttribute("keyword", keyword); // 검색어 유지 위해 전달

        return "board/list";
    }

    @RequestMapping("detail.do")
    public String getScholarshipDetail(@RequestParam("id") Long id, Model model) {

        try {
            // 1. Service를 호출하여 단일 장학금 정보 조회 (DB, CSV 통합)
            Scholarship scholarship = scholarshipService.getScholarshipDetail(id);

            if (scholarship == null) {
                model.addAttribute("errorMessage", "요청하신 장학금 정보를 찾을 수 없습니다.");
                return "errorPage"; // errorPage.jsp로 이동 가정
            }

            model.addAttribute("scholarship", scholarship);

            return "board/detail"; // detail.jsp로 이동

        } catch (Exception e) {
            System.err.println("장학금 상세 조회 중 오류 발생: " + e.getMessage());
            model.addAttribute("errorMessage", "장학금 상세 정보를 불러오는 중 오류가 발생했습니다.");
            return "errorPage";
        }
    }

    @RequestMapping("recommend.do")
    public String getRecommendList(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");

        // 로그인 체크
        if (loginUser == null) {
            // 메시지와 함께 리다이렉트하거나 로그인 페이지로 보냄
            return "redirect:/login";
        }

        List<Scholarship> recommendList = scholarshipService.getRecommendedScholarships(loginUser);
        model.addAttribute("recommendList", recommendList);
        model.addAttribute("user", loginUser);

        return "board/recommendList";
    }

    @RequestMapping("notification.do")
    public String notificationPage(HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login"; // 로그인 체크
        }

        // 마감일순으로 정렬된 찜 목록 가져오기
        List<Scholarship> scrapList = scholarshipService.getNotificationList(loginUser.getUserId());
        model.addAttribute("scrapList", scrapList);

        return "board/notification"; // notification.jsp로 이동
    }
}