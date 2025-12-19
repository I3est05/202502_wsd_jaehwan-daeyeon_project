<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${user.userId}님의 정보 수정</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { background-color: #f8f9fa; padding-top: 60px; }

    .page-header-hero {
      background: linear-gradient(rgba(13, 110, 253, 0.9), rgba(13, 110, 253, 0.7)),
      url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
      background-size: cover; background-position: center;
      color: white; padding: 60px 0; margin-bottom: 40px; border-radius: 0 0 25px 25px;
    }

    .form-container-card {
      background: white; padding: 35px; border-radius: 15px;
      margin-bottom: 25px; border: none;
      box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
    }

    .section-title {
      font-size: 1.1rem; font-weight: 700; color: #0d6efd;
      margin-bottom: 20px; border-bottom: 2px solid #e9ecef; padding-bottom: 10px;
    }

    .form-label { font-weight: 600; color: #495057; }

    .btn-save { background-color: #0d6efd; border: none; padding: 12px; font-weight: 700; }
  </style>
</head>
<body>
<jsp:include page="../common/top.jsp" />

<div class="page-header-hero text-center shadow-sm">
  <div class="container">
    <i class="fa-solid fa-user-pen fa-3x mb-3"></i>
    <h2 class="display-6 fw-bold">내 정보 수정</h2>
    <p class="lead opacity-75">${user.userId}님의 맞춤 장학금 정보를 업데이트하세요.</p>
  </div>
</div>

<div class="container" style="max-width: 800px; margin-top: -50px; position: relative; z-index: 10;">
  <form action="${pageContext.request.contextPath}/mypage/edit" method="post">
    <input type="hidden" name="userId" value="${user.userId}">

    <div class="form-container-card">
      <div class="section-title"><i class="fa-solid fa-lock me-2"></i>기본 계정 정보</div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">아이디</label>
          <input type="text" class="form-control bg-light" value="${user.userId}" readonly>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">이메일</label>
          <input type="email" name="email" class="form-control" value="${user.email}" required>
        </div>
      </div>
      <div class="mb-2">
        <label class="form-label">새 비밀번호</label>
        <input type="password" name="password" class="form-control" placeholder="변경할 경우에만 입력하세요">
        <div class="form-text text-muted">비밀번호를 입력하지 않으면 기존 비밀번호가 유지됩니다.</div>
      </div>
    </div>

    <div class="form-container-card">
      <div class="section-title"><i class="fa-solid fa-graduation-cap me-2"></i>장학금 맞춤 스펙</div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">학과</label>
          <input type="text" name="department" class="form-control" value="${user.department}" required>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">학년</label>
          <select name="grade" class="form-select">
            <c:forEach var="i" begin="1" end="4">
              <option value="${i}" ${user.grade == i ? 'selected' : ''}>${i}학년</option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">학점 (GPA)</label>
          <div class="input-group">
            <input type="number" name="gpa" class="form-control" step="0.01" min="0" max="4.5" value="${user.gpa}" required>
            <span class="input-group-text">/ 4.5</span>
          </div>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">소득분위</label>
          <select name="incomeBracket" class="form-select">
            <c:forEach var="i" begin="0" end="10">
              <option value="${i}" ${user.incomeBracket == i ? 'selected' : ''}>
                <c:choose>
                  <c:when test="${i == 0}">기초생활수급자 (0구간)</c:when>
                  <c:otherwise>${i}구간</c:otherwise>
                </c:choose>
              </option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label">거주지 (시/군/구)</label>
        <input type="text" name="address" class="form-control" value="${user.address}">
      </div>

      <div class="mb-0">
        <label class="form-label">특이사항 (선택)</label>
        <textarea name="spec" class="form-control" rows="2">${user.spec}</textarea>
      </div>
    </div>

    <div class="d-grid gap-3 mt-4 mb-5">
      <button type="submit" class="btn btn-primary btn-save shadow-sm">
        <i class="fa-solid fa-check-double me-2"></i> 정보 수정 완료
      </button>
      <a href="${pageContext.request.contextPath}/mypage" class="btn btn-link text-muted text-decoration-none text-center">
        <i class="fa-solid fa-xmark me-1"></i> 취소하고 돌아가기
      </a>
    </div>
  </form>
</div>

<jsp:include page="../common/bottom.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>