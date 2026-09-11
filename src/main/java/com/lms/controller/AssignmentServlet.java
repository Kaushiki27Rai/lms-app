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
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;

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
        if (!"student".equalsIgnoreCase(currentUser.getRole()) || assignmentIdStr == null) { response.sendError(403); return; }
        int assignmentId = com.lms.util.RequestUtils.positiveInt(assignmentIdStr);
        if (assignmentId < 1) { response.sendError(400, "Invalid assignment"); return; }
        Integer courseId = assignmentDao.courseIdForStudentAssignment(assignmentId, currentUser.getUserId());
        if (courseId == null) { response.sendError(403, "You cannot submit work for this assignment."); return; }
        String fileName;
        try {
            Part filePart = request.getPart("submissionFile");
            if (filePart == null || filePart.getSize() == 0) { response.sendError(400, "A file is required"); return; }
            String original = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = original.contains(".") ? original.substring(original.lastIndexOf('.')).toLowerCase() : "";
            if (!Set.of(".pdf", ".doc", ".docx", ".zip").contains(extension)) { response.sendError(400, "Unsupported file type"); return; }
            fileName = UUID.randomUUID() + extension;
            Path uploadRoot = Path.of(System.getenv().getOrDefault("UPLOAD_DIR", System.getProperty("java.io.tmpdir") + "/lms-uploads"));
            Files.createDirectories(uploadRoot);
            Files.copy(filePart.getInputStream(), uploadRoot.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) { response.sendError(400, "Unable to process upload"); return; }

        AssignmentSubmission sub = new AssignmentSubmission();
        sub.setAssignmentId(assignmentId);
        sub.setStudentId(currentUser.getUserId());
        sub.setSubmittedFile(fileName);
        sub.setComments("Submitted via online student portal");

        if (!assignmentDao.submitAssignment(sub)) { response.sendError(500, "Submission could not be saved."); return; }

        response.sendRedirect(request.getContextPath() + "/courses?action=view&id=" + courseId + "&msg=assignment_submitted");
    }
}
