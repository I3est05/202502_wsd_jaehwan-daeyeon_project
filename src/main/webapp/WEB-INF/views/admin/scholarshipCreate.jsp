<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 공통 헤더 포함 --%>
<jsp:include page="../common/top.jsp" />

<style>
    body{
        padding-top: 80px;
    }
    .form-label {
        color: #0d6efd; /* Primary color */
    }
    .required::after {
        content: " *";
        color: red;
        font-weight: bold;
    }
</style>

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <h2 class="fw-bold mb-4 text-primary">⭐ 새 장학금 등록</h2>
            <p class="text-muted">데이터베이스에 새로운 장학금 정보를 직접 추가합니다.</p>

            <%-- ✅ 1. 폼 전송 경로에 Context Path 추가 --%>
            <form action="${pageContext.request.contextPath}/admin/createok" method="post" class="needs-validation" novalidate>

                <div class="card p-5 shadow-lg">

                    <div class="mb-4">
                        <label for="title" class="form-label fw-bold required">제목</label>
                        <input type="text" id="title" name="title" class="form-control form-control-lg" required="true" placeholder="장학금 명칭을 입력하세요 (필수)">
                        <div class="invalid-feedback">제목은 필수 항목입니다.</div>
                    </div>

                    <div class="mb-4 row">
                        <div class="col-md-6">
                            <label for="organization" class="form-label fw-bold required">운영기관</label>
                            <input type="text" id="organization" name="organization" class="form-control" required="true" placeholder="한국장학재단, OOO장학회 등">
                            <div class="invalid-feedback">운영기관은 필수 항목입니다.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="deadline" class="form-label fw-bold required">마감일</label>
                            <input type="date" id="deadline" name="deadline" class="form-control" required="true" placeholder="YYYY-MM-DD (예: 2025-05-31)">
                            <div class="invalid-feedback">마감일은 필수 항목입니다.</div>
                        </div>
                    </div>

                    <div class="mb-4 row">
                        <div class="col-md-6">
                            <label for="category" class="form-label fw-bold">유형/구분</label>
                            <input type="text" id="category" name="category" class="form-control" placeholder="성적우수, 생활비지원 등">
                        </div>

                        <div class="col-md-6">
                            <label for="support_amount" class="form-label fw-bold">지원 금액/내역</label>
                            <input type="text" id="support_amount" name="support_amount" class="form-control" placeholder="전액, 학기당 300만원 등">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="description" class="form-label fw-bold required">상세 내용 및 자격 요건</label>
                        <textarea id="description" name="description" rows="10" class="form-control" required="true" placeholder="지원 자격, 제출 서류, 세부 내용을 상세히 입력하세요."></textarea>
                        <div class="invalid-feedback">상세 내용은 필수 항목입니다.</div>
                    </div>
                </div>

                <div class="d-flex justify-content-between mt-4">
                    <%-- ✅ 2. 취소 버튼 경로에 Context Path 추가 --%>
                    <a href="${pageContext.request.contextPath}/admin/manage" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-2"></i>취소 및 목록으로
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fa-solid fa-cloud-arrow-up me-2"></i>DB에 등록하기
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script>
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
    })()
</script>

<%-- 공통 푸터 포함 --%>
<jsp:include page="../common/bottom.jsp" />