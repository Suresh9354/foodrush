<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "settings");

    String action = request.getParameter("action");
    UserDAO userDAO = new UserDAOImpl();
    boolean isDbConnected = true;

    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        loggedInUser = new User(5, "Admin", "admin@foodrush.com", "admin123", "+91 98765 43210", "FoodRush HQ", "admin", new java.sql.Timestamp(System.currentTimeMillis()));
        session.setAttribute("loggedInUser", loggedInUser);
        isDbConnected = false;
    } else {
        // Double check DB availability
        try {
            User test = userDAO.getUserById(loggedInUser.getUserId());
            if (test == null) {
                isDbConnected = false;
            }
        } catch (Exception e) {
            isDbConnected = false;
        }
    }

    // Process forms
    if (action != null) {
        try {
            if ("profile".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                loggedInUser.setName(name);
                loggedInUser.setEmail(email);
                loggedInUser.setPhone(phone);

                if (isDbConnected) {
                    try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(
                             "UPDATE users SET name=?, email=?, phone=? WHERE user_id=?")) {
                        ps.setString(1, name);
                        ps.setString(2, email);
                        ps.setString(3, phone);
                        ps.setInt(4, loggedInUser.getUserId());
                        ps.executeUpdate();
                    }
                }
                session.setAttribute("loggedInUser", loggedInUser);
                response.sendRedirect("settings.jsp?msg=profile_saved");
                return;
            } else if ("password".equals(action)) {
                String currentPass = request.getParameter("currentPassword");
                String newPass = request.getParameter("newPassword");
                String confirmPass = request.getParameter("confirmPassword");

                if (!loggedInUser.getPassword().equals(currentPass)) {
                    response.sendRedirect("settings.jsp?msg=password_mismatch");
                    return;
                }
                if (!newPass.equals(confirmPass)) {
                    response.sendRedirect("settings.jsp?msg=confirm_failed");
                    return;
                }

                loggedInUser.setPassword(newPass);
                if (isDbConnected) {
                    try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
                         java.sql.PreparedStatement ps = conn.prepareStatement(
                             "UPDATE users SET password=? WHERE user_id=?")) {
                         ps.setString(1, newPass);
                         ps.setInt(2, loggedInUser.getUserId());
                         ps.executeUpdate();
                    }
                }
                session.setAttribute("loggedInUser", loggedInUser);
                response.sendRedirect("settings.jsp?msg=password_saved");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("settings.jsp?msg=error");
            return;
        }
    }

    String msg = request.getParameter("msg");
    
    // Derive username from name (first word lowercase)
    String username = "admin";
    if (loggedInUser.getName() != null && !loggedInUser.getName().isEmpty()) {
        username = loggedInUser.getName().split(" ")[0].toLowerCase();
    }
    
    // Joined date formatting
    String joinedOn = "01 Jan 2024";
    if (loggedInUser.getCreatedAt() != null) {
        joinedOn = new java.text.SimpleDateFormat("dd MMM yyyy").format(loggedInUser.getCreatedAt());
    }
    
    // First letter for avatar initials
    String firstLetter = "A";
    if (loggedInUser.getName() != null && !loggedInUser.getName().isEmpty()) {
        firstLetter = loggedInUser.getName().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush Admin | Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/settings.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/topbar.jsp" />
            
            <div class="content-wrapper">
                <!-- Status Toast/Notifications -->
                <% if ("profile_saved".equals(msg)) { %>
                    <div class="admin-alert alert-success" style="margin-bottom: 20px;">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Admin profile details updated successfully!</span>
                    </div>
                <% } else if ("password_saved".equals(msg)) { %>
                    <div class="admin-alert alert-success" style="margin-bottom: 20px;">
                        <i class="bi bi-shield-check"></i>
                        <span>Password changed successfully!</span>
                    </div>
                <% } else if ("password_mismatch".equals(msg)) { %>
                    <div class="admin-alert alert-danger" style="margin-bottom: 20px;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>Current password does not match. Please verify your credentials.</span>
                    </div>
                <% } else if ("confirm_failed".equals(msg)) { %>
                    <div class="admin-alert alert-danger" style="margin-bottom: 20px;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>Passwords do not match. Please re-enter.</span>
                    </div>
                <% } else if ("error".equals(msg)) { %>
                    <div class="admin-alert alert-danger" style="margin-bottom: 20px;">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>An error occurred. Please try again.</span>
                    </div>
                <% } %>
                
                <div class="settings-container">
                    <!-- PANEL 1: Profile Information -->
                    <div class="settings-panel">
                        <div class="settings-panel-header">
                            <h2>Profile Information</h2>
                            <p>Update your personal information and contact details</p>
                        </div>
                        
                        <form action="settings.jsp" method="POST">
                            <input type="hidden" name="action" value="profile">
                            <div class="profile-flex-layout">
                                <!-- Photo Upload Column -->
                                <div class="avatar-upload-column">
                                    <div class="avatar-preview-wrapper">
                                        <div class="avatar-img" style="display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #FF5A1F, #FF8E53); color: #FFFFFF; font-size: 2.5rem; font-weight: 700; font-family: 'Outfit';">
                                            <%= firstLetter %>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Inputs Column Grid -->
                                <div class="settings-inputs-grid">
                                    <div class="form-group">
                                        <label class="form-label" for="profile-name">Full Name</label>
                                        <input type="text" id="profile-name" name="name" class="form-control" value="<%= loggedInUser.getName() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="profile-username">Username</label>
                                        <input type="text" id="profile-username" class="form-control" value="<%= username %>" disabled>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="profile-email">Email Address</label>
                                        <input type="email" id="profile-email" name="email" class="form-control" value="<%= loggedInUser.getEmail() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="profile-role">Role</label>
                                        <select id="profile-role" class="form-control" disabled>
                                            <option value="admin" selected>Super Admin</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="profile-phone">Phone Number</label>
                                        <input type="text" id="profile-phone" name="phone" class="form-control" value="<%= loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="profile-joined">Joined On</label>
                                        <div class="input-icon-wrapper">
                                            <i class="bi bi-calendar3 prefix-icon"></i>
                                            <input type="text" id="profile-joined" class="form-control" value="<%= joinedOn %>" disabled>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="panel-footer-actions">
                                <button type="submit" class="btn btn-primary" style="background-color: #FF5A1F; border-color: #FF5A1F;">Update Profile</button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- PANEL 2: Change Password -->
                    <div class="settings-panel">
                        <div class="settings-panel-header">
                            <h2>Change Password</h2>
                            <p>Update your password regularly for better security</p>
                        </div>
                        
                        <form action="settings.jsp" method="POST">
                            <input type="hidden" name="action" value="password">
                            <div class="settings-inputs-grid" style="grid-template-columns: 1fr 1fr; align-items: end;">
                                <div class="form-group" style="grid-column: span 2; max-width: calc(50% - 10px);">
                                    <label class="form-label" for="current-password">Current Password</label>
                                    <div class="input-icon-wrapper">
                                        <input type="password" id="current-password" name="currentPassword" class="form-control" placeholder="Enter current password" required>
                                        <i class="bi bi-eye-slash suffix-eye" onclick="togglePassword('current-password', this)"></i>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="new-password">New Password</label>
                                    <div class="input-icon-wrapper">
                                        <input type="password" id="new-password" name="newPassword" class="form-control" placeholder="Enter new password" minlength="4" required>
                                        <i class="bi bi-eye-slash suffix-eye" onclick="togglePassword('new-password', this)"></i>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="confirm-password">Confirm New Password</label>
                                    <div class="input-icon-wrapper">
                                        <input type="password" id="confirm-password" name="confirmPassword" class="form-control" placeholder="Confirm new password" minlength="4" required>
                                        <i class="bi bi-eye-slash suffix-eye" onclick="togglePassword('confirm-password', this)"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="panel-footer-actions">
                                <button type="submit" class="btn btn-primary" style="background-color: #FF5A1F; border-color: #FF5A1F;">Update Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/admin/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/settings.js"></script>
</body>
</html>
