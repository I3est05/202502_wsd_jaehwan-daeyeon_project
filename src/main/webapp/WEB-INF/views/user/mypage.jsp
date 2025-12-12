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
        body { background-color: #f8f9fa; padding-top: 80px; padding-bottom: 80px;}
        .mypage-header { background: linear-gradient(rgba(13, 110, 253, 0.8), rgba(13, 110, 253, 0.6)), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            color: white; padding: 40px 0; margin-bottom: 30px; border-radius: 10px; }
        .user-info-card { border-left: 4px solid #0d6efd; }
        .nav-link.active { background-color: #e9ecef !important; font-weight: bold; color: #0d6efd !important; }
        footer { background-color: #343a40; color: #ccc; padding: 30px 0; margin-top: 80px; }
    </style>
</head>
<body>
<jsp:include page="../common/top.jsp" />
<div class="container">
    <div class="mypage-header text-center">
        <h1 class="display-5 fw-bold"><i class="fa-solid fa-user-circle me-2"></i> ${user.userId}님의 마이페이지</h1>
        <p class="lead">내 정보 관리 및 장학금 신청 현황을 확인하세요.</p>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div class="list-group">
                <a href="/mypage" class="list-group-item list-group-item-action active">
                    <i class="fa-solid fa-address-card me-2"></i> 내 정보 요약
                </a>
                <a href="#" class="list-group-item list-group-item-action">
                    <i class="fa-solid fa-list-check me-2"></i> 신청 장학금 현황
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
            <div class="card p-4 user-info-card">
                <h4 class="card-title mb-4">개인 정보 및 스펙</h4>
                <table class="table table-striped">
                    <tbody>
                    <tr>
                        <th scope="row">아이디 (User ID)</th>
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

                <div class="mt-4 text-end">
                    <a href="mypage/edit" class="btn btn-warning"><i class="fa-solid fa-pencil me-2"></i> 정보 수정</a>
                </div>
            </div>
        </div>
    </div>
</div>
<footer>
    <jsp:include page="../common/bottom.jsp" />
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>