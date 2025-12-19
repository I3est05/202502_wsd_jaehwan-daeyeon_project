<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/top.jsp" />

<%!
    // 페이지 관련 변수 계산 로직은 그대로 유지
    public static class PaginationHelper {
        public static int getTotalPages(int totalCount, int pageSize) {
            return (int) Math.ceil((double) totalCount / pageSize);
        }
        public static int getStartPage(int currentPage, int pageBlockSize) {
            return ((currentPage - 1) / pageBlockSize) * pageBlockSize + 1;
        }
        public static int getEndPage(int startPage, int pageBlockSize, int totalPages) {
            return Math.min(startPage + pageBlockSize - 1, totalPages);
        }
    }
%>

<%
    // Controller에서 설정된 값들을 가져옴
    Integer totalCountObj = (Integer) request.getAttribute("totalCount");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer pageSizeObj = (Integer) request.getAttribute("pageSize");

    int totalCount = (totalCountObj != null) ? totalCountObj.intValue() : 0;
    int currentPage = (currentPageObj != null) ? currentPageObj.intValue() : 1;
    int pageSize = (pageSizeObj != null) ? pageSizeObj.intValue() : 10;
    int pageBlockSize = 10;

    int totalPages = PaginationHelper.getTotalPages(totalCount, pageSize);
    int startPage = PaginationHelper.getStartPage(currentPage, pageBlockSize);
    int endPage = PaginationHelper.getEndPage(startPage, pageBlockSize, totalPages);
%>

<style>
    body {
        padding-top: 100px; /* 헤더의 높이보다 크게 설정하여 가려지지 않도록 합니다. */
    }

    .scholarship-card {
        border: 1px solid #e9ecef;
        border-radius: 15px;
        transition: box-shadow 0.3s ease;
        height: 100%;
    }
    .scholarship-card:hover {
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    .card-title-link {
        color: #0d6efd;
        text-decoration: none;
    }
    .card-title-link:hover {
        text-decoration: underline;
    }
    .pagination-container {
        display: flex;
        justify-content: center;
        margin-top: 30px;
        margin-bottom: 50px;
    }
    .pagination-container a, .pagination-container span {
        padding: 8px 15px;
        margin: 0 4px;
        border: 1px solid #dee2e6;
        text-decoration: none;
        color: #0d6efd;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    .pagination-container a:hover {
        background-color: #f8f9fa;
    }
    .pagination-container .active {
        background-color: #0d6efd;
        color: white;
        border-color: #0d6efd;
    }
</style>

<div class="container mt-5">

    <h2 class="fw-bold mb-2">💰 장학금 통합 목록</h2>
    <p class="text-muted mb-4">총 장학금 수: <strong><%= totalCount %></strong> 개</p>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty scholarshipList}">
                <c:forEach var="scholarship" items="${scholarshipList}">
                    <div class="col">
                        <div class="card scholarship-card">
                            <div class="card-body">
                                <span class="badge ${scholarship.sourceType == 'API' ? 'bg-success' : 'bg-primary'} mb-2">
                                    <c:out value="${scholarship.sourceType}"/>
                                </span>
                                <span class="badge bg-secondary mb-2">${scholarship.organization}</span>

                                <h5 class="card-title mt-2">
                                        <%-- ✅ 1. 카드 제목 링크에 Context Path 추가 --%>
                                    <a href="${pageContext.request.contextPath}/detail.do?id=<c:out value="${scholarship.refId}"/>" class="card-title-link fw-bold">
                                        <c:out value="${scholarship.title}"/>
                                    </a>
                                </h5>

                                <ul class="list-unstyled small text-muted mt-3">
                                    <li><i class="fa-solid fa-money-bill-wave me-2"></i>지원금액: ${scholarship.support_amount}</li>
                                    <li><i class="fa-regular fa-clock me-2"></i>마감일:
                                        <strong class="text-danger">
                                            <c:out value="${scholarship.deadline}"/>
                                        </strong>
                                    </li>
                                </ul>

                                <p class="card-text small mt-3 border-top pt-2">
                                    <c:out value="${scholarship.description}"/>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-info text-center" role="alert">
                        조회된 장학금 정보가 없습니다.
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 🎨 페이징 네비게이션 🎨 --%>
    <div class="pagination-container">
        <%-- ✅ 2. 이전 그룹 링크에 Context Path 추가 --%>
        <% if (startPage > 1) { %>
        <a href="${pageContext.request.contextPath}/list.do?page=<%= startPage - 1 %>" title="이전 10페이지" aria-label="Previous Group">&laquo;</a>
        <% } %>

        <%-- ✅ 3. 페이지 번호 링크에 Context Path 추가 --%>
        <% for (int i = startPage; i <= endPage; i++) {
            String active = (i == currentPage) ? "active" : ""; %>
        <a href="${pageContext.request.contextPath}/list.do?page=<%= i %>" class="<%= active %>"><%= i %></a>
        <% } %>

        <%-- ✅ 4. 다음 그룹 링크에 Context Path 추가 --%>
        <% if (endPage < totalPages) { %>
        <a href="${pageContext.request.contextPath}/list.do?page=<%= endPage + 1 %>" title="다음 10페이지" aria-label="Next Group">&raquo;</a>
        <% } %>
    </div>
</div>

<jsp:include page="../common/bottom.jsp" />