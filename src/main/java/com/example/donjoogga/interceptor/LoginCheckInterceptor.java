package com.example.donjoogga.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
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

        // 1. 로그인 없이도 접근 가능한 "화이트리스트" 경로 체크
        // 회원가입(/join), 로그인(/login), 메인(/), 정적 리소스(/resources)는 통과시켜야 합니다.
        if (requestURI.equals(contextPath + "/") ||
                requestURI.equals(contextPath + "/login") ||
                requestURI.equals(contextPath + "/join") ||
                requestURI.startsWith(contextPath + "/resources")) {
            return true;
        }

        // 2. 로그인 정보가 아예 없는 경우 (화이트리스트 외의 경로 접근 시)
        if(obj1 == null && obj2 == null){
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        // 3. 관리자 전용 경로(/admin/**) 보안 체크
        if (requestURI.startsWith(contextPath + "/admin")) {
            // 관리자 세션이 없으면 메인으로 리다이렉트
            if (obj2 == null) {
                response.sendRedirect(contextPath + "/");
                return false;
            }
        }

        return true;
    }
}