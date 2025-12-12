<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${user.userId}님의 정보 수정</title>
  <style>
    /* 기존 디자인 일관성을 위한 스타일 */
    body { background-color: #f8f9fa; padding-top: 60px;}

    /* 💡 마이페이지 헤더 스타일 복원 (푸른색 그라데이션) */
    .page-header-hero {
      background: linear-gradient(rgba(13, 110, 253, 0.9), rgba(13, 110, 253, 0.7)),
      url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
      background-size: cover;
      background-position: center;
      color: white;
      padding: 50px 0; /* padding 조정 */
      margin-bottom: 40px;
      border-radius: 0 0 10px 10px; /* 하단만 둥글게 처리 */
    }
    .page-header-hero h2 {
      font-weight: 700;
      margin-bottom: 5px;
    }

    /* 폼 컨테이너 스타일 */
    .form-container-card {
      background: white;
      padding: 40px;
      border-radius: 8px;
      margin-bottom: 30px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1); /* 그림자 강조 */
    }

    /* 버튼 스타일 복원 (primary: #0d6efd) */
    .btn-primary {
      background-color: #0d6efd;
      border-color: #0d6efd;
      font-weight: 600;
    }
    .btn-primary:hover {
      background-color: #0b5ed7;MyScholarship
      border-color: #0a58ca;
    }
  </style>
</head>
<body>
<jsp:include page="../common/top.jsp" />

<div class="page-header-hero text-center">
  <div class="container" style="max-width: 700px;">
    <i class="fa-solid fa-user-edit fa-3x mb-3"></i>
    <h2 class="text-white">내 정보 수정</h2>
    <p class="lead text-white-50">(${user.userId}님) 변경할 정보를 입력하고 저장해주세요.</p>
  </div>
</div>

<div class="container" style="max-width: 700px; margin-top: -60px; position: relative;">

  <form action="/mypage/edit" method="post">

    <input type="hidden" name="userId" value="${user.userId}">

    <div class="form-container-card">

      <h5 class="mb-4 fw-bold border-bottom pb-2">계정 및 인증 정보</h5>

      <div class="mb-3">
        <label class="form-label fw-bold">아이디</label>
        <input type="text" class="form-control-plaintext fw-bold text-success" value="${user.userId}" readonly>
      </div>

      <div class="mb-4">
        <label for="email" class="form-label">이메일</label>
        <input type="email" name="email" id="email" class="form-control" value="${user.email}" required>
      </div>

      <div class="mb-2">
        <label for="password" class="form-label">새 비밀번호</label>
        <input type="password" name="password" id="password" class="form-control" placeholder="변경할 경우에만 입력" required>
      </div>
      <p class="small text-muted mb-4">비밀번호를 변경하지 않을 경우, 기존 비밀번호를 입력해야 합니다. (혹은 빈 값으로 제출 시 서비스 로직에서 기존 값 유지)</p>
    </div>

    <div class="form-container-card mt-4">
      <h5 class="mb-4 fw-bold border-bottom pb-2">장학금 필수 스펙</h5>

      <div class="mb-4">
        <label for="incomeBracket" class="form-label">소득분위</label>
        <div class="input-group">
          <input type="number" name="incomeBracket" id="incomeBracket" class="form-control" value="${user.incomeBracket}" min="0" max="10" required>
          <span class="input-group-text">구간 (0~10)</span>
        </div>
      </div>

      <div class="mb-4">
        <label for="gpa" class="form-label">학점 (GPA)</label>
        <div class="input-group">
          <input type="number" name="gpa" id="gpa" class="form-control" step="0.01" min="0" max="4.5" value="${user.gpa}" required>
          <span class="input-group-text">/ 4.5</span>
        </div>
      </div>
    </div>

    <div class="d-grid gap-2 mt-5">
      <button type="submit" class="btn btn-primary btn-lg"><i class="fa-solid fa-save me-2"></i> 정보 저장하기</button>
      <a href="/mypage" class="btn btn-outline-secondary">마이페이지로 돌아가기</a>
    </div>
  </form>
</div>

<jsp:include page="../common/bottom.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>