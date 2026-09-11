package com.lms.service;

import com.lms.dao.AnalyticsDao;
import java.util.Map;

public class AnalyticsService {
    private final AnalyticsDao analyticsDao = new AnalyticsDao();
    public Map<String, Object> getStudentMetrics(int studentId) { return analyticsDao.studentMetrics(studentId); }
    public boolean instructorOwnsStudent(int instructorId, int studentId) { return analyticsDao.instructorOwnsStudent(instructorId, studentId); }
}
