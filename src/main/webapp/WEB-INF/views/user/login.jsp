<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - 돈주까</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .auth-card { width: 100%; max-width: 400px; padding: 40px; border-radius: 15px; background: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .brand-title { color: #0d6efd; font-weight: bold; font-size: 2rem; text-align: center; margin-bottom: 30px; text-decoration: none; display: block; }
        .form-control { border-radius: 10px; padding: 12px; }
        .btn-auth { width: 100%; padding: 12px; font-weight: bold; border-radius: 10px; font-size: 1.1rem; }
    </style>
</head>
<body>
<div class="auth-card">
    <a href="${pageContext.request.contextPath}/" class="brand-title">DONJOOGGA</a>

    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div class="mb-3">
            <label class="form-label fw-bold">아이디</label>
            <input type="text" name="userId" class="form-control" placeholder="아이디" required>
        </div>
        <div class="mb-4">
            <label class="form-label fw-bold">비밀번호</label>
            <input type="password" name="password" class="form-control" placeholder="비밀번호" required>
        </div>
        <button type="submit" class="btn btn-primary btn-auth mb-3">로그인</button>
    </form>

    <div class="text-center text-muted">
        아직 계정이 없으신가요? <a href="${pageContext.request.contextPath}/join" class="text-primary text-decoration-none fw-bold">회원가입</a>
    </div>
</div>
</body>
</html>