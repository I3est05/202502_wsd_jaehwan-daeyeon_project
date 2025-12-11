package com.example;

import com.example.bean.ScholarVO;
import com.example.dao.ScholarshipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class HomeController {
    @Autowired
    private ScholarshipService scholarshipService;

    @RequestMapping("/")
    public String home(){
        return "home";
    }
}
