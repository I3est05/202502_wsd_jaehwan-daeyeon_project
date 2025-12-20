<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/top.jsp" />

<%-- 1. 날짜 계산을 위한 세팅 --%>
<c:set var="now" value="<%= new java.util.Date() %>" />
<%-- 오늘 날짜를 yyyy-MM-dd 숫자로 변환 (시간 제외 비교용) --%>
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayStr" />
<fmt:parseDate value="${todayStr}" pattern="yyyy-MM-dd" var="todayDate" />

<%-- 장학금 마감일을 Date 객체로 변환 --%>
<fmt:parseDate value="${scholarship.deadline}" pattern="yyyy-MM-dd" var="deadlineDate" />

<%-- 밀리초 단위 차이 계산 --%>
<c:set var="diff" value="${deadlineDate.time - todayDate.time}" />
<%-- 날짜 차이 계산 (1일 = 86,400,000 밀리초) --%>
<fmt:formatNumber value="${diff / (1000 * 60 * 60 * 24)}" var="dDay" pattern="#" />

<style>
    body {
        padding-top: 100px; /* 헤더 공간 확보 */
        background-color: #f8f9fa;
        display: flex;
        flex-direction: column;
        min-height: 100vh; /* 푸터가 바닥에 붙도록 설정 */
    }
    .main-content {
        flex: 1; /* 콘텐츠가 적어도 푸터가 아래에 위치하게 함 */
    }
    .detail-card {
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        border: none;
        background: white;
    }
    .badge-source-api { background-color: #198754; }
    .badge-source-db { background-color: #0d6efd; }

    .detail-section {
        border-bottom: 1px dashed #e9ecef;
        padding: 15px 0;
    }
    .detail-label { font-weight: 600; color: #495057; }
    .detail-value { color: #212529; }

    .detail-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 40px;
    }
</style>

<div class="main-content">
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${not empty scholarship}">
                        <div class="card detail-card p-4">
                            <div class="card-body">
                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="badge ${scholarship.sourceType == 'API' ? 'badge-source-api' : 'badge-source-db'} fs-6 me-2">
                                            <c:out value="${scholarship.sourceType}"/>
                                        </span>
                                        <span class="badge bg-secondary fs-6">
                                            <c:out value="${scholarship.organization}"/>
                                        </span>
                                    </div>
                                    <div class="text-end">
                                        <c:choose>
                                            <%-- 마감일이 지난 경우 --%>
                                            <c:when test="${dDay < 0}">
                                                <span class="d-day-badge status-expired">모집 마감</span>
                                            </c:when>
                                            <%-- 오늘이 마감일인 경우 --%>
                                            <c:when test="${dDay == 0}">
                                                <span class="d-day-badge status-today">오늘 마감 (D-Day)</span>
                                            </c:when>
                                            <%-- 마감 전인 경우 (D-Day 표시) --%>
                                            <c:otherwise>
                                                <span class="d-day-badge status-active">D-${dDay}</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <p class="small text-muted mt-2">마감일: ${scholarship.deadline}</p>
                                    </div>
                                </div>

                                <h2 class="card-title fw-bold mb-4 border-bottom pb-3 text-primary">
                                    <c:out value="${scholarship.title}"/>
                                </h2>

                                <div class="detail-section row">
                                    <div class="col-sm-4 detail-label">분류 (Category)</div>
                                    <div class="col-sm-8 detail-value"><c:out value="${scholarship.category}"/></div>
                                </div>
                                <div class="detail-section row">
                                    <div class="col-sm-4 detail-label">지원 금액</div>
                                    <div class="col-sm-8 detail-value fs-5 text-primary fw-bold">
                                        <i class="fa-solid fa-money-bill-wave me-2"></i><c:out value="${scholarship.support_amount}"/>
                                    </div>
                                </div>
                                <div class="detail-section row">
                                    <div class="col-sm-4 detail-label">마감일</div>
                                    <div class="col-sm-8 detail-value fs-5">
                                        <i class="fa-regular fa-clock me-2"></i>
                                        <strong class="text-danger"><c:out value="${scholarship.deadline}"/></strong>
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top">
                                    <h4 class="fw-bold mb-3 text-secondary">장학금 개요 및 상세 내용</h4>
                                    <p class="card-text text-break" style="white-space: pre-wrap; line-height: 1.6;">
                                        <c:out value="${scholarship.description}"/>
                                    </p>
                                </div>

                                <div class="detail-button-group">
                                    <button type="button" id="wishlistBtn"
                                            class="btn ${isScrapped ? 'btn-warning' : 'btn-outline-warning'} text-dark"
                                            onclick="saveToWishlist('${scholarship.refId}', '${scholarship.title}')">
                                        <i class="${isScrapped ? 'fa-solid' : 'fa-regular'} fa-heart me-2"></i>관심 목록에 저장
                                    </button>
                                    <a href="${pageContext.request.contextPath}/list.do" class="btn btn-outline-secondary">
                                        <i class="fa-solid fa-list me-2"></i>목록으로 돌아가기
                                    </a>
                                    <button type="button" class="btn btn-primary" onclick="alert('실제 장학금 신청 웹사이트로 이동합니다.');">
                                        <i class="fa-solid fa-arrow-up-right-from-square me-2"></i>신청 바로가기
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning text-center p-5" role="alert">
                            <i class="fa-solid fa-circle-exclamation fa-3x mb-3"></i><br>
                            <strong>죄송합니다!</strong> 요청하신 장학금 정보를 찾을 수 없습니다.
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/list.do" class="btn btn-primary">목록으로 돌아가기</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%-- 공통 푸터 포함: body 닫히기 직전에 배치 --%>
<jsp:include page="../common/bottom.jsp" />

<script>
    function saveToWishlist(id, title) {
        fetch(`${pageContext.request.contextPath}/api/scrap/toggle`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 'scholarId': id })
        })
            .then(response => {
                if (response.status === 401) {
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${pageContext.request.contextPath}/login";
                    return;
                }
                return response.json();
            })
            .then(data => {
                const btn = document.getElementById('wishlistBtn');
                const icon = btn.querySelector('i');
                if (data && data.isScrapped) {
                    alert(title + "을(를) 관심 목록에 저장했습니다!");
                    icon.classList.replace('fa-regular', 'fa-solid');
                    btn.classList.replace('btn-outline-warning', 'btn-warning');
                } else if (data) {
                    alert("관심 목록에서 삭제되었습니다.");
                    icon.classList.replace('fa-solid', 'fa-regular');
                    btn.classList.replace('btn-warning', 'btn-outline-warning');
                }
            })
            .catch(error => alert("처리 중 오류가 발생했습니다."));
    }
</script>