<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../common/top.jsp" />

<c:set var="now" value="<%= new java.util.Date() %>" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayStr" />
<fmt:parseDate value="${todayStr}" pattern="yyyy-MM-dd" var="todayDate" />

<div class="container" style="padding-top: 150px; padding-bottom: 100px;">
    <h3 class="fw-bold mb-4 text-center">⏰ 마감 임박 장학금 알림</h3>

    <div class="row justify-content-center">
        <div class="col-md-10">
            <c:choose>
                <c:when test="${not empty scrapList}">
                    <c:forEach var="item" items="${scrapList}">
                        <fmt:parseDate value="${item.deadline}" pattern="yyyy-MM-dd" var="deadlineDate" />
                        <c:set var="diff" value="${deadlineDate.time - todayDate.time}" />
                        <fmt:formatNumber value="${diff / (1000 * 60 * 60 * 24)}" var="dDay" pattern="#" />

                        <div class="card shadow-sm border-0 mb-3"
                             style="border-left: 5px solid ${item.sourceType == 'API' ? '#198754' : '#0d6efd'} !important;">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="badge ${item.sourceType == 'API' ? 'bg-success' : 'bg-primary'} mb-2">
                                            ${item.sourceType == 'API' ? '공공' : '자체'}
                                    </span>
                                    <h5 class="fw-bold mb-1">${item.title}</h5>
                                    <p class="text-muted small mb-0">${item.organization} | 마감: ${item.deadline}</p>
                                </div>
                                <div class="text-end">
                                    <span class="badge ${dDay < 0 ? 'bg-secondary' : (dDay <= 3 ? 'bg-danger' : 'bg-primary')} px-3 py-2 fs-6">
                                        <c:choose>
                                            <c:when test="${dDay < 0}">기간만료</c:when>
                                            <c:when test="${dDay == 0}">오늘마감</c:when>
                                            <c:otherwise>D-${dDay}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <div class="mt-2">
                                        <a href="detail.do?id=${item.refId}&isApi=${item.sourceType == 'API' ? 1 : 0}" class="btn btn-sm btn-outline-dark rounded-pill">상세보기</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <p class="text-muted fs-5">관심 등록한 장학금이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="../common/bottom.jsp" />