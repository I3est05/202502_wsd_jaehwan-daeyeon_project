<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* Nav Bar 관련 스타일 */
    .navbar {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        background-color: #fff;
    }
    .navbar-brand {
        font-weight: 700;
        color: #0d6efd !important;
        font-size: 1.5rem;
    }
    .nav-link {
        font-weight: 500;
        color: #333;
    }
</style>

<%-- 중략 (스타일 부분) --%>

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>"><i class="fa-solid fa-graduation-cap"></i> 돈주까</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="<c:url value='/list.do'/>">장학금 찾기</a></li>

                <c:choose>
                    <c:when test="${sessionScope.loginUser != null && sessionScope.admin == null}">
                        <li class="nav-item"><a class="nav-link" href="<c:url value='#'/>">컨설팅 리포트</a></li>
                    </c:when>
                </c:choose>

                <c:choose>
                    <%-- 1. 관리자 세션 --%>
                    <c:when test="${sessionScope.loginUser.userId.equals('admin')}">
                        <li class="nav-item ms-3">
                            <a href="<c:url value='/admin/manage'/>" class="nav-link fw-bold text-primary">
                                <i class="fa-solid fa-user-circle"></i> 관리자 페이지
                            </a>
                        </li>
                        <li class="nav-item ms-3">
                            <a href="<c:url value='/mypage'/>" class="nav-link fw-bold text-primary">
                                <i class="fa-solid fa-user-circle"></i> ${sessionScope.loginUser.userId}님의 마이페이지
                            </a>
                        </li>
                        <li class="nav-item ms-2">
                            <a href="<c:url value='/logout'/>" class="btn btn-sm btn-secondary rounded-pill px-3">로그아웃</a>
                        </li>
                    </c:when>

                    <%-- 2. 일반 사용자 세션 --%>
                    <c:when test="${sessionScope.loginUser != null}">
                        <li class="nav-item ms-3">
                            <a href="<c:url value='/mypage'/>" class="nav-link fw-bold text-primary">
                                <i class="fa-solid fa-user-circle"></i> ${sessionScope.loginUser.userId}님의 마이페이지
                            </a>
                        </li>
                        <li class="nav-item ms-2">
                            <a href="<c:url value='/logout'/>" class="btn btn-sm btn-secondary rounded-pill px-3">로그아웃</a>
                        </li>
                    </c:when>

                    <%-- 3. 로그아웃 상태 - 로그인/회원가입 버튼 수정 --%>
                    <c:otherwise>
                        <li class="nav-item ms-3">
                            <a href="<c:url value='/login'/>" class="btn btn-outline-primary rounded-pill px-4">로그인</a>
                        </li>
                        <li class="nav-item ms-2">
                            <a href="<c:url value='/join'/>" class="btn btn-primary rounded-pill px-4">회원가입</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>