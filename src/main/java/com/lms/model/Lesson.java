package com.lms.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Lesson implements Serializable {
    private static final long serialVersionUID = 1L;

    private int lessonId;
    private int courseId;
    private String title;
    private String content;
    private Timestamp createdAt;

    public Lesson() {
    }

    public Lesson(int courseId, String title, String content) {
        this.courseId = courseId;
        this.title = title;
        this.content = content;
    }

    public Lesson(int lessonId, int courseId, String title, String content, Timestamp createdAt) {
        this.lessonId = lessonId;
        this.courseId = courseId;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
