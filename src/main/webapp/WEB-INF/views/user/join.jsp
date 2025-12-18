<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입 - 돈주까</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; padding: 50px 0; }
    .auth-card { max-width: 500px; margin: 0 auto; padding: 40px; border-radius: 15px; background: white; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
    .brand-title { color: #0d6efd; font-weight: bold; font-size: 1.8rem; text-align: center; margin-bottom: 30px; }
    .section-title { font-size: 0.9rem; color: #6c757d; margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 5px; margin-top: 20px; }
  </style>
</head>
<body>
<div class="container">
  <div class="auth-card">
    <h2 class="brand-title">회원가입</h2>

    <form action="/join" method="POST">
      <div class="section-title">기본 정보</div>
      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" name="userId" class="form-control" placeholder="아이디를 입력하세요" required>
      </div>
      <div class="mb-3">
        <label class="form-label">이메일</label>
        <input type="email" name="email" class="form-control" placeholder="example@handong.edu" required>
      </div>
      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <input type="password" name="password" class="form-control" required>
      </div>

      <div class="section-title">맞춤형 장학금 설정을 위한 추가 정보</div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">학과</label>
          <input type="text" name="department" class="form-control" placeholder="ex) 컴퓨터공학부" required>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">학년</label>
          <select name="grade" class="form-select">
            <option value="1">1학년</option>
            <option value="2">2학년</option>
            <option value="3">3학년</option>
            <option value="4">4학년</option>
          </select>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">학점 (GPA)</label>
          <input type="number" name="gpa" class="form-control" step="0.01" min="0.0" max="4.5" placeholder="ex) 3.5" required>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">소득분위</label>
          <select name="incomeBracket" class="form-control">
            <option value="0">기초생활수급자 (0구간)</option>
            <option value="1">1구간</option>
            <option value="2">2구간</option>
            <option value="3">3구간</option>
            <option value="4">4구간</option>
            <option value="5">5구간</option>
            <option value="6">6구간</option>
            <option value="7">7구간</option>
            <option value="8">8구간</option>
            <option value="9">9구간</option>
            <option value="10">10구간 (소득 높음)</option>
          </select>
        </div>
      </div>

      <div class="mb-3">
        <label class="form-label">거주지 (시/군/구)</label>
        <input type="text" name="address" class="form-control" placeholder="ex) 경상북도 포항시">
      </div>

      <div class="mb-3">
        <label class="form-label">특이사항 (선택)</label>
        <textarea name="spec" class="form-control" rows="2" placeholder="ex) 다자녀 가구, 장애인 본인, 한부모 가족 등"></textarea>
      </div>

      <button type="submit" class="btn btn-primary w-100 mt-4 py-2 fw-bold">가입하기</button>
    </form>
    <div class="text-center mt-3">
      <a href="/login" class="text-decoration-none text-muted small">이미 계정이 있으신가요? 로그인</a>
    </div>
  </div>
</div>
</body>
</html>