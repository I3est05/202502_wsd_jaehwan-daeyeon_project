package com.example.donjoogga.interceptor;

import com.example.donjoogga.vo.User;
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginCheckInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // 1. 화이트리스트: 로그인 안 해도 들어갈 수 있는 곳 (메인, 로그인, 회원가입, 리소스)
        if (requestURI.equals(contextPath + "/") ||
                requestURI.equals(contextPath + "/login") ||
                requestURI.equals(contextPath + "/join") ||
                requestURI.startsWith(contextPath + "/resources")) {
            return true;
        }

        // 2. 로그인 여부 체크 (세션에 loginUser가 아예 없으면 비로그인 상태)
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 비로그인 상태에서 관리자나 마이페이지 등을 가려고 하면 무조건 차단
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        // 3. 관리자 경로(/admin/**) 보안 체크 (로그인은 했지만 admin이 아닌 경우)
        if (requestURI.startsWith(contextPath + "/admin")) {
            // 아이디가 "admin"이 아니면 메인으로 튕김
            if (!"admin".equals(loginUser.getUserId())) {
                response.sendRedirect(contextPath + "/");
                return false;
            }
        }

        // 모든 관문을 통과하면 정상 진행
        return true;
    }
}