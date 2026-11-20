<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="restman.model.Account" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null) {
        response.sendRedirect(request.getContextPath() + "/view/LoginView.jsp");
        return;
    }

    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/view/LoginView.jsp");
        return;
    }

    boolean isManager = account.getType() == Account.Type.MANAGER;
    boolean isCustomer = account.getType() == Account.Type.CUSTOMER;
    String roleLabel = isManager ? "Quản lý" : "Khách hàng";
    String roleColor = isManager ? "#2c3e50" : "#16a085";
%>
<html>
<head>
    <title>Trang chủ</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        .navbar {
            background: <%= roleColor %>;
            color: white;
            padding: 14px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .navbar h1 {
            font-size: 1.4rem;
        }

        .navbar .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: .92rem;
        }

        .navbar .badge-role {
            background: #FFFFFF33;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: .8rem;
        }

        .btn-logout {
            padding: 7px 16px;
            background: #FFFFFF26;
            color: white;
            border: 1px solid #FFFFFF66;
            border-radius: 6px;
            font-size: .88rem;
            cursor: pointer;
            text-decoration: none;
        }


        .menu {
            display: flex;
            gap: 24px;
            justify-content: center;
            padding: 70px 20px;
        }

        .card {
            background: white;
            border-radius: 12px;
            width: 220px;
            padding: 36px 20px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            color: #2c3e50;
        }

        .card h3 {
            font-size: 1rem;
        }
        .welcome strong {
            color: <%= roleColor %>;
        }

    </style>
</head>
<body>

<div class="navbar">
    <h1>Hai Restaurant</h1>
    <div class="user-info">
        <span>Xin chào, <strong><%= account.getUsername() %></strong></span>
        <span class="badge-role"><%= roleLabel %></span>
        <a class="btn-logout" href="${pageContext.request.contextPath}/view/MainView.jsp?action=logout">Đăng xuất</a>
    </div>
</div>

<div class="menu">

    <% if (isManager) { %>
    <a class="card card-manager"
       href="${pageContext.request.contextPath}/view/manager/FoodManagementView.jsp">
        <h3>Quản lý món ăn</h3>
    </a>
    <% } %>

    <% if (isCustomer) { %>
    <a class="card card-customer"
       href="${pageContext.request.contextPath}/view/customer/TableReservationListView.jsp">
        <h3>Đặt món trực tuyến</h3>
    </a>
    <% } %>

</div>

</body>
</html>
