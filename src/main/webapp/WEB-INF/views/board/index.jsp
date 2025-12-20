<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>돈주까 - 대학생 맞춤형 장학금 & 컨설팅 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; padding-top: 60px !important; }

        /* 1. 히어로 섹션 (복구된 검색 디자인) */
        .hero-section {
            background: linear-gradient(rgba(13, 110, 253, 0.8), rgba(13, 110, 253, 0.6)),
            url('https://images.unsplash.com/photo-1523050854056-8ad46447c7ae?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover; background-position: center;
            padding: 120px 0; color: white; text-align: center;
        }
        .search-box-wrapper { max-width: 800px; margin: 0 auto; }
        .input-group-custom {
            background: white; border-radius: 50px; padding: 8px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .input-group-custom input { border: none; box-shadow: none !important; font-size: 1.1rem; }
        .input-group-custom .btn-search { border-radius: 40px !important; padding: 12px 40px; font-weight: 700; }

        /* 2. AI 맞춤형 매칭 배너 스타일 */
        .recommend-banner {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            border-radius: 30px; border-left: 8px solid #ffc107;
            position: relative; overflow: hidden;
        }
        .hover-scale { transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .hover-scale:hover { transform: scale(1.05); }
        .bg-icon-deco { position: absolute; right: -5%; bottom: -20%; opacity: 0.1; font-size: 200px; color: white; transform: rotate(-15deg); }

        /* 3. 공통 카드 스타일 */
        .service-card {
            border: none; border-radius: 20px; transition: all 0.3s;
            cursor: pointer; background: white;
        }
        .service-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<jsp:include page="../common/top.jsp" />

<header class="hero-section">
    <div class="container">
        <h1 class="display-4 fw-bold mb-3">내게 딱 맞는 장학금, <span class="text-warning">돈주까</span></h1>
        <p class="lead mb-5 opacity-75">정보 불균형 없는 대학 생활을 시작하세요.</p>

        <div class="search-box-wrapper">
            <form action="${pageContext.request.contextPath}/list.do" method="get">
                <div class="input-group input-group-custom d-flex">
                        <span class="input-group-text bg-transparent border-0 ps-4">
                            <i class="fa-solid fa-magnifying-glass text-primary fs-5"></i>
                        </span>
                    <input type="text" name="keyword" class="form-control" placeholder="장학금 명칭, 지역, 기관명을 입력하세요">
                    <button class="btn btn-primary btn-search" type="submit">검색하기</button>
                </div>
            </form>
        </div>
    </div>
</header>

<section class="py-5 bg-white border-bottom">
    <div class="container">
        <h3 class="fw-bold mb-4">🔍 스마트 필터링</h3>
        <div class="row g-3">
            <c:set var="filters" value="대학생,신입생,소득분위,지역연고" />
            <c:forTokens items="${filters}" delims="," var="filter">
                <div class="col-6 col-md-3">
                    <div class="card h-100 service-card shadow-sm p-4 text-center"
                         onclick="location.href='${pageContext.request.contextPath}/list.do?keyword=${filter}'">
                        <c:choose>
                            <c:when test="${filter == '대학생'}"><i class="fa-solid fa-graduation-cap fa-2x text-primary mb-2"></i></c:when>
                            <c:when test="${filter == '신입생'}"><i class="fa-solid fa-user-plus fa-2x text-success mb-2"></i></c:when>
                            <c:when test="${filter == '소득분위'}"><i class="fa-solid fa-coins fa-2x text-warning mb-2"></i></c:when>
                            <c:otherwise><i class="fa-solid fa-map-location-dot fa-2x text-danger mb-2"></i></c:otherwise>
                        </c:choose>
                        <p class="mb-0 fw-bold">${filter}</p>
                    </div>
                </div>
            </c:forTokens>
        </div>
    </div>
</section>

<section class="py-5">
    <div class="container">
        <div class="recommend-banner shadow-lg p-5 d-flex flex-column flex-lg-row align-items-center justify-content-between">
            <i class="fa-solid fa-magnifying-glass-chart bg-icon-deco"></i>

            <div class="text-white text-center text-lg-start mb-4 mb-lg-0" style="position: relative; z-index: 1;">
                <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-2 mb-3">
                    <span class="badge rounded-pill bg-white bg-opacity-25 px-3 py-2">학과 분석</span>
                    <span class="badge rounded-pill bg-white bg-opacity-25 px-3 py-2">성적 매칭</span>
                    <span class="badge rounded-pill bg-white bg-opacity-25 px-3 py-2">소득구간 분석</span>
                </div>
                <h2 class="display-6 fw-bold mb-3">
                    ✨ <span class="text-warning">매칭 점수</span>로 보는 내 장학금
                </h2>
                <p class="opacity-75 fs-5 mb-0 fw-light">
                    <strong>${not empty loginUser ? loginUser.userId : '유저'}</strong>님의 프로필을 분석하여<br class="d-none d-lg-block">
                    합격 가능성이 가장 높은 장학금만 골라드립니다.
                </p>
            </div>

            <div style="position: relative; z-index: 1;">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <a href="${pageContext.request.contextPath}/recommend.do"
                           class="btn btn-warning btn-lg fw-bold px-5 py-3 rounded-pill shadow hover-scale" style="color: #052c65;">
                            점수 확인하기 <i class="fa-solid fa-rocket ms-2"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button onclick="checkLogin();"
                                class="btn btn-warning btn-lg fw-bold px-5 py-3 rounded-pill shadow hover-scale" style="color: #052c65;">
                            로그인 후 시작하기 <i class="fa-solid fa-lock-open ms-2"></i>
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<section class="py-5 bg-white">
    <div class="container">
        <h3 class="fw-bold mb-4">🚀 다음같은 서비스도 제공하고 있어요</h3>
        <div class="row g-4 text-center">
            <div class="col-md-6">
                <div class="card service-card p-5 border shadow-sm"
                     onclick="location.href='${pageContext.request.contextPath}/consulting.do'">
                    <i class="fa-solid fa-chart-line fa-3x text-primary mb-3"></i>
                    <h4 class="fw-bold">맞춤형 스펙 컨설팅</h4>
                    <p class="text-muted">내 목표 기업과 전공에 맞는 스펙을 분석하고<br>최적의 활동 로드맵을 제안합니다.</p>
                    <span class="badge bg-primary-subtle text-primary w-50 mx-auto py-2">준비 중</span>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card service-card p-5 border shadow-sm"
                     onclick="location.href='${pageContext.request.contextPath}/notification.do'">
                    <i class="fa-solid fa-bell fa-3x text-warning mb-3"></i>
                    <h4 class="fw-bold">마감일 알림 서비스</h4>
                    <p class="text-muted">관심 장학금을 놓치지 않도록<br>여러분들의 장학금 마감일을 나열해줍니다.</p>
                    <span class="badge bg-warning-subtle text-warning w-50 mx-auto py-2">준비 중</span>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // 로그인 여부 체크 스크립트
    function checkLogin() {
        if(confirm("맞춤 매칭 서비스는 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/login";
        }
    }
</script>

<jsp:include page="../common/bottom.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>