package com.lms.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Assignment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int assignmentId;
    private int courseId;
    private String courseTitle;
    private String title;
    private String instructions;
    private Timestamp dueDate;
    private int maxMarks;
    private String rubric;
    private String latePolicy;
    private Timestamp createdAt;
    
    // Status for Student view
    private String status; // "Pending", "Submitted", "Overdue", "Graded"

    public Assignment() {
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public int getMaxMarks() {
        return maxMarks;
    }

    public void setMaxMarks(int maxMarks) {
        this.maxMarks = maxMarks;
    }

    public String getRubric() {
        return rubric;
    }

    public void setRubric(String rubric) {
        this.rubric = rubric;
    }

    public String getLatePolicy() {
        return latePolicy;
    }

    public void setLatePolicy(String latePolicy) {
        this.latePolicy = latePolicy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status != null ? status : "Pending";
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
