<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 공통 헤더 포함 (경로: ../common/top.jsp) --%>
<jsp:include page="../common/top.jsp" />

<%-- 페이징 관련 변수 계산 로직 재사용 (list.jsp에서 가져옴) --%>
<%!
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
    Integer totalCountObj = (Integer) request.getAttribute("totalCount");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer pageSizeObj = (Integer) request.getAttribute("pageSize");

    int totalCount = (totalCountObj != null) ? totalCountObj.intValue() : 0;
    int currentPage = (currentPageObj != null) ? currentPageObj.intValue() : 1;
    int pageSize = (pageSizeObj != null) ? pageSizeObj.intValue() : 15; // Admin은 15개로 설정 가정
    int pageBlockSize = 10;

    int totalPages = PaginationHelper.getTotalPages(totalCount, pageSize);
    int startPage = PaginationHelper.getStartPage(currentPage, pageBlockSize);
    int endPage = PaginationHelper.getEndPage(startPage, pageBlockSize, totalPages);
%>

<style>
    body { padding-top: 100px; }
    .table-container { min-height: 60vh; }
    .action-group { white-space: nowrap; }
</style>

<div class="container mt-5 mb-5">
    <h2 class="fw-bold mb-4">🖥️ 장학금 DB 관리 목록</h2>
    <p class="text-muted">관리자 등록 장학금 총 <%= totalCount %>개</p>

    <div class="mb-3 text-end">
        <a href="/admin/create" class="btn btn-success">
            <i class="fa-solid fa-plus me-2"></i>새 장학금 등록
        </a>
    </div>

    <div class="table-container">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>운영기관</th>
                <th>마감일</th>
                <th>지원금액</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty scholarshipList}">
                    <c:forEach var="scholarship" items="${scholarshipList}">
                        <tr>
                            <td>${scholarship.refId}</td>
                            <td>
                                    <%-- 일반 사용자 상세 보기 페이지 링크 --%>
                                <a href="/detail.do?id=${scholarship.refId}" target="_blank">
                                    <c:out value="${scholarship.title}"/>
                                </a>
                            </td>
                            <td><c:out value="${scholarship.organization}"/></td>
                            <td><c:out value="${scholarship.deadline}"/></td>
                            <td><c:out value="${scholarship.support_amount}"/></td>
                            <td class="action-group">
                                    <%-- 수정 버튼 --%>
                                <a href="/admin/update/${scholarship.refId}" class="btn btn-sm btn-info me-2 text-white">
                                    <i class="fa-solid fa-pen-to-square"></i> 수정
                                </a>
                                    <%-- 삭제 버튼 (POST 요청) --%>
                                <button type="button" class="btn btn-sm btn-danger" onclick="confirmDelete(${scholarship.refId})">
                                    <i class="fa-solid fa-trash-can"></i> 삭제
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" class="text-center text-muted">등록된 DB 장학금 정보가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <%-- 🎨 페이징 네비게이션 🎨 --%>
    <div class="pagination-container d-flex justify-content-center">
        <%-- 이전 그룹으로 --%>
        <% if (startPage > 1) { %>
        <a href="/admin/manage?page=<%= startPage - 1 %>" class="btn btn-outline-secondary btn-sm mx-1">&laquo;</a>
        <% } %>

        <%-- 페이지 번호 --%>
        <% for (int i = startPage; i <= endPage; i++) {
            String activeClass = (i == currentPage) ? "btn-primary" : "btn-outline-primary"; %>
        <a href="/admin/manage?page=<%= i %>" class="btn <%= activeClass %> btn-sm mx-1"><%= i %></a>
        <% } %>

        <%-- 다음 그룹으로 --%>
        <% if (endPage < totalPages) { %>
        <a href="/admin/manage?page=<%= endPage + 1 %>" class="btn btn-outline-secondary btn-sm mx-1">&raquo;</a>
        <% } %>
    </div>
</div>

<%-- 삭제 처리 폼 (POST 요청 전용) --%>
<form id="deleteForm" method="post" action="/admin/remove">
    <input type="hidden" name="id" id="deleteId">
</form>

<script>
    function confirmDelete(id) {
        if (confirm("ID: " + id + " 장학금 정보를 삭제하시겠습니까? (되돌릴 수 없습니다)")) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/bottom.jsp" />