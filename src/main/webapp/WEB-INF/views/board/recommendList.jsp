<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../common/top.jsp" />

<style>
    body { padding-top: 100px; background-color: #f4f7f9; }
    .recommend-header { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); margin-bottom: 40px; }
    .match-card { border: none; border-radius: 15px; transition: 0.3s; overflow: hidden; }
    .match-card:hover { transform: translateY(-10px); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
    .percent-text { font-size: 1.5rem; font-weight: 800; color: #0d6efd; }
</style>

<div class="container mb-5">
    <div class="recommend-header text-center">
        <h2 class="fw-bold">✨ ${user.userId}님을 위한 맞춤 분석 결과</h2>
        <p class="text-muted">입력하신 학과(${user.department}), 성적(${user.gpa}), 소득분위(${user.incomeBracket}분위)를 바탕으로 산출되었습니다.</p>
    </div>

    <div class="row g-4">
        <c:forEach var="s" items="${recommendList}">
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 match-card shadow-sm" onclick="location.href='detail.do?id=${s.refId}'" style="cursor:pointer;">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="percent-text">${s.matchPercent}%</span>
                            <span class="badge bg-light text-primary border border-primary-subtle">적합도 높음</span>
                        </div>

                        <div class="progress mb-4" style="height: 8px;">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: ${s.matchPercent}%"></div>
                        </div>

                        <h5 class="fw-bold mb-2 text-truncate">${s.title}</h5>
                        <p class="text-secondary small mb-3"><i class="fa-solid fa-building me-1"></i>${s.organization}</p>

                        <div class="bg-light p-3 rounded-3 small">
                            <strong>내 조건과 매칭:</strong><br>
                            <span class="${s.description.contains(user.department) ? 'text-primary' : 'text-muted'}">#${user.department}</span>
                            <span class="${s.description.contains('소득') ? 'text-primary' : 'text-muted'}">#${user.incomeBracket}분위</span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<jsp:include page="../common/bottom.jsp" />