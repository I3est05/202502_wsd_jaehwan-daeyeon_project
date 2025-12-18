<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>AI 장학금 컨설팅 결과</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { background-color: #f0f2f5; padding-top: 50px; }
    .result-card { border-radius: 20px; border: none; overflow: hidden; }
    .result-header { background: linear-gradient(135deg, #0d6efd, #6610f2); color: white; padding: 40px; }
    .ai-content {
      background-color: white;
      padding: 30px;
      line-height: 1.8;
      white-space: pre-wrap;
      font-size: 1.1rem;
      border-radius: 0 0 20px 20px;
    }
    .id-search-box { background-color: #e9ecef; border-radius: 15px; padding: 20px; }
    .highlight { color: #0d6efd; font-weight: bold; }
  </style>
</head>
<body>

<div class="container mb-5">
  <div class="row justify-content-center">
    <div class="col-lg-9">
      <div class="card result-card shadow">
        <div class="result-header text-center">
          <i class="fa-solid fa-robot fa-3x mb-3"></i>
          <h2 class="fw-bold">${user.userId}님을 위한 AI 맞춤 컨설팅</h2>
          <p class="mb-0">Gemini AI가 학과, 성적, 소득분위를 분석하여 최적의 장학금을 선별했습니다.</p>
        </div>

        <div class="ai-content">
          <div class="mb-4">
            <i class="fa-solid fa-quote-left text-muted me-2"></i>
            ${aiResult}
            <i class="fa-solid fa-quote-right text-muted ms-2"></i>
          </div>

          <hr class="my-4">

          <div class="id-search-box text-center">
            <h5 class="mb-3 fw-bold"><i class="fa-solid fa-magnifying-glass me-2"></i>추천받은 장학금 상세 보기</h5>
            <p class="small text-muted">AI가 추천한 텍스트 중 [ID:번호]의 번호를 아래에 입력하세요.</p>
            <div class="d-flex justify-content-center">
              <div class="input-group w-50">
                <span class="input-group-text">ID 번호</span>
                <input type="number" id="targetId" class="form-control" placeholder="예: 21">
                <button class="btn btn-primary" type="button" onclick="goDetail()">이동하기</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="text-center mt-4">
        <a href="/mypage" class="btn btn-link text-decoration-none text-muted">
          <i class="fa-solid fa-arrow-left me-1"></i> 마이페이지로 돌아가기
        </a>
      </div>
    </div>
  </div>
</div>

<script>
  function goDetail() {
    const scId = document.getElementById('targetId').value;
    if (!scId) {
      alert("이동할 장학금 ID 번호를 입력해주세요.");
      return;
    }
    // 이전에 만든 상세페이지 주소 형식 (detail.do?id=21)
    location.href = "/detail.do?id=" + scId;
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>