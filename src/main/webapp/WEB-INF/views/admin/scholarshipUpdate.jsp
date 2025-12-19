<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/top.jsp" />

<style>
    body {
        padding-top: 100px; /* 헤더에 가려지지 않도록 추가 */
        background-color: #f8f9fa;
    }
    .form-label {
        color: #ffc107; /* Warning color for update */
    }
</style>

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <h2 class="fw-bold mb-4 text-warning">🛠️ 장학금 정보 수정</h2>
            <p class="text-muted">ID: <c:out value="${scholarship.refId}"/>의 장학금 정보를 수정합니다. 수정하지 않은 필드는 기존 값을 유지합니다.</p>

            <%-- ✅ 1. 폼 전송 경로에 Context Path 추가 --%>
            <form action="${pageContext.request.contextPath}/admin/updateok/${scholarship.refId}" method="post" class="needs-validation" novalidate>

                <div class="card p-5 shadow-lg">

                    <%-- 🚨 중요: 수정할 항목의 ID(refId)를 숨겨서 전송합니다. --%>
                    <input type="hidden" name="refId" value="${scholarship.refId}">

                    <div class="mb-4">
                        <label for="title" class="form-label fw-bold">제목</label>
                        <input type="text" id="title" name="title" class="form-control form-control-lg"
                               value="${scholarship.title}" placeholder="장학금 명칭">
                    </div>

                    <div class="mb-4 row">
                        <div class="col-md-6">
                            <label for="organization" class="form-label fw-bold">운영기관</label>
                            <input type="text" id="organization" name="organization" class="form-control"
                                   value="${scholarship.organization}" placeholder="운영기관">
                        </div>

                        <div class="col-md-6">
                            <label for="deadline" class="form-label fw-bold">마감일</label>
                            <input type="text" id="deadline" name="deadline" class="form-control"
                                   value="${scholarship.deadline}"
                                   placeholder="YYYY-MM-DD 형식 (예: 2025-05-31)">
                        </div>
                    </div>

                    <div class="mb-4 row">
                        <div class="col-md-6">
                            <label for="category" class="form-label fw-bold">유형/구분</label>
                            <input type="text" id="category" name="category" class="form-control"
                                   value="${scholarship.category}" placeholder="유형/구분">
                        </div>

                        <div class="col-md-6">
                            <label for="support_amount" class="form-label fw-bold">지원 금액/내역</label>
                            <input type="text" id="support_amount" name="support_amount" class="form-control"
                                   value="${scholarship.support_amount}" placeholder="지원 금액/내역">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="description" class="form-label fw-bold">상세 내용 및 자격 요건</label>
                        <textarea id="description" name="description" rows="10" class="form-control"
                                  placeholder="상세 내용 및 자격 요건"><c:out value="${scholarship.description}"/></textarea>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <%-- ✅ 2. 목록으로 돌아가기 링크에 Context Path 추가 --%>
                    <a href="${pageContext.request.contextPath}/admin/manage" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-2"></i>취소 및 목록으로
                    </a>
                    <button type="submit" class="btn btn-warning btn-lg text-dark">
                        <i class="fa-solid fa-floppy-disk me-2"></i>수정 완료
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/bottom.jsp" />