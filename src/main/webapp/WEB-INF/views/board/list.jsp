<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장학금 찾기 - 돈주까 (DONJOOGGA)</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* 기본 스타일 유지 */
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,0.1); background-color: #fff; }
        .navbar-brand { font-weight: 700; color: #0d6efd !important; font-size: 1.5rem; }

        /* 카드 스타일 - 드림스폰 벤치마킹 */
        .scholarship-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .scholarship-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
        }

        /* 카드 헤더 스타일 */
        .card-header-custom {
            background-color: #f0f8ff; /* 연한 하늘색 배경 */
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        /* 마감일 강조 */
        .deadline-highlight {
            font-size: 1rem;
            font-weight: 700;
            color: #dc3545; /* Bootstrap Red */
            border: 1px solid #dc3545;
            padding: 3px 8px;
            border-radius: 5px;
        }

        /* 금액 강조 */
        .amount-highlight {
            font-size: 1.3rem;
            font-weight: 700;
            color: #198754; /* Success Green */
            margin-top: 10px;
        }

        /* 버튼 스타일 */
        .btn-action-group {
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
    </style>
</head>
<body>

<jsp:include page="../common/top.jsp" />

<section class="container" style="padding-top: 100px; padding-bottom: 50px;">
    <h2 class="fw-bold mb-3"><i class="fa-solid fa-coins me-2"></i> 장학금 전체 목록</h2>
    <p class="text-muted mb-4">나에게 맞는 장학금을 찾아보고, 관심 목록에 담아보세요!</p>

    <div class="row g-3 mb-5 p-3 bg-white rounded shadow-sm">
        <div class="col-md-5">
            <input type="text" class="form-control" placeholder="장학금명 또는 기관명 검색">
        </div>
        <div class="col-md-3">
            <select class="form-select">
                <option selected>분류 전체</option>
                <option value="소득">소득 연계형</option>
                <option value="성적">성적 우수형</option>
                <option value="특기">특기/활동형</option>
            </select>
        </div>
        <div class="col-md-2">
            <select class="form-select">
                <option selected>마감 임박순</option>
                <option value="amount">지원 금액순</option>
                <option value="newest">최신 등록순</option>
            </select>
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary w-100"><i class="fa-solid fa-search"></i> 검색</button>
        </div>
    </div>

    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty scholarships}">
                <c:forEach var="item" items="${scholarships}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card scholarship-card">

                            <div class="card-header-custom d-flex justify-content-between align-items-center">
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${item.category eq '소득'}">bg-primary</c:when>
                                        <c:when test="${item.category eq '성적'}">bg-warning text-dark</c:when>
                                        <c:otherwise>bg-info text-dark</c:otherwise>
                                    </c:choose>
                                    p-2 rounded-pill fw-bold
                                ">${item.category}</span>
                                <span class="badge bg-secondary-subtle text-secondary">${item.sourceType}</span>
                            </div>

                            <div class="card-body d-flex flex-column text-center">

                                <h5 class="card-title fw-bolder text-dark mb-1">${item.title}</h5>
                                <p class="card-text text-muted small">${item.organization}</p>

                                <div class="my-3">
                                    <p class="mb-1 text-uppercase small text-muted">최대 지원 금액</p>
                                    <p class="amount-highlight">
                                        <fmt:formatNumber value="${item.supportAmount}" pattern="#,###"/>원
                                    </p>
                                </div>

                                <div class="mt-auto">
                                    <p class="mb-3">
                                        <span class="deadline-highlight">
                                            <i class="fa-regular fa-clock me-1"></i>
                                            <fmt:parseDate value="${item.deadline}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate"/>
                                            <fmt:formatDate value="${parsedDate}" pattern="MM월 dd일 마감"/>
                                        </span>
                                    </p>
                                </div>
                            </div>

                            <div class="card-footer bg-white pt-3 d-flex justify-content-between btn-action-group">
                                <a href="scholarships/${item.refId}/detail" class="btn btn-outline-primary w-50 me-2 rounded-pill">
                                    상세보기
                                </a>

                                <button type="button" class="btn btn-success w-50 rounded-pill" onclick="alert('관심 장학금에 담았습니다!')">
                                    <i class="fa-solid fa-heart"></i> 담기
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-info text-center" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> 현재 장학금 정보가 없습니다.
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="mt-5 d-flex justify-content-center">
        <nav>
            <ul class="pagination">
                <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item"><a class="page-link" href="#">다음</a></li>
            </ul>
        </nav>
    </div>

</section>

<footer>
    <jsp:include page="../common/bottom.jsp" />
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>