package com.example.donjoogga.controller;


import com.example.donjoogga.service.ScholarshipService;
import com.example.donjoogga.vo.Scholarship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final int PAGE_SIZE = 15;

    @Autowired
    private ScholarshipService scholarshipService;

    // 1. [R] 관리자 목록 페이지 (DB 데이터만)
    @GetMapping("/manage") // ⬅
    public String adminManageList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            Model model) {
        int totalCount = scholarshipService.getTotalCountDBOnly(); // DB 전용 TotalCount 필요
        int startRow = (currentPage - 1) * PAGE_SIZE;

        // DB 전용 목록 조회 메서드 사용 (필요시 ScholarshipService에 추가)
        List<Scholarship> dbScholarshipList = scholarshipService.getPagedScholarshipListDBOnly(startRow, PAGE_SIZE);

        model.addAttribute("scholarshipList", dbScholarshipList);
        return "admin/adminpage";
    }

    // 2. [C] 장학금 등록 폼
    @RequestMapping(value = "/create", method = RequestMethod.GET)
    public String add(){
        return "/admin/scholarshipCreate";
    }

    @RequestMapping(value = "/createok", method = RequestMethod.POST)
    public String addOk(Scholarship vo){
       scholarshipService.addScholarship(vo);
        return "redirect:/admin/manage";
    }


    @RequestMapping(value = "/update/{id}", method = RequestMethod.GET)
    public String editpost(@PathVariable("id") int id, Model model){
        Scholarship vo = scholarshipService.getScholarshipDetail((long) id);
        model.addAttribute("scholarship", vo);
        return "/admin/scholarshipUpdate";
    }

    @RequestMapping(value = "/updateok/{id}", method = RequestMethod.POST)
    public String editOk(Scholarship vo){
        scholarshipService.modifyScholarship(vo);
        return "redirect:/admin/manage";
    }

    // 6. [D] 장학금 삭제 처리
    @PostMapping("/remove") //
    public String removeScholarship(@RequestParam("id") Long id) {
        scholarshipService.removeScholarship(id);
        return "redirect:/admin/manage";
    }
}