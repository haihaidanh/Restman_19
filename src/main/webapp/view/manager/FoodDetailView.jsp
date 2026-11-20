<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page
        import="java.util.List, java.util.ArrayList, restman.model.Food, restman.model.Dish, restman.model.Combo, restman.model.Image, restman.dao.FoodDAO" %>
<%@ page import="restman.dao.ImageDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    Food monAn = (Food) request.getAttribute("food");
    if (monAn == null) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                monAn = new FoodDAO().getFood(Integer.parseInt(idStr));
            } catch (Exception ignored) {}
        }
    }
    if (monAn == null) {
        response.sendRedirect("FoodManagementView.jsp");
        return;
    }

    boolean isCombo = (monAn instanceof Combo || "Combo".equalsIgnoreCase(monAn.getType()));
    String typeParam = isCombo ? "combo" : "dish";
    String loaiHienThi = isCombo ? "Combo" : "Món ăn";

    List<String> urls = new ArrayList<>();
    if (monAn.getThumbnail() != null && !monAn.getThumbnail().trim().isEmpty()) {
        urls.add(monAn.getThumbnail().trim());
    }
    if (!isCombo) {
        List<Image> images = new ImageDAO().getImagesByDishId(monAn.getId());
        for (Image im : images) {
            String u = im.getImageUrl();
            if (u != null && !u.trim().isEmpty() && !urls.contains(u.trim())) {
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
%>
<html>
<head>
    <title>Chi tiết món ăn</title>
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
            max-width: 960px;
            margin: 36px auto;
            padding: 0 16px;
        }

        .card {
            background: white;
            border: 1px solid black;
            display: flex;
            flex-wrap: wrap;
            overflow: hidden;
        }

        .card-left {
            flex: 0 0 400px;
            max-width: 100%;
            padding: 24px;
            background: #fafafa;
            border-right: 1px solid #eee;
        }

        .slider-wrap {
            position: relative;
        }

        .slider {
            display: flex;
            overflow-x: auto;
            scroll-snap-type: x mandatory;
            scrollbar-width: none;
            border-radius: 8px;
            background: #dfe6e9;
        }

        .slider::-webkit-scrollbar {
            display: none;
        }

        .slide {
            flex: 0 0 100%;
            height: 290px;
            scroll-snap-align: center;
        }

        .slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .placeholder {
            height: 290px;
            border-radius: 8px;
            background: #dfe6e9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: #b2bec3;
        }

        .nav-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 50%;
            background: rgba(0, 0, 0, .45);
            color: white;
            font-size: 1.3rem;
            cursor: pointer;
            line-height: 1;
        }

        .nav-btn:hover {
            background: rgba(0, 0, 0, .7);
        }

        .nav-prev {
            left: 8px;
        }

        .nav-next {
            right: 8px;
        }

        .counter {
            position: absolute;
            right: 10px;
            bottom: 10px;
            background: rgba(0, 0, 0, .55);
            color: white;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: .8rem;
        }

        .thumbs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 14px;
        }

        .thumbs img {
            width: 64px;
            height: 64px;
            object-fit: cover;
            border-radius: 6px;
            border: 2px solid transparent;
            cursor: pointer;
            opacity: .65;
            transition: opacity .15s, border-color .15s;
        }

        .thumbs img:hover {
            opacity: 1;
        }

        .thumbs img.active {
            border-color: #2980b9;
            opacity: 1;
        }

        .card-right {
            flex: 1;
            min-width: 280px;
            padding: 28px 32px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card-right h2 {
            font-size: 1.6rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            background: #2980b9;
            color: white;
            border-radius: 20px;
            font-size: .8rem;
            margin-bottom: 18px;
        }

        .row {
            display: flex;
            gap: 10px;
            margin-bottom: 12px;
        }

        .label {
            font-weight: bold;
            min-width: 100px;
            color: #555;
        }

        .value {
            color: #333;
            flex: 1;
        }

        .actions {
            margin-top: 26px;
            display: flex;
            justify-content: flex-end;
            padding-top: 26px;
        }

        .btn-edit {
            display: inline-block;
            padding: 11px 28px;
            background: #e67e22;
            color: white;
            border-radius: 6px;
            font-size: 1rem;
            text-decoration: none;
        }

        .btn-edit:hover {
            background: #ca6f1e;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="FoodManagementView.jsp">← Quay lại</a>
    <h2>Chi tiết món ăn</h2>
</div>

<div class="container">
    <div class="card">

        <div class="card-left">
            <% if (urls.isEmpty()) { %>
            <div class="placeholder">🍽</div>
            <% } else { %>
            <div class="slider-wrap">
                <div class="slider" id="slider">
                    <% for (String u : urls) { %>
                    <div class="slide"><img src="<%= u %>" alt="<%= monAn.getName() %>"/></div>
                    <% } %>
                </div>
            </div>

            <div class="thumbs" id="thumbs">
                <% for (int i = 0; i < urls.size(); i++) { %>
                <img src="<%= urls.get(i) %>" alt=""
                     class="<%= i == 0 ? "active" : "" %>"
                     onclick="goTo(<%= i %>)"/>
                <% } %>
            </div>
            <% } %>
        </div>

        <div class="card-right">
            <div>
                <div style="display: flex; align-items: center;gap: 10px">
                    <h2><%= monAn.getName() %>
                    </h2>
                    <span class="badge"><%= loaiHienThi %></span>
                </div>


                <div class="row">
                    <span class="label">Mã món ăn:</span>
                    <span class="value">#<%= monAn.getId() %></span>
                </div>
                <div class="row">
                    <span class="label">Giá:</span>
                    <span class="value"><strong><%= String.format("%,.0f", monAn.getPrice()) %> VNĐ</strong></span>
                </div>
                <% if (isCombo && monAn instanceof Combo) {
                    Combo combo = (Combo) monAn;
                    String endDateStr = "Không thời hạn";
                    if (combo.getEndDate() != null) {
                        endDateStr = new java.text.SimpleDateFormat("dd/MM/yyyy").format(combo.getEndDate());
                    }
                %>
                <div class="row">
                    <span class="label">Ngày kết thúc:</span>
                    <span class="value"><strong><%= endDateStr %></strong></span>
                </div>
                <% } %>
                <div class="row">
                    <span class="label">Mô tả:</span>
                    <span class="value"><%= monAn.getDescription() != null && !monAn.getDescription().isEmpty()
                            ? monAn.getDescription() : "(Chưa có mô tả)" %></span>
                </div>
            </div>

            <div class="actions">
                <a class="btn-edit" href="EditFormView.jsp?id=<%= monAn.getId() %>&type=<%= typeParam %>">
                    Sửa thông tin
                </a>
            </div>
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
        slider.scrollTo({left: i * slider.clientWidth, behavior: 'smooth'});
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
        document.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowLeft') step(-1);
            if (e.key === 'ArrowRight') step(1);
        });
    }
</script>

</body>
</html>