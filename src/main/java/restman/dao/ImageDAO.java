package restman.dao;

import jakarta.servlet.http.Part;
import restman.model.Image;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ImageDAO extends DAO {

    public ImageDAO() {
        super();
    }

    public List<Image> getImagesByDishId(int dishId) {
        List<Image> list = new ArrayList<>();
        String sql = "SELECT id, imageUrl FROM image WHERE dish_id = ? ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, dishId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Image(rs.getInt("id"), rs.getString("imageUrl")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addImage(int dishId, String imageUrl) {
        String sql = "INSERT INTO image(imageUrl, dish_id) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, imageUrl);
            ps.setInt(2, dishId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImage(int imageId, int dishId) {
        String sql = "DELETE FROM image WHERE id = ? AND dish_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.setInt(2, dishId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String saveFile(Part part, String appRoot) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        String name = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        int dot = name.lastIndexOf('.');
        String ext = dot < 0 ? "" : name.substring(dot + 1).toLowerCase();
        if (!List.of("jpg", "jpeg", "png", "gif", "webp").contains(ext)) {
            throw new IOException("Định dạng ảnh không hợp lệ: " + name);
        }

        File dir = new File(appRoot, "uploads");
        dir.mkdirs();
        String fileName = UUID.randomUUID() + "." + ext;
        try (InputStream in = part.getInputStream()) {
            Files.copy(in, new File(dir, fileName).toPath());
        }
        return "uploads/" + fileName;
    }

    public void deleteFile(String path, String appRoot) {
        if (path == null || !path.startsWith("uploads/") || path.contains("..")) return;
        new File(appRoot, path).delete();
    }
}