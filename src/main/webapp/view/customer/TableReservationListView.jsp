<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page
        import="java.util.List, restman.model.Reservation, restman.model.ReservationDetail, restman.dao.ReservationDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    session.removeAttribute("cart");
    session.removeAttribute("reservationId");

    String timBan = request.getParameter("timBan");
    ReservationDAO dao = new ReservationDAO();
    List<Reservation> banDat = dao.getReservations(timBan);
%>
<html>
<head>
    <title>Tìm bàn đặt</title>
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

        .container {
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 16px;
        }

        h2.title {
            margin-bottom: 20px;
            font-size: 1.3rem;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
        }

        .search-form input {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
        }

        .search-form button {
            padding: 10px 22px;
            background: #16a085;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .search-form button:hover {
            background: #1abc9c;
        }

        table {
            width: 100%;
            background: white;
            overflow: hidden;
        }

        thead {
            color: black;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
        }


        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: .8rem;
            font-weight: bold;
        }

        .btn-select {
            padding: 6px 16px;
            color: #2980b9;
            border: none;
            border-radius: 5px;
            font-size: .88rem;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-select:hover {
            background: #1f6391;
            color: white;
        }

        .badge-confirmed {
            color: #155724;
        }

        .badge-pending {
            color: #856404;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: #888;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="${pageContext.request.contextPath}/view/MainView.jsp">← Quay lại</a>
    <h2>Bàn đặt</h2>
</div>

<div class="container">
    <h2 class="title">Danh sách bàn đã đặt</h2>

    <form class="search-form" method="get">
        <input type="text" name="timBan"
               placeholder="Nhập số điện thoại khách hàng..."
               value="<%= timBan != null ? timBan : "" %>"/>
        <button type="submit">Tìm kiếm</button>
    </form>

    <%
        if (banDat == null || banDat.isEmpty()) {
    %>
    <div class="empty">
        <% if (timBan != null && !timBan.trim().isEmpty()) { %>
        Không tìm thấy bàn đặt nào với số điện thoại "<%= timBan %>".
        <% } else { %>
        Hiện tại không có bàn đặt nào ở trạng thái PENDING hoặc CONFIRMED.
        <% } %>
    </div>
    <%
    } else {
    %>
    <table>
        <thead>
        <tr>
            <th>#</th>
            <th>Khách hàng</th>
            <th>SĐT</th>
            <th>Giờ đặt</th>
            <th>Số khách</th>
            <th>Bàn</th>
            <th>Trạng thái</th>
            <th>Chọn</th>
        </tr>
        </thead>
        <tbody>
        <%
            int stt = 1;
            for (Reservation r : banDat) {
                String tableInfo = "(chưa xác định)";
                if (r.getDetails() != null && !r.getDetails().isEmpty()) {
                    ReservationDetail rd = r.getDetails().get(0);
                    tableInfo = "Bàn #" + rd.getTable().getId()
                            + (rd.getTable().getLocation() != null ? " – " + rd.getTable().getLocation() : "");
                }
                String badgeClass = "badge-pending";
                if (r.getStatus() == Reservation.Status.CONFIRMED) badgeClass = "badge-confirmed";
        %>
        <tr>
            <td><%= stt++ %>
            </td>
            <td><%= r.getCustomer().getName() != null ? r.getCustomer().getName() : "(N/A)" %>
            </td>
            <td><%= r.getCustomer().getPhoneNumber() %>
            </td>
            <td><%= r.getReservationTime() != null ? r.getReservationTime() : "(N/A)" %>
            </td>
            <td><%= r.getNumberOfGuests() %>
            </td>
            <td><%= tableInfo %>
            </td>
            <td><span class="badge <%= badgeClass %>">
                <% if (r.getStatus() == Reservation.Status.CONFIRMED) {%>
                    Đã xác nhận
                <% } else { %>
                    Chờ xác nhận
                <% } %>
            </span></td>
            <td>
                <a class="btn-select"
                   href="OrderFoodView.jsp?reservationId=<%= r.getId() %>">
                    Đặt món
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