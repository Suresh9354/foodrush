package com.food.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.UserDAO;
import com.food.model.User;
import com.food.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT =
            "INSERT INTO users(name,email,password,phone,address) VALUES(?,?,?,?,?)";

    private static final String GET_BY_ID =
            "SELECT * FROM users WHERE user_id=?";

    private static final String GET_BY_EMAIL =
            "SELECT * FROM users WHERE email=?";

    private static final String GET_ALL =
            "SELECT * FROM users";

    private static final String UPDATE =
            "UPDATE users SET name=?,phone=?,address=? WHERE user_id=?";

    private static final String DELETE =
            "DELETE FROM users WHERE user_id=?";

    private static final String LOGIN =
            "SELECT * FROM users WHERE email=? AND password=?";


    @Override
    public boolean addUser(User user) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            String plainPassword = user.getPassword();
            String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
            user.setPassword(hashedPassword);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public User getUserById(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_ID)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public User getUserByEmail(String email) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_EMAIL)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_ALL)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                users.add(extractUser(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }


    @Override
    public boolean updateUser(User user) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt(4, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean deleteUser(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public User validateUser(String email, String password) {
        User user = getUserByEmail(email);
        if (user != null) {
            String storedPassword = user.getPassword();
            // Check if stored password is BCrypt hashed (starts with $2a$ or $2b$)
            if (storedPassword != null && (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$"))) {
                if (BCrypt.checkpw(password, storedPassword)) {
                    return user;
                }
            } else {
                // Fallback for legacy plaintext password
                if (password.equals(storedPassword)) {
                    // Migrate password on-the-fly to BCrypt
                    String newHashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                    updateUserPassword(user.getUserId(), newHashedPassword);
                    user.setPassword(newHashedPassword);
                    return user;
                }
            }
        }
        return null;
    }

    private void updateUserPassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private User extractUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));

        return user;
    }
}