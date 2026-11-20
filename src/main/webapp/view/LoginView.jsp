<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="restman.model.Account, restman.dao.AccountDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("account") != null) {
        response.sendRedirect(request.getContextPath() + "/view/MainView.jsp");
        return;
    }

    String loi = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AccountDAO dao = new AccountDAO();
        Account acc = dao.login(username, password);

        if (acc != null) {
            session.setAttribute("account", acc);
            response.sendRedirect(request.getContextPath() + "/view/MainView.jsp");
            return;
        } else {
            loi = "Tên đăng nhập hoặc mật khẩu không đúng.";
        }
    }
%>
<html>
<head>
    <title>Đăng nhập</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #16a085;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            width: 100%;
            max-width: 420px;
            padding: 16px;
        }

        .logo {
            text-align: center;
            margin-bottom: 28px;
            color: white;
        }

        .logo h1 {
            font-size: 2rem;
        }

        .logo p {
            font-size: .9rem;
            opacity: .8;
            margin-top: 4px;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 36px 40px;
        }

        .card h2 {
            font-size: 1.3rem;
            color: #2c3e50;
            margin-bottom: 24px;
            text-align: center;
        }

        .alert-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            color: #c0392b;
            border-radius: 6px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: .92rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            color: #555;
            font-size: .9rem;
        }

        .form-group input {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 1rem;
        }

        .form-group input:focus {
            outline: none;
            border-color: #008c1c;
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: #16a085;
            color: white;
            border: none;
            border-radius: 7px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 6px;
        }

        .btn-login:hover {
            opacity: .88;
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="logo">
        <h1>Hai Restaurant</h1>
        <p>Hệ thống quản lý nhà hàng</p>
    </div>

    <div class="card">
        <h2>Đăng nhập</h2>

        <% if (loi != null) { %>
        <div class="alert-error"><%= loi %>
        </div>
        <% } %>

        <form method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username"
                       placeholder="Nhập tên đăng nhập..." autofocus required/>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password"
                       placeholder="Nhập mật khẩu..." required/>
            </div>
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
    </div>
</div>

</body>
</html>

