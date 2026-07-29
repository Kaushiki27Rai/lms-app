package com.lms.controller;

import com.lms.dao.AssignmentDao;
import com.lms.model.AssignmentSubmission;
import com.lms.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/assignments")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AssignmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AssignmentDao assignmentDao;

    @Override
    public void init() throws ServletException {
        this.assignmentDao = new AssignmentDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String assignmentIdStr = request.getParameter("assignmentId");
        int assignmentId = assignmentIdStr != null ? Integer.parseInt(assignmentIdStr) : 1;

        String fileName = "submitted_document.pdf";
        try {
            Part filePart = request.getPart("submissionFile");
            if (filePart != null && filePart.getSubmittedFileName() != null) {
                fileName = filePart.getSubmittedFileName();
            }
        } catch (Exception ignored) {}

        AssignmentSubmission sub = new AssignmentSubmission();
        sub.setAssignmentId(assignmentId);
        sub.setStudentId(currentUser.getUserId());
        sub.setSubmittedFile(fileName);
        sub.setComments("Submitted via online student portal");

        assignmentDao.submitAssignment(sub);

        response.sendRedirect(request.getContextPath() + "/courses?action=view&id=1&msg=assignment_submitted");
    }
}
