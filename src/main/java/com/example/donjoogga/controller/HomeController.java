package com.example.donjoogga.controller;

import com.example.donjoogga.service.ScholarshipService; // 이제 경로 맞음!
import com.example.donjoogga.vo.Scholarship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ScholarshipService scholarshipService;

    @GetMapping("/")
    public String home(Model model) {
        return "index";
    }

    @GetMapping({"/scholarships"})
    public String getScholarshipList(Model model) {

        try {
            // 1. Service를 호출하여 통합된 장학금 리스트 가져오기
            // 이 메서드는 Admin 등록 정보와 동기화된 재단 정보를 모두 DB에서 조회합니다.
            List<Scholarship> scholarshipList = scholarshipService.getAllScholarshipList();

            // 2. 뷰(JSP)에서 사용할 이름("scholarships")으로 리스트를 Model에 담기
            model.addAttribute("scholarships", scholarshipList);

            // 3. Thymeleaf/JSP 뷰 이름 반환
            // Spring Boot 설정에 따라 /WEB-INF/views/list.jsp를 찾게 됩니다.
            return "list";

        } catch (Exception e) {
            // 로깅 처리 (에러가 발생하면 서버 로그에 기록)
            System.err.println("장학금 목록 조회 중 오류 발생: " + e.getMessage());

            // 에러 페이지나 빈 리스트를 전달하여 뷰를 보여줍니다.
            model.addAttribute("errorMessage", "장학금 정보를 불러오는 데 실패했습니다.");
            return "errorPage"; // 또는 "list"
        }
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