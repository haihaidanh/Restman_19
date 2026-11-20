<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page
        import="restman.model.Food, restman.model.Dish, restman.model.Image, restman.dao.FoodDAO, restman.dao.ImageDAO" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idStr = request.getParameter("id");

    boolean thanhCong = false;
    String loi = null;

    if (idStr == null) {
        response.sendRedirect("FoodManagementView.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    FoodDAO dao = new FoodDAO();
    ImageDAO imgDao = new ImageDAO();
    String appRoot = application.getRealPath("/");

    Food old = dao.getFood(id);
    if (old == null) {
        response.sendRedirect("FoodManagementView.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newThumb = null;
        try {
            String name = request.getParameter("name");
            float price = Float.parseFloat(request.getParameter("price"));
            String desc = request.getParameter("description");

            String thumb = old.getThumbnail();
            newThumb = imgDao.saveFile(request.getPart("thumbnailFile"), appRoot);
            if (newThumb != null) thumb = newThumb;

            Dish updated = new Dish(id, name, price, desc, thumb, new Date());

            if (dao.updateFood(updated)) {
                if (newThumb != null) imgDao.deleteFile(old.getThumbnail(), appRoot);

                String[] delIds = request.getParameterValues("deleteImage");
                if (delIds != null && old instanceof Dish && ((Dish) old).getImages() != null) {
                    Set<String> del = new HashSet<>(Arrays.asList(delIds));
                    for (Image im : ((Dish) old).getImages()) {
                        if (del.contains(String.valueOf(im.getId()))) {
                            imgDao.deleteImage(im.getId(), id);
                            imgDao.deleteFile(im.getImageUrl(), appRoot);
                        }
                    }
                }

                for (Part p : request.getParts()) {
                    if ("newImages".equals(p.getName()) && p.getSize() > 0) {
                        String path = imgDao.saveFile(p, appRoot);
                        if (path != null) imgDao.addImage(id, path);
                    }
                }
                thanhCong = true;
            } else {
                imgDao.deleteFile(newThumb, appRoot);
                loi = "Cập nhật thất bại, vui lòng thử lại.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            imgDao.deleteFile(newThumb, appRoot);
            loi = "Có lỗi xảy ra: " + e.getMessage();
        }
    }

    Food monAn = dao.getFood(id);
    if (monAn == null) {
        response.sendRedirect("FoodManagementView.jsp");
        return;
    }

    String ctx = request.getContextPath();
    String thumbSrc = "";
    if (monAn.getThumbnail() != null && !monAn.getThumbnail().isEmpty()) {
        String t = monAn.getThumbnail();
        thumbSrc = t.startsWith("http") ? t : ctx + "/" + t;
    }
%>
<html>
<head>
    <title>Sửa thông tin món ăn – RestMan</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            color: #000;
        }

        body {
            font-family: Arial, sans-serif;
            color: #000;
            background: #fff;
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
            color: white;
            text-decoration: none;
            font-size: .9rem;
        }

        .navbar a:hover {
            color: #ddd;
        }

        .navbar h2 {
            font-size: 1.1rem;
            flex: 1;
            color: white;
        }

        .container {
            max-width: 640px;
            margin: 36px auto;
            padding: 0 16px;
        }

        .alert-success {
            background: #d5f5e3;
            border: 1px solid #27ae60;
            color: #000;
            border-radius: 6px;
            padding: 14px 18px;
            margin-bottom: 20px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background: #fdecea;
            border: 1px solid #e74c3c;
            color: #000;
            border-radius: 6px;
            padding: 14px 18px;
            margin-bottom: 20px;
        }

        .form-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, .12);
            padding: 32px 36px;
        }

        .form-card h2 {
            font-size: 1.3rem;
            color: #000;
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            color: #000;
            font-size: .95rem;
        }

        .form-group input[type=text],
        .form-group input[type=number],
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
            color: #000;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2980b9;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 90px;
        }

        .readonly-field {
            background: #ecf0f1;
            padding: 10px 14px;
            border-radius: 6px;
            color: #000;
        }

        .btn-row {
            display: flex;
            gap: 14px;
            margin-top: 26px;
        }

        .btn-sua {
            padding: 11px 30px;
            background: #2980b9;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn-sua:hover {
            background: #1f6391;
        }

        .btn-huy {
            padding: 11px 22px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-huy:hover {
            background: #c0392b;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="FoodDetailView.jsp?id=<%= monAn.getId() %>">← Quay lại</a>
    <h2>Sửa thông tin món ăn</h2>
</div>

<div class="container">

    <% if (thanhCong) { %>
    <div class="alert-success">Cập nhật thông tin món ăn thành công!</div>
    <% } %>

    <% if (loi != null) { %>
    <div class="alert-error">❌ <%= loi %>
    </div>
    <% } %>

    <div class="form-card">
        <h2>Thông tin món ăn</h2>
        <form method="post" action="EditFormView.jsp?id=<%= monAn.getId() %>"
              enctype="multipart/form-data">

            <div class="form-group">
                <label>Mã món ăn</label>
                <div class="readonly-field">#<%= monAn.getId() %>
                </div>
            </div>

            <div class="form-group">
                <label for="name">Tên món ăn <span style="color:red">*</span></label>
                <input type="text" id="name" name="name"
                       value="<%= monAn.getName() %>" required/>
            </div>

            <div class="form-group">
                <label for="price">Giá (VNĐ) <span style="color:red">*</span></label>
                <input type="number" id="price" name="price" min="0" step="1000"
                       value="<%= (int) monAn.getPrice() %>" required/>
            </div>

            <div class="form-group">
                <label for="thumbnailFile">Ảnh đại diện (thumbnail)</label>
                <img id="thumbPreview" alt=""
                     src="<%= thumbSrc %>"
                     style="height:90px;border-radius:6px;margin-bottom:8px;display:<%= thumbSrc.isEmpty() ? "none" : "block" %>"/>
                <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*"/>
            </div>

            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea id="description" name="description"
                          placeholder="Nhập mô tả..."><%= monAn.getDescription() != null ? monAn.getDescription() : "" %></textarea>
            </div>

            <div class="form-group">
                <label>Ảnh hiện có</label>
                <%
                    List<Image> imgs = (monAn instanceof Dish) ? ((Dish) monAn).getImages() : null;
                    if (imgs == null || imgs.isEmpty()) {
                %>
                <div class="readonly-field">(Chưa có ảnh)</div>
                <% } else {
                    for (Image im : imgs) {
                        String u = im.getImageUrl();
                        String src = (u != null && u.startsWith("http")) ? u : ctx + "/" + u; %>
                <label style="font-weight:normal;display:flex;align-items:center;gap:10px;margin-bottom:8px">
                    <input type="checkbox" name="deleteImage" value="<%= im.getId() %>"/>
                    <img src="<%= src %>" alt="" style="height:60px;border-radius:4px"/>
                    <span style="font-size:.85rem;color:#000">Xóa</span>
                </label>
                <% }
                } %>
            </div>

            <div class="form-group">
                <label for="newImages">Thêm ảnh mới (chọn được nhiều ảnh)</label>
                <input type="file" id="newImages" name="newImages" accept="image/*" multiple/>
            </div>

            <div class="btn-row">
                <button type="submit" class="btn-sua">
                    Lưu thay đổi
                </button>
                <a class="btn-huy" href="FoodDetailView.jsp?id=<%= monAn.getId() %>">Hủy</a>
            </div>
        </form>
    </div>

</div>

<script>
    var thumbInput = document.getElementById('thumbnailFile');
    if (thumbInput) {
        thumbInput.addEventListener('change', function () {
            var f = this.files[0], p = document.getElementById('thumbPreview');
            if (f) {
                p.src = URL.createObjectURL(f);
                p.style.display = 'block';
            }
        });
    }
</script>
</body>
</html>