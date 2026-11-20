<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, restman.model.Food, restman.dao.FoodDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="restman.model.Combo" %>
<%
    request.setCharacterEncoding("UTF-8");
    String timKiem = request.getParameter("timKiem");
    FoodDAO dao = new FoodDAO();

    List<Food> tatCa = dao.getFood(timKiem);

    List<Food> listMonAn = new ArrayList<>();
    for (Food f : tatCa) {
        if (!(f instanceof Combo)) {
            listMonAn.add(f);
        }
    }

    String viewId = request.getParameter("viewId");
    if (viewId != null) {
        try {
            int id = Integer.parseInt(viewId);
            for (Food f : listMonAn) {
                if (f.getId() == id) {
                    request.setAttribute("food", f);
                    request.getRequestDispatcher("FoodDetailView.jsp").forward(request, response);
                    return;
                }
            }
        } catch (NumberFormatException ignored) {
        }
    }
%>
<html>
<head>
    <title>Quản lý món ăn</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            color: black;
        }

        .navbar {
            background: #2c3e50;
            color: white;
            padding: 14px 30px;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar a {
            color: #aab;
            text-decoration: none;
            font-size: .9rem;
        }

        .navbar a:hover {
            color: white;
        }

        .navbar h2 {
            font-size: 1.1rem;
            flex: 1;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 16px;
        }

        h2.title {
            margin-bottom: 20px;
            font-size: 1.3rem;
            color: #2c3e50;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
        }

        .search-form input[type=text] {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
        }


        .search-form button {
            padding: 10px 22px;
            background: #2980b9;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .search-form button:hover {
            background: #1f6391;
        }


        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        thead {
            color: black;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
        }

        td .btn-detail {
            padding: 6px 14px;
            color: #27ae60;
            border: none;
            border-radius: 5px;
            font-size: .88rem;
            cursor: pointer;
            text-decoration: none;
        }

        td .btn-detail:hover {
            background: #1e8449;
            color: white;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: #888;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/view/MainView.jsp">← Quay lại</a>
    <h2>Quản lý thông tin món ăn</h2>
</div>

<div class="container">
    <h2 class="title">Danh sách món ăn</h2>

    <form class="search-form" method="get">
        <input type="text" name="timKiem"
               placeholder="Nhập tên món ăn để tìm kiếm..."
               value="<%= timKiem != null ? timKiem : "" %>"/>
        <button type="submit">Tìm kiếm</button>
    </form>

    <%
        if (listMonAn.isEmpty()) {
    %>
    <div class="empty">Không tìm thấy món ăn nào.</div>
    <%
    } else {
    %>
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>Tên món ăn</th>
            <th>Giá (VNĐ)</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            int stt = 1;
            for (Food f : listMonAn) {
        %>
        <tr>
            <td><%= stt++ %>
            </td>
            <td><%= f.getName() %>
            </td>
            <td><%= String.format("%,.0f", f.getPrice()) %>
            </td>
            <td>
                <a class="btn-detail"
                   href="FoodManagementView.jsp?viewId=<%= f.getId() %>">
                    Chi tiết
                </a>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        }
    %>
</div>

</body>
</html>