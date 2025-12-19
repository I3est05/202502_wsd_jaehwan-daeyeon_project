<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/top.jsp" />

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
    int pageSize = (pageSizeObj != null) ? pageSizeObj.intValue() : 15;
    int pageBlockSize = 10;

    int totalPages = PaginationHelper.getTotalPages(totalCount, pageSize);
    int startPage = PaginationHelper.getStartPage(currentPage, pageBlockSize);
    int endPage = PaginationHelper.getEndPage(startPage, pageBlockSize, totalPages);
%>

<style>
    body { background-color: #f8f9fa; padding-top: 80px; }

    /* 마이페이지 스타일 계승: 히어로 헤더 */
    .manage-header {
        background: linear-gradient(135deg, #0d6efd 0%, #004dc7 100%);
        color: white;
        padding: 60px 0;
        margin-bottom: 40px;
        border-radius: 15px;
        box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
    }

    /* 마이페이지 스타일 계승: 유저 인포 카드 느낌의 테이블 카드 */
    .admin-card {
        border-radius: 15px;
        border: none;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        background: white;
        padding: 30px;
    }

    .table { margin-bottom: 0; }
    .table thead th {
        background-color: #f1f3f5;
        border-bottom: 2px solid #dee2e6;
        color: #495057;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.85rem;
    }

    .action-group { white-space: nowrap; }

    /* 버튼 스타일 커스텀 */
    .btn-create {
        border-radius: 10px;
        font-weight: 600;
        padding: 10px 20px;
        box-shadow: 0 4px 6px rgba(40, 167, 69, 0.2);
    }

    /* 페이징 스타일 */
    .pagination-container .btn {
        border-radius: 8px;
        margin: 0 3px;
    }
</style>

<div class="container">
    <div class="manage-header text-center shadow-sm">
        <h1 class="display-5 fw-bold"><i class="fa-solid fa-screwdriver-wrench me-3"></i>장학금 DB 관리</h1>
        <p class="lead">관리자 권한으로 장학금 데이터를 통합 관리하고 업데이트합니다.</p>
    </div>

    <div class="admin-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold m-0 text-dark">
                <i class="fa-solid fa-list-check me-2 text-primary"></i>등록된 장학금 목록
                <span class="badge bg-primary px-3 ms-2" style="font-size: 0.9rem;">${scholarshipList.size()}건</span>
            </h4>
            <a href="${pageContext.request.contextPath}/admin/create" class="btn btn-success btn-create">
                <i class="fa-solid fa-plus me-2"></i>새 장학금 등록
            </a>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr class="text-center">
                    <th style="width: 8%;">ID</th>
                    <th style="width: 35%;">장학금 명칭</th>
                    <th style="width: 15%;">운영기관</th>
                    <th style="width: 12%;">마감일</th>
                    <th style="width: 12%;">지원금액</th>
                    <th style="width: 18%;">관리 액션</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty scholarshipList}">
                        <c:forEach var="scholarship" items="${scholarshipList}">
                            <tr>
                                <td class="text-center text-muted small">${scholarship.refId}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/detail.do?id=${scholarship.refId}" target="_blank" class="fw-bold text-decoration-none text-dark">
                                        <c:out value="${scholarship.title}"/>
                                        <i class="fa-solid fa-arrow-up-right-from-square ms-1 small text-muted" style="font-size: 0.7rem;"></i>
                                    </a>
                                </td>
                                <td class="text-center"><span class="badge bg-light text-dark border">${scholarship.organization}</span></td>
                                <td class="text-center small"><c:out value="${scholarship.deadline}"/></td>
                                <td class="text-center text-primary fw-bold small">${scholarship.support_amount}</td>
                                <td class="text-center action-group">
                                    <a href="${pageContext.request.contextPath}/admin/update/${scholarship.refId}" class="btn btn-sm btn-outline-info me-1">
                                        <i class="fa-solid fa-pen-to-square"></i> 수정
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${scholarship.refId})">
                                        <i class="fa-solid fa-trash-can"></i> 삭제
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="fa-solid fa-inbox fa-3x mb-3 d-block"></i>
                                등록된 장학금 정보가 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <div class="pagination-container d-flex justify-content-center mt-5">
            <% if (startPage > 1) { %>
            <a href="${pageContext.request.contextPath}/admin/manage?page=<%= startPage - 1 %>" class="btn btn-outline-secondary btn-sm">&laquo;</a>
            <% } %>

            <% for (int i = startPage; i <= endPage; i++) {
                String activeClass = (i == currentPage) ? "btn-primary shadow-sm" : "btn-outline-primary"; %>
            <a href="${pageContext.request.contextPath}/admin/manage?page=<%= i %>" class="btn <%= activeClass %> btn-sm"><%= i %></a>
            <% } %>

            <% if (endPage < totalPages) { %>
            <a href="${pageContext.request.contextPath}/admin/manage?page=<%= endPage + 1 %>" class="btn btn-outline-secondary btn-sm">&raquo;</a>
            <% } %>
        </div>
    </div>
</div>

<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/remove">
    <input type="hidden" name="id" id="deleteId">
</form>

<script>
    function confirmDelete(id) {
        if (confirm("ID: " + id + " 장학금 정보를 삭제하시겠습니까? (삭제된 데이터는 복구할 수 없습니다)")) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>

<footer>
    <jsp:include page="../common/bottom.jsp" />
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>