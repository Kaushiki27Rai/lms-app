package com.lms.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class AssignmentSubmission implements Serializable {
    private static final long serialVersionUID = 1L;

    private int submissionId;
    private int assignmentId;
    private int studentId;
    private String submittedFile;
    private String comments;
    private Integer marksObtained;
    private String feedback;
    private Timestamp submittedAt;

    public AssignmentSubmission() {
    }

    public int getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getSubmittedFile() {
        return submittedFile;
    }

    public void setSubmittedFile(String submittedFile) {
        this.submittedFile = submittedFile;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Integer getMarksObtained() {
        return marksObtained;
    }

    public void setMarksObtained(Integer marksObtained) {
        this.marksObtained = marksObtained;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
}
