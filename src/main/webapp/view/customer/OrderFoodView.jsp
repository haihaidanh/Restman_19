<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, restman.model.*, restman.dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String resIdStr = request.getParameter("reservationId");
    if (resIdStr == null) {
        response.sendRedirect("TableReservationListView.jsp");
        return;
    }
    int reservationId = Integer.parseInt(resIdStr);
    session.setAttribute("reservationId", reservationId);

    @SuppressWarnings("unchecked")
    List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    }

    String removeFoodId = request.getParameter("removeFoodId");
    if (removeFoodId != null) {
        try {
            int fid = Integer.parseInt(removeFoodId);
            for (int i = 0; i < cart.size(); i++) {
                OrderDetail od = cart.get(i);
                if (od.getFood() != null && od.getFood().getId() == fid) {
                    cart.remove(i);
                    break;
                }
            }
        } catch (Exception ignored) {}
        response.sendRedirect("OrderFoodView.jsp?reservationId=" + reservationId);
        return;
    }

    boolean thanhCong = false;
    String loi = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (cart.isEmpty()) {
            loi = "Giỏ hàng trống, vui lòng chọn ít nhất 1 món.";
        } else {
            Reservation res = new Reservation();
            res.setId(reservationId);

            OnlineOrder order = new OnlineOrder(res);
            order.setOrderDetail(new ArrayList<>(cart));

            OnlineOrderDAO dao = new OnlineOrderDAO();
            if (dao.insert(order)) {
                thanhCong = true;
                cart.clear();
                session.removeAttribute("cart");
            } else {
                loi = "Đặt món thất bại, vui lòng thử lại.";
            }
        }
    }

    String timMon = request.getParameter("timMon");
    FoodDAO foodDAO = new FoodDAO();
    List<Food> rawMonAn = foodDAO.getFood(timMon);
    List<Food> monAn = new ArrayList<>();

    Calendar cal = Calendar.getInstance();
    cal.set(Calendar.HOUR_OF_DAY, 0);
    cal.set(Calendar.MINUTE, 0);
    cal.set(Calendar.SECOND, 0);
    cal.set(Calendar.MILLISECOND, 0);
    Date todayStart = cal.getTime();

    if (rawMonAn != null) {
        for (Food f : rawMonAn) {
            if (f instanceof Combo) {
                Date endDate = ((Combo) f).getEndDate();
                if (endDate != null && endDate.before(todayStart)) {
                    continue;
                }
            }
            monAn.add(f);
        }
    }
%>
<html>
<head>
    <title>Đặt món</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            color: black;
        }

        .navbar {
            background: #16a085;
            color: white;
            padding: 14px 30px;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar a {
            color: #a8e6cf;
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

        .wrapper {
            display: flex;
            gap: 20px;
            max-width: 1100px;
            margin: 24px auto;
            padding: 0 16px;
        }

        .panel-left {
            flex: 1;
        }

        .panel-left h3 {
            margin-bottom: 14px;
        }

        .search-form {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }

        .search-form input {
            flex: 1;
            padding: 9px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: .95rem;
        }

        .search-form button {
            padding: 9px 18px;
            background: #16a085;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        table.food-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        table.food-table thead {
            color: black;
        }

        table.food-table th, table.food-table td {
            padding: 10px 14px;
            text-align: left;
        }

        table.food-table td.col-price{
            text-align: right;
            padding-right: 110px;
        }

        table.food-table tbody tr:hover {
            background: #e8f8f5;
        }

        .btn-add {
            padding: 5px 14px;
            color: #27ae60;
            border: none;
            border-radius: 5px;
            font-size: .85rem;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-add:hover {
            background: #1e8449;
            color: white;
        }

        .panel-right {
            width: 360px;
        }

        .panel-right h3 {
            margin-bottom: 14px;
            color: black;
        }

        .cart-box {
            background: white;
            border-radius: 8px;
            padding: 18px;
        }

        table.cart-table {
            width: 100%;
            border-collapse: collapse;
        }

        table.cart-table th, table.cart-table td {
            padding: 8px 10px;
            text-align: left;
            font-size: .9rem;
        }

        table.cart-table thead {
            color: black;
        }

        .btn-remove-item {
            color: #e74c3c;
            text-decoration: none;
            font-size: 0.85rem;
            padding: 2px 6px;
            border-radius: 4px;
            border: 1px solid #f5c6cb;
            background: #fff;
        }

        .btn-remove-item:hover {
            background: #fdecea;
            color: #c0392b;
            border-color: #e74c3c;
        }


        .btn-confirm {
            width: 100%;
            margin-top: 16px;
            padding: 12px;
            background: #e67e22;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn-confirm:hover {
            background: #ca6f1e;
        }


        .cart-empty {
            color: #aaa;
            font-style: italic;
            text-align: center;
            padding: 20px 0;
        }

        .alert-success {
            background: #d5f5e3;
            border: 1px solid #27ae60;
            color: #1e8449;
            border-radius: 6px;
            padding: 14px 18px;
            margin-bottom: 16px;
        }

        .alert-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            color: #c0392b;
            border-radius: 6px;
            padding: 14px 18px;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="TableReservationListView.jsp">← Quay lại</a>
    <h2>Mã đặt bàn #<%= reservationId %>
    </h2>
</div>

<div class="wrapper">

    <div class="panel-left">
        <% if (thanhCong) { %>
        <div class="alert-success">Đặt món trực tuyến thành công! Chúng tôi sẽ chuẩn bị món cho bạn.</div>
        <% } %>
        <% if (loi != null) { %>
        <div class="alert-error">❌ <%= loi %>
        </div>
        <% } %>

        <h3>Đặt món</h3>

        <form class="search-form" method="get">
            <input type="hidden" name="reservationId" value="<%= reservationId %>"/>
            <input type="text" name="timMon"
                   placeholder="Nhập tên món ăn..."
                   value="<%= timMon != null ? timMon : "" %>"/>
            <button type="submit">Tìm</button>
        </form>

        <% if (monAn != null && !monAn.isEmpty()) { %>
        <table class="food-table">
            <thead>
            <tr>
                <th>#</th>
                <th>Tên món</th>
                <th style="text-align: center">Giá</th>
                <th>Thêm</th>
            </tr>
            </thead>
            <tbody>
            <% int stt = 1;
                for (Food f : monAn) { %>
            <tr>
                <td><%= stt++ %>
                </td>
                <td><%= f.getName() %>
                </td>
                <td class="col-price"><%= String.format("%,.0f", f.getPrice()) %> </td>
                <td>
                    <a class="btn-add"
                       href="SelectQuantityView.jsp?foodId=<%= f.getId() %>&reservationId=<%= reservationId %>">
                        Chọn
                    </a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else if (timMon != null && !timMon.isEmpty()) { %>
        <p style="color:#888;margin-top:10px;">Không tìm thấy món nào.</p>
        <% } %>
    </div>

    <div class="panel-right">
        <h3>Đã chọn</h3>
        <div class="cart-box">
            <%
                @SuppressWarnings("unchecked")
                List<OrderDetail> displayCart = (List<OrderDetail>) session.getAttribute("cart");
                float tongTien = 0;
                if (displayCart == null || displayCart.isEmpty()) {
            %>
            <div class="cart-empty">Chưa có món nào được chọn.</div>
            <%
            } else {
            %>
            <table class="cart-table">
                <thead>
                <tr>
                    <th>Món</th>
                    <th>SL</th>
                    <th>Thành tiền</th>
                    <th style="width: 45px; text-align: center;">Xóa</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (OrderDetail od : displayCart) {
                        float sub = od.getPrice() * od.getQuantity();
                        tongTien += sub;
                %>
                <tr>
                    <td><%= od.getFood().getName() %></td>
                    <td><%= od.getQuantity() %></td>
                    <td><%= String.format("%,.0f", sub) %> đ</td>
                    <td style="text-align: center;">
                        <a class="btn-remove-item"
                           href="OrderFoodView.jsp?reservationId=<%= reservationId %>&removeFoodId=<%= od.getFood().getId() %>"
                           title="Xóa món này">Xóa</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <p class="total-row" style="margin-top:10px;">
                Tổng: <strong><%= String.format("%,.0f", tongTien) %> VNĐ</strong>
            </p>

            <form method="post">
                <input type="hidden" name="reservationId" value="<%= reservationId %>"/>
                <button type="submit" class="btn-confirm">Xác nhận</button>
            </form>
            <%
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
