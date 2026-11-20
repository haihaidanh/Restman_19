<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, restman.model.*, restman.dao.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String foodIdStr = request.getParameter("foodId");
    String resIdStr = request.getParameter("reservationId");

    if (foodIdStr == null || resIdStr == null) {
        response.sendRedirect("TableReservationListView.jsp");
        return;
    }
    int foodId = Integer.parseInt(foodIdStr);
    int reservationId = Integer.parseInt(resIdStr);

    FoodDAO foodDAO = new FoodDAO();
    Food monAn = foodDAO.getFood(foodId);
    if (monAn == null) {
        response.sendRedirect("OrderFoodView.jsp?reservationId=" + reservationId);
        return;
    }

    List<String> urls = new ArrayList<>();

    if (monAn.getThumbnail() != null &&
            !monAn.getThumbnail().trim().isEmpty()) {
        urls.add(monAn.getThumbnail().trim());
    }

    if (monAn instanceof Dish) {
        for (Image im : ((Dish) monAn).getImages()) {
            String u = im.getImageUrl();

            if (u != null && !u.trim().isEmpty()
                    && !urls.contains(u.trim())) {
                urls.add(u.trim());
            }
        }
    }

    String ctx = request.getContextPath();

    for (int i = 0; i < urls.size(); i++) {
        String u = urls.get(i);

        if (!u.startsWith("http")) {
            urls.set(i, ctx + "/" + u.replaceFirst("^/+", ""));
        }
    }

    String loi = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String soLuongStr = request.getParameter("soLuongMon");
        String ghiChu = request.getParameter("ghiChu");
        if (ghiChu != null) ghiChu = ghiChu.trim();
        if (ghiChu != null && ghiChu.isEmpty()) ghiChu = null;
        int soLuong = 1;
        try {
            soLuong = Integer.parseInt(soLuongStr);
        } catch (Exception ignored) {
        }

        if (soLuong < 1) {
            loi = "Số lượng phải lớn hơn 0.";
        } else {
            @SuppressWarnings("unchecked")
            List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }

            boolean found = false;
            for (OrderDetail od : cart) {
                if (od.getFood().getId() == foodId) {
                    od.setQuantity(od.getQuantity() + soLuong);
                    if (ghiChu != null) od.setNote(ghiChu);
                    found = true;
                    break;
                }
            }
            if (!found) {
                cart.add(new OrderDetail(monAn, soLuong, ghiChu));
            }

            response.sendRedirect("OrderFoodView.jsp?reservationId=" + reservationId);
            return;
        }
    }
%>
<html>
<head>
    <title>Chọn số lượng</title>
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
            max-width: 820px;
            margin: 36px auto;
            padding: 0 16px;
        }

        .card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
        }

        .card-left {
            width: 340px;
            flex-shrink: 0;
            background: #dfe6e9;
        }

        .slider-wrap {
            position: relative;
        }

        .slider {
            display: flex;
            overflow-x: auto;
            scroll-snap-type: x mandatory;
            scrollbar-width: none;
            background: #dfe6e9;
        }

        .slider::-webkit-scrollbar {
            display: none;
        }

        .slide {
            flex: 0 0 100%;
            height: 320px;
            scroll-snap-align: center;
        }

        .slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }


        .thumbs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 14px;
            padding: 10px;
        }

        .thumbs img {
            width: 64px;
            height: 64px;
            object-fit: cover;
            border-radius: 6px;
            border: 2px solid transparent;
            cursor: pointer;
            opacity: .65;
        }

        .thumbs img.active {
            border-color: #2980b9;
            opacity: 1;
        }

        .card-img-placeholder {
            width: 100%;
            height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: #b2bec3;
        }

        .card-img-placeholder {
            width: 100%;
            height: 100%;
            min-height: 320px;
            background: #dfe6e9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: #b2bec3;
        }

        .card-body {
            padding: 28px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card-body h2 {
            font-size: 1.4rem;
            color: #16a085;
            margin-bottom: 6px;
        }

        .price {
            font-size: 1.1rem;
            color: #e67e22;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .desc {
            color: #666;
            line-height: 1.6;
            margin-bottom: 16px;
            font-size: .95rem;
        }

        .alert-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            color: #c0392b;
            border-radius: 6px;
            padding: 12px 16px;
            margin-bottom: 16px;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            color: #555;
        }

        .form-group input[type=number] {
            width: 120px;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1.1rem;
        }

        .btn-row {
            display: flex;
            gap: 14px;
            margin-top: 10px;
        }

        .btn-luu {
            padding: 11px 30px;
            background: #ca6f1e;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn-luu:hover {
            background: #1abc9c;
        }


        .form-group textarea {
            width: 100%;
            min-height: 70px;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            font-family: inherit;
            resize: vertical;
        }

        .form-group textarea:focus {
            outline: none;
            border-color: #16a085;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="OrderFoodView.jsp?reservationId=<%= reservationId %>">← Quay lại</a>
</div>

<div class="container">
    <% if (loi != null) { %>
    <div class="alert-error">❌ <%= loi %>
    </div>
    <% } %>

    <div class="card">
        <div class="card-left">
            <% if (urls.isEmpty()) { %>

            <div class="card-img-placeholder">🍜</div>

            <% } else { %>

            <div class="slider-wrap">
                <div class="slider" id="slider">
                    <% for (String u : urls) { %>
                    <div class="slide">
                        <img src="<%= u %>"
                             alt="<%= monAn.getName() %>"/>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="thumbs" id="thumbs">
                <% for (int i = 0; i < urls.size(); i++) { %>
                <img src="<%= urls.get(i) %>"
                     class="<%= i == 0 ? "active" : "" %>"
                     onclick="goTo(<%= i %>)"
                     alt=""/>
                <% } %>
            </div>

            <% } %>
        </div>

        <div class="card-body">
            <div>
                <h2><%= monAn.getName() %>
                </h2>
                <div class="price"><%= String.format("%,.0f", monAn.getPrice()) %> VNĐ / phần</div>
                <div class="desc">
                    <%= monAn.getDescription() != null && !monAn.getDescription().isEmpty()
                            ? monAn.getDescription() : "(Chưa có mô tả)" %>
                </div>
            </div>

            <form method="post">
                <input type="hidden" name="foodId" value="<%= foodId %>"/>
                <input type="hidden" name="reservationId" value="<%= reservationId %>"/>

                <div class="form-group">
                    <label for="soLuongMon">Số lượng</label>
                    <input type="number" id="soLuongMon" name="soLuongMon"
                           value="1" min="1" max="99" required/>
                </div>

                <div class="form-group">
                    <label for="ghiChu">Ghi chú</label>
                    <textarea id="ghiChu" name="ghiChu" maxlength="255"
                              placeholder="Ví dụ: ít cay, không hành..."></textarea>
                </div>

                <div class="btn-row">
                    <button type="submit" class="btn-luu">Thêm vào giỏ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    var slider = document.getElementById('slider');
    var thumbs = document.querySelectorAll('#thumbs img');
    var counter = document.getElementById('counter');
    var total = <%= urls.size() %>;

    function current() {
        return Math.round(slider.scrollLeft / slider.clientWidth);
    }

    function goTo(i) {
        i = Math.max(0, Math.min(total - 1, i));
        slider.scrollTo({
            left: i * slider.clientWidth,
            behavior: 'smooth'
        });
    }

    function step(d) {
        goTo(current() + d);
    }

    function refresh() {
        var i = current();

        for (var k = 0; k < thumbs.length; k++) {
            thumbs[k].classList.toggle('active', k === i);
        }

        counter.textContent = (i + 1) + ' / ' + total;
    }

    if (slider) {
        slider.addEventListener('scroll', refresh);
    }
</script>

</body>
</html>