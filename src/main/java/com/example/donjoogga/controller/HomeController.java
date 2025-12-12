package com.example.donjoogga.controller;

import com.example.donjoogga.service.ScholarshipService;
import com.example.donjoogga.vo.Scholarship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
            Model model) {

        // 1. 전체 장학금 개수 조회 (DB + API 통합 개수)
        int totalCount = scholarshipService.getTotalCount();

        // 2. 현재 페이지의 시작 행 (Row) 계산
        // 예: 1페이지(0~9), 2페이지(10~19)
        int startRow = (currentPage - 1) * PAGE_SIZE;

        // 3. 페이지네이션된 장학금 목록 조회
        List<Scholarship> scholarshipList = scholarshipService.getPagedScholarshipList(startRow, PAGE_SIZE);

        // 4. 뷰(JSP)에 필요한 데이터 전달
        model.addAttribute("scholarshipList", scholarshipList);

        // 페이징 처리를 위해 JSP에 전달하는 정보
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("pageSize", PAGE_SIZE); // 10

        // InternalResourceViewResolver에 의해 "/WEB-INF/views/board/list.jsp"가 호출됩니다.
        return "board/list";
    }

    @GetMapping("/scholarships/{id}/detail")
    public String getScholarshipDetail(@PathVariable("id") Long id, Model model) {

        try {
            // 1. Service를 호출하여 단일 장학금 정보 조회
            Scholarship scholarship = scholarshipService.getScholarshipDetail(id);

            if (scholarship == null) {
                // 장학금 정보가 없을 경우 404 처리 또는 목록으로 리다이렉트
                model.addAttribute("errorMessage", "요청하신 장학금 정보를 찾을 수 없습니다.");
                return "errorPage"; // errorPage.jsp로 이동 가정
            }

            // 2. 뷰(JSP)에서 사용할 이름("scholarship")으로 객체를 Model에 담기
            model.addAttribute("scholarship", scholarship);

            // 3. 뷰 이름 반환
            return "detail"; // detail.jsp로 이동

        } catch (Exception e) {
            System.err.println("장학금 상세 조회 중 오류 발생: " + e.getMessage());
            model.addAttribute("errorMessage", "서버 오류로 상세 정보를 불러올 수 없습니다.");
            return "errorPage";
        }
    }
}