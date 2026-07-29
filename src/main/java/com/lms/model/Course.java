package com.lms.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Course implements Serializable {
    private static final long serialVersionUID = 1L;

    private int courseId;
    private String title;
    private String description;
    private String category = "Computer Science";
    private int instructorId;
    private String instructorName; // Joined field for display
    private String bannerUrl = "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800";
    private Date startDate;
    private Date endDate;
    private Timestamp createdAt;

    public Course() {
    }

    public Course(String title, String description, int instructorId, Date startDate, Date endDate) {
        this.title = title;
        this.description = description;
        this.instructorId = instructorId;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Course(int courseId, String title, String description, int instructorId, Date startDate, Date endDate, Timestamp createdAt) {
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.instructorId = instructorId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdAt = createdAt;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category != null ? category : "Computer Science";
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public String getBannerUrl() {
        return bannerUrl != null ? bannerUrl : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800";
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
