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

        // 로그인 정보가 없으면 (일반 사용자도 아니고, 관리자도 아니면)
        if(obj1 == null && obj2 == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        if (requestURI.startsWith(contextPath + "/admin")) {
            // /admin/** 경로에 접근했는데, admin 세션이 없다면 (즉, 일반 유저 세션만 있다면)
            if (obj2 == null) {
                // 일반 사용자에게는 접근 권한이 없으므로 홈페이지로 리다이렉트
                response.sendRedirect(contextPath + "/");
                return false;
            }
            // admin 세션이 있다면 (관리자인 경우) 통과
        }

        return HandlerInterceptor.super.preHandle(request, response, handler);
    }
}
