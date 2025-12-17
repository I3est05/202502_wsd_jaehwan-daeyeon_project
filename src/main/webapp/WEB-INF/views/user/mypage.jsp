<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - ${user.userId}님</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; padding-top: 80px;}
        .mypage-header { background: linear-gradient(rgba(13, 110, 253, 0.8), rgba(13, 110, 253, 0.6)), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            color: white; padding: 40px 0; margin-bottom: 30px; border-radius: 10px; }
        .user-info-card { border-left: 4px solid #0d6efd; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .nav-link.active { background-color: #e9ecef !important; font-weight: bold; color: #0d6efd !important; }
        footer { background-color: #343a40; color: #ccc; padding: 30px 0; margin-top: 80px; }
        /* 찜 목록 테이블 스타일 */
        .scrap-table th { background-color: #f1f3f5; }
        .btn-delete-scrap:hover { color: #dc3545 !important; }
    </style>
</head>
<body>
<jsp:include page="../common/top.jsp" />
<div class="container">
    <div class="mypage-header text-center">
        <h1 class="display-5 fw-bold"><i class="fa-solid fa-user-circle me-2"></i> ${user.userId}님의 마이페이지</h1>
        <p class="lead">내 정보 관리 및 찜한 장학금 목록을 확인하세요.</p>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div class="list-group shadow-sm">
                <a href="/mypage" class="list-group-item list-group-item-action active">
                    <i class="fa-solid fa-address-card me-2"></i> 내 정보 요약
                </a>
                <a href="#scrap-list-section" class="list-group-item list-group-item-action">
                    <i class="fa-solid fa-heart text-danger me-2"></i> 찜한 장학금 현황
                </a>
                <a href="#" class="list-group-item list-group-item-action">
                    <i class="fa-solid fa-chart-bar me-2"></i> 컨설팅 리포트
                </a>
                <a href="/logout" class="list-group-item list-group-item-action text-danger">
                    <i class="fa-solid fa-right-from-bracket me-2"></i> 로그아웃
                </a>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card p-4 user-info-card mb-4">
                <h4 class="card-title mb-4"><i class="fa-solid fa-user-tag me-2 text-primary"></i> 개인 정보 및 스펙</h4>
                <table class="table table-striped">
                    <tbody>
                    <tr>
                        <th scope="row" style="width: 30%;">아이디 (User ID)</th>
                        <td>${user.userId}</td>
                    </tr>
                    <tr>
                        <th scope="row">이메일</th>
                        <td>${user.email}</td>
                    </tr>
                    <tr>
                        <th scope="row">학점 (GPA)</th>
                        <td><span class="fw-bold text-success">${user.gpa}</span> / 4.5</td>
                    </tr>
                    <tr>
                        <th scope="row">소득분위</th>
                        <td>${user.incomeBracket} 구간</td>
                    </tr>
                    <tr>
                        <th scope="row">가입일</th>
                        <td>${user.createdAt}</td>
                    </tr>
                    </tbody>
                </table>
                <div class="mt-2 text-end">
                    <a href="mypage/edit" class="btn btn-sm btn-warning"><i class="fa-solid fa-pencil me-2"></i> 정보 수정</a>
                </div>
            </div>

            <div id="scrap-list-section" class="card p-4 user-info-card shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="card-title mb-0">
                        <i class="fa-solid fa-star text-warning me-2"></i> 찜한 장학금 현황
                    </h4>
                    <span class="badge bg-primary px-3">${scrapList.size()}건 저장됨</span>
                </div>

                <c:choose>
                    <c:when test="${not empty scrapList}">
                        <div class="table-responsive">
                            <table class="table table-hover scrap-table align-middle">
                                <thead class="table-light">
                                <tr>
                                    <th>장학금 명</th>
                                    <th>기관</th>
                                    <th class="text-center">상세보기</th>
                                    <th class="text-center">삭제</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="scrap" items="${scrapList}">
                                    <tr>
                                        <td class="fw-bold text-truncate" style="max-width: 250px;">
                                                ${scrap.title}
                                        </td>
                                        <td><span class="badge bg-light text-dark border">${scrap.organization}</span></td>
                                        <td class="text-center">
                                            <a href="detail.do?id=${scrap.refId}" class="btn btn-sm btn-outline-primary">
                                                확인하기
                                            </a>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-link text-muted btn-delete-scrap"
                                                    onclick="deleteScrap('${scrap.refId}', '${scrap.title}')">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fa-solid fa-folder-open fa-3x text-muted mb-3"></i>
                            <p class="text-muted">아직 찜한 장학금이 없습니다.</p>
                            <a href="/list.do" class="btn btn-outline-primary btn-sm">장학금 목록 보기</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<footer>
    <jsp:include page="../common/bottom.jsp" />
</footer>

<script>
    function deleteScrap(id, title) {
        if(!confirm("[" + title + "] 장학금을 관심 목록에서 삭제할까요?")) return;

        // 클릭된 버튼 요소를 찾기 위해 이벤트를 이용하거나 버튼 자체를 넘길 수 있지만,
        // 가장 쉬운 방법은 클릭된 요소의 조상(tr)을 찾아 제거하는 것입니다.
        const clickedButton = event.currentTarget; // 현재 클릭된 버튼 요소

        fetch('/api/scrap/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 'scholarId': id })
        })
            .then(response => response.json())
            .then(data => {
                // 서버에서 반환한 data.isScrapped가 false면 삭제 성공
                if (data.isScrapped === false) {
                    alert("삭제되었습니다.");

                    // ✅ 새로고침 대신 DOM에서 해당 행(tr)을 즉시 삭제
                    const row = clickedButton.closest('tr'); // 버튼에서 가장 가까운 tr 태그 찾기
                    if (row) {
                        row.style.transition = "all 0.3s ease"; // 부드러운 삭제 효과
                        row.style.opacity = "0";

                        setTimeout(() => {
                            row.remove(); // 0.3초 뒤에 실제로 HTML에서 제거

                            // (옵션) 만약 리스트가 하나도 없으면 "찜한 장학금이 없습니다" 메시지 띄우기
                            const tbody = document.querySelector('.scrap-table tbody');
                            if (tbody && tbody.children.length === 0) {
                                location.reload(); // 리스트가 아예 비면 레이아웃 구성을 위해 새로고침
                            }
                        }, 300);
                    }
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>