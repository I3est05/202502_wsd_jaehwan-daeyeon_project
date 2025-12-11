package com.example.donjoogga.controller;

import com.example.donjoogga.service.ScholarshipService; // 이제 경로 맞음!
import com.example.donjoogga.vo.Scholarship;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ScholarshipService scholarshipService;

    @GetMapping("/")
    public String home(Model model) {
        return "index";
    }
}