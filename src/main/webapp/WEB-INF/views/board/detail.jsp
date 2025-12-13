<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/top.jsp" />

<style>
    body {
        padding-top: 100px; /* 헤더에 가려지지 않도록 */
        background-color: #f8f9fa;
    }
    .detail-card {
        border-radius: 15px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
    /* 출처 뱃지 스타일 */
    .badge-source-api {
        background-color: #198754; /* success color */
    }
    .badge-source-db {
        background-color: #0d6efd; /* primary color */
    }
    .detail-section {
        border-bottom: 1px dashed #e9ecef;
        padding: 10px 0;
    }
    .detail-section:last-child {
        border-bottom: none;
    }
    .detail-label {
        font-weight: 600;
        color: #495057;
    }
    .detail-value {
        color: #212529;
    }
    /* 버튼 그룹 스타일링 */
    .detail-button-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 40px;
    }
</style>

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
                                <h4 class="text-danger fw-bold m-0">
                                    마감 임박!
                                </h4>
                            </div>

                            <h2 class="card-title fw-bold mb-4 border-bottom pb-3">
                                <c:out value="${scholarship.title}"/>
                            </h2>

                            <div class="detail-section row">
                                <div class="col-sm-4 detail-label">분류 (Category)</div>
                                <div class="col-sm-8 detail-value">
                                    <c:out value="${scholarship.category}"/>
                                </div>
                            </div>
                            <div class="detail-section row">
                                <div class="col-sm-4 detail-label">지원 금액</div>
                                <div class="col-sm-8 detail-value fs-5 text-primary">
                                    <i class="fa-solid fa-money-bill-wave me-2"></i>
                                    <c:out value="${scholarship.support_amount}"/>
                                </div>
                            </div>
                            <div class="detail-section row">
                                <div class="col-sm-4 detail-label">마감일</div>
                                <div class="col-sm-8 detail-value fs-5">
                                    <i class="fa-regular fa-clock me-2"></i>
                                    <strong class="text-danger">
                                        <c:out value="${scholarship.deadline}"/>
                                    </strong>
                                </div>
                            </div>

                            <div class="mt-4 pt-3 border-top">
                                <h4 class="fw-bold mb-3 text-secondary">장학금 개요 및 상세 내용</h4>
                                <p class="card-text text-break" style="white-space: pre-wrap;">
                                    <c:out value="${scholarship.description}"/>
                                </p>
                            </div>

                            <div class="detail-button-group">

                                    <%-- 1. 관심 목록에 저장 버튼 (JavaScript로 임시 처리) --%>
                                <button type="button" class="btn btn-outline-warning text-dark"
                                        onclick="saveToWishlist('<c:out value="${scholarship.refId}"/>', '<c:out value="${scholarship.title}"/>')">
                                    <i class="fa-regular fa-heart me-2"></i>관심 목록에 저장
                                </button>

                                    <%-- 2. 목록으로 돌아가기 버튼 --%>
                                <a href="list.do" class="btn btn-outline-secondary">
                                    <i class="fa-solid fa-list me-2"></i>목록으로 돌아가기
                                </a>

                                    <%-- 3. 신청 바로가기 버튼 (Primary Action) --%>
                                <button type="button" class="btn btn-primary" onclick="alert('실제 장학금 신청 웹사이트로 이동합니다.');">
                                    <i class="fa-solid fa-arrow-up-right-from-square me-2"></i>신청 바로가기
                                </button>
                            </div>

                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center" role="alert">
                        <strong>죄송합니다!</strong> 요청하신 장학금 정보를 찾을 수 없습니다.
                    </div>
                    <div class="text-center mt-4">
                        <a href="list.do" class="btn btn-primary">목록으로 돌아가기</a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<script>
    // 관심 목록 저장 임시 JavaScript 함수
    function saveToWishlist(id, title) {
        // 실제로는 AJAX 호출을 통해 서버의 관심 목록 DB에 저장하는 로직이 들어갑니다.
        alert("장학금 ID: " + id + " (" + title + ")을(를) 관심 목록에 저장했습니다!");
        // 버튼 스타일을 변경하거나 사용자에게 성공 피드백을 줄 수 있습니다.
    }
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/bottom.jsp" />