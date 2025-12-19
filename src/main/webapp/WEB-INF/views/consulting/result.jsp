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
    body { background-color: #f8f9fa; padding-top: 80px; font-family: 'Pretendard', sans-serif; }

    /* 마이페이지 스타일 계승 카드 */
    .result-card {
      border-radius: 20px;
      border: none;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08) !important;
      background-color: #fff;
      overflow: hidden;
    }

    /* 상단 헤더 - 시그니처 블루 그라데이션 */
    .result-header {
      background: linear-gradient(135deg, #0d6efd, #004dc7);
      color: white;
      padding: 40px 20px;
    }

    /* AI 리포트 본문 영역 */
    .ai-content {
      padding: 40px;
      line-height: 1.8;
      color: #333;
    }

    /* 1. 사용자 프로필 분석 섹션 꾸미기 */
    .profile-box {
      background-color: #f1f8ff;
      border-radius: 15px;
      padding: 25px;
      margin-bottom: 35px;
      border-left: 5px solid #0d6efd;
    }

    /* 2. 장학금 아이템 개별 카드화 */
    .scholar-item {
      background: #ffffff;
      border: 1px solid #e9ecef;
      border-radius: 12px;
      padding: 25px;
      margin-bottom: 20px;
      transition: transform 0.2s;
    }
    .scholar-item:hover {
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    /* ID 배지 및 강조 스타일 */
    .id-badge {
      background-color: #e7f1ff;
      color: #0d6efd;
      font-weight: 700;
      padding: 4px 12px;
      border-radius: 50px;
      font-size: 0.9rem;
    }

    .ai-content strong, .ai-content b { color: #0d6efd; }

    /* 하단 퀵링크 영역 */
    #quick-links {
      background-color: #f8f9fa;
      border-radius: 15px;
      padding: 25px;
      margin-top: 40px;
      border-top: 2px solid #eee;
    }

    .btn-recommend {
      background-color: white;
      border: 1px solid #0d6efd;
      color: #0d6efd;
      font-weight: 600;
      transition: all 0.3s;
      margin: 5px;
    }

    .btn-recommend:hover {
      background-color: #0d6efd;
      color: white;
      transform: scale(1.05);
    }
  </style>
</head>
<body>

<div class="container mb-5">
  <div class="row justify-content-center">
    <div class="col-lg-10 col-xl-9">

      <div class="card result-card">
        <div class="result-header text-center">
          <div class="mb-3"><i class="fa-solid fa-robot fa-3x"></i></div>
          <h2 class="fw-bold mb-2">AI 맞춤 컨설팅 리포트</h2>
          <p class="mb-0 opacity-75">${user.userId}님의 데이터를 바탕으로 Gemini AI가 분석한 최적의 장학금입니다.</p>
        </div>

        <div class="ai-content">
          <div id="ai-text-root" style="display:none;">${aiResult}</div>

          <div id="formatted-content">
            <div class="text-center py-5">
              <div class="spinner-border text-primary" role="status"></div>
              <p class="mt-2 text-muted">리포트를 시각화하는 중입니다...</p>
            </div>
          </div>

          <div id="quick-links" class="d-none">
            <h5 class="fw-bold mb-3"><i class="fa-solid fa-star text-warning me-2"></i>상세 페이지 바로가기</h5>
            <div id="button-container" class="d-flex flex-wrap"></div>
          </div>
        </div>
      </div>

      <div class="text-center mt-4">
        <a href="/mypage" class="btn btn-outline-secondary rounded-pill px-4 shadow-sm">
          <i class="fa-solid fa-arrow-left me-2"></i> 마이페이지로
        </a>
        <a href="/list.do" class="btn btn-primary rounded-pill px-4 ms-2 shadow-sm">
          <i class="fa-solid fa-list-ul me-2"></i> 장학금 전체목록
        </a>
      </div>

    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const rawText = document.getElementById("ai-text-root").innerText;
    const formattedDiv = document.getElementById("formatted-content");
    const btnContainer = document.getElementById("button-container");
    const quickLinks = document.getElementById("quick-links");

    // 1. 텍스트 구조화 (마크다운 기반 시각화)
    let processedHtml = rawText;

    // 프로필 분석 섹션 카드화
    processedHtml = processedHtml.replace(/\*\*사용자 프로필 분석:\*\*/g,
            '<div class="profile-box"><h5 class="fw-bold text-primary mb-3"><i class="fa-solid fa-user-check me-2"></i>사용자 프로필 분석</h5>');

    // 추천 장학금 목록 타이틀
    processedHtml = processedHtml.replace(/### \*\*추천 장학금 목록\*\*/g,
            '</div><h4 class="fw-bold mt-5 mb-4 border-bottom pb-2"><i class="fa-solid fa-award me-2 text-primary"></i>AI 추천 장학금 리스트</h4>');

    // 개별 장학금 항목을 깔끔한 카드로 변환
    processedHtml = processedHtml.replace(/(\d+)\. \*\*\[ID:(\d+)\](.*?)\*\*/g,
            '<div class="scholar-item"><span class="id-badge mb-2 d-inline-block">추천 $1 | ID:$2</span><h5 class="fw-bold text-dark">$3</h5>');

    // 추천 이유 강조
    processedHtml = processedHtml.replace(/\*\*추천 이유:\*\*/g,
            '<p class="mt-3 mb-1"><span class="badge bg-light text-primary border px-2 py-1">AI 컨설턴트 의견</span><br>');

    // 닫는 태그 처리
    processedHtml = processedHtml.replace(/\n\n/g, '</p></div>');

    formattedDiv.innerHTML = processedHtml;

    // 2. 버튼 생성 로직 (ID 추출)
    const regex = /\[ID:(\d+)\]/g;
    let match;
    const ids = new Set();

    while ((match = regex.exec(rawText)) !== null) {
      ids.add(match[1]);
    }

    if (ids.size > 0) {
      quickLinks.classList.remove("d-none");
      ids.forEach(id => {
        const btn = document.createElement("a");
        btn.href = "/detail.do?id=" + id;
        btn.className = "btn btn-recommend rounded-pill px-3 shadow-sm";
        // \${id} 를 사용하여 JSP EL과 충돌 방지
        btn.innerHTML = `<i class="fa-solid fa-magnifying-glass me-1"></i> [ID:\${id}] 상세보기`;
        btnContainer.appendChild(btn);
      });
    }
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>