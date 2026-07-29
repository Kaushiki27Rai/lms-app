package com.lms.service;

import com.lms.dao.CourseDao;
import com.lms.model.Course;

import java.sql.Date;
import java.util.List;

public class CourseService {

    private final CourseDao courseDao;

    public CourseService() {
        this.courseDao = new CourseDao();
    }

    public CourseService(CourseDao courseDao) {
        this.courseDao = courseDao;
    }

    public List<Course> getAllCourses() {
        return courseDao.getAllCourses();
    }

    public Course getCourseDetails(int courseId) {
        return courseDao.getCourseById(courseId);
    }

    public List<Course> getStudentCourses(int studentId) {
        return courseDao.getEnrolledCoursesForStudent(studentId);
    }

    public boolean enrollStudent(int studentId, int courseId) {
        if (studentId <= 0 || courseId <= 0) {
            return false;
        }
        return courseDao.enrollStudent(studentId, courseId);
    }

    public boolean isStudentEnrolled(int studentId, int courseId) {
        return courseDao.isStudentEnrolled(studentId, courseId);
    }

    public String createCourse(String title, String description, int instructorId, String startDateStr, String endDateStr) {
        if (title == null || title.trim().isEmpty()) {
            return "Course title is required.";
        }
        if (description == null || description.trim().isEmpty()) {
            return "Course description is required.";
        }
        if (instructorId <= 0) {
            return "Invalid instructor identity.";
        }

        try {
            Date startDate = (startDateStr != null && !startDateStr.isEmpty()) ? Date.valueOf(startDateStr) : new Date(System.currentTimeMillis());
            Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? Date.valueOf(endDateStr) : new Date(System.currentTimeMillis() + (30L * 24 * 60 * 60 * 1000));

            Course newCourse = new Course(title.trim(), description.trim(), instructorId, startDate, endDate);
            boolean created = courseDao.createCourse(newCourse);
            return created ? "SUCCESS" : "Failed to create course due to database error.";
        } catch (IllegalArgumentException e) {
            return "Invalid date format. Please use YYYY-MM-DD.";
        }
    }
}
