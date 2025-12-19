<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>돈주까 - 대학생 맞춤형 장학금 & 컨설팅 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            padding-top: 60px !important;
        }
        .hero-section {
            background: linear-gradient(rgba(13, 110, 253, 0.8), rgba(13, 110, 253, 0.6)), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover; background-position: center; color: white; padding: 100px 0; text-align: center; margin-bottom: 50px;
        }
        .hero-title { font-size: 3rem; font-weight: 700; margin-bottom: 20px; }
        .hero-subtitle { font-size: 1.2rem; margin-bottom: 40px; opacity: 0.9; }
        .search-box { background: white; padding: 10px; border-radius: 50px; display: flex; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .search-input { border: none; flex-grow: 1; padding: 10px 20px; outline: none; border-radius: 50px; }
        .search-btn { border-radius: 40px; padding: 10px 30px; font-weight: 600; }
        .feature-card { border: none; border-radius: 15px; padding: 30px; text-align: center; transition: transform 0.3s ease; background: white; height: 100%; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .feature-card:hover { transform: translateY(-10px); }
        .icon-box { font-size: 3rem; color: #0d6efd; margin-bottom: 20px; }
        .stats-section { background-color: white; padding: 60px 0; margin-top: 50px; }
        footer { background-color: #343a40; color: #ccc; padding: 30px 0; margin-top: 80px; }
    </style>
</head>
<body>
<jsp:include page="../common/top.jsp" />
<section class="hero-section">
    <div class="container">
        <c:if test="${not empty sessionScope.loginUser}">
            <c:choose>
                <c:when test="${sessionScope.loginUser.userId.equals('admin')}">
                    <h3 class="mb-3 text-warning">관리자 전용 페이지 입니다!</h3>
                </c:when>
                <c:otherwise>
                    <h3 class="mb-3 text-warning">반갑습니다, ${sessionScope.loginUser.userId}님!</h3>
                </c:otherwise>
            </c:choose>
        </c:if>

        <h1 class="hero-title">놓친 장학금, <br>우리가 찾아 드릴게요</h1>
        <p class="hero-subtitle">
            소득분위, 학점, 전공만 입력하세요.<br>
            당신에게 딱 맞는 지원금과 스펙 가이드를 제공합니다.
        </p>
        <div class="search-box">
            <input type="text" class="search-input" placeholder="관심있는 장학금 키워드 (예: 이공계, 창업, 생활비)">
            <button class="btn btn-primary search-btn">검색</button>
        </div>
    </div>
</section>

<section class="container mb-5">
    <div class="text-center mb-5">
        <h2 class="fw-bold">왜 '돈주까'를 써야 할까요?</h2>
        <p class="text-muted">단순 검색을 넘어 합격까지 함께합니다.</p>
    </div>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="feature-card">
                <div class="icon-box"><i class="fa-solid fa-filter"></i></div>
                <h4>스마트 필터링</h4>
                <p class="text-muted">내 소득분위(0~10), 학점, 전공을 분석해<br>신청 가능한 장학금만 보여줍니다.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card border-primary border-2">
                <div class="icon-box"><i class="fa-solid fa-chart-line"></i></div>
                <h4 class="text-primary fw-bold">맞춤형 스펙 컨설팅</h4>
                <p class="text-muted">"어떤 활동이 부족할까?"<br>이력을 분석해 합격 확률을 높이는<br>가이드를 제공합니다.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="feature-card">
                <div class="icon-box"><i class="fa-regular fa-bell"></i></div>
                <h4>마감일 알림</h4>
                <p class="text-muted">바쁜 학교 생활 중에도<br>신청 기간을 놓치지 않게<br>알림을 발송해 드립니다.</p>
            </div>
        </div>
    </div>
</section>

<section class="stats-section">
    <div class="container">
        <h3 class="fw-bold mb-4">🔥 지금 주목해야 할 장학금</h3>
        <div class="list-group">
            <a href="#" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center p-4">
                <div>
                    <span class="badge bg-primary mb-2">국가</span>
                    <h5 class="mb-1 fw-bold">2025년 1학기 국가장학금 1차 신청</h5>
                    <p class="mb-0 text-muted small">한국장학재단 | 소득분위 8구간 이하</p>
                </div>
                <span class="text-danger fw-bold">D-5</span>
            </a>
            <a href="#" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center p-4">
                <div>
                    <span class="badge bg-success mb-2">기업</span>
                    <h5 class="mb-1 fw-bold">드림스폰 청년 희망 장학금</h5>
                    <p class="mb-0 text-muted small">드림스폰 재단 | 전공 무관, 리더십 활동 우수자</p>
                </div>
                <span class="text-danger fw-bold">D-12</span>
            </a>
        </div>
    </div>
</section>

<footer>
    <jsp:include page="../common/bottom.jsp" />
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>