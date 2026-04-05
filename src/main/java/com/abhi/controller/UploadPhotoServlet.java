package com.abhi.controller;

import java.io.File;
import java.io.IOException;

import com.abhi.dao.UserDAO;
import com.abhi.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/uploadPhoto")
@MultipartConfig(
    maxFileSize    = 5 * 1024 * 1024,  // 5 MB max
    maxRequestSize = 6 * 1024 * 1024
)
public class UploadPhotoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { res.sendRedirect("index.jsp"); return; }

        User user = (User) session.getAttribute("user");
        if (user == null)    { res.sendRedirect("index.jsp"); return; }

        Part photoPart = req.getPart("photo");
        if (photoPart == null || photoPart.getSize() == 0) {
            redirectBack(res, user); return;
        }

        String uploadDir = getServletContext().getRealPath("")
                + File.separator + "uploads"
                + File.separator + "photos";

        System.out.println(uploadDir);       File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalName = photoPart.getSubmittedFileName();
        String ext = originalName.contains(".")
                ? originalName.substring(originalName.lastIndexOf('.'))
                : ".jpg";
        String fileName = "user_" + user.getEid() + ext;   // e.g. user_5.jpg

        // Write file to disk
        photoPart.write(uploadDir + File.separator + fileName);

        // ── 3. Web path to store in DB ────────────────────────────────────────
        String webPath = "uploads/photos/" + fileName;

        // ── 4. Save to DB ─────────────────────────────────────────────────────
        UserDAO dao = new UserDAO();
        dao.updatePhotoPath(user.getEid(), webPath);

        // ── 5. Update session so page shows photo immediately ─────────────────
        user.setPhotoPath(webPath);
        session.setAttribute("user", user);

        redirectBack(res, user);
    }

    private void redirectBack(HttpServletResponse res, User user) throws IOException {
        if ("manager".equals(user.getRole())) {
            res.sendRedirect("manager.jsp");
        } else {
            res.sendRedirect("employee.jsp");
        }
    }
}