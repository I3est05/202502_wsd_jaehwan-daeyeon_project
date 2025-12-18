package com.example.donjoogga.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Object obj1 = session.getAttribute("loginUser");
        Object obj2 = session.getAttribute("admin");

        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // ✅ 1. 인터셉터 검사에서 제외할 경로 정의
        // 로그인 페이지, 회원가입 페이지, 메인 페이지, 정적 리소스(CSS/JS) 등
        if (requestURI.equals(contextPath + "/login") ||
                requestURI.equals(contextPath + "/join") ||
                requestURI.equals(contextPath + "/") ||
                requestURI.startsWith(contextPath + "/resources")) {
            return true; // 검사하지 않고 통과
        }

        // 2. 로그인 정보가 없으면 리다이렉트
        if(obj1 == null && obj2 == null){
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        // ... (관리자 권한 체크 로직은 그대로 유지)
        if (requestURI.startsWith(contextPath + "/admin")) {
            if (obj2 == null) {
                response.sendRedirect(contextPath + "/");
                return false;
            }
        }

        return true;
    }
}
