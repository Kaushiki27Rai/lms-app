package com.lms.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class QuizSubmission implements Serializable {
    private static final long serialVersionUID = 1L;

    private int submissionId;
    private int quizId;
    private String quizTitle;
    private int studentId;
    private double score;
    private Timestamp submissionDate;

    public QuizSubmission() {
    }

    public QuizSubmission(int quizId, int studentId, double score) {
        this.quizId = quizId;
        this.studentId = studentId;
        this.score = score;
    }

    public QuizSubmission(int submissionId, int quizId, int studentId, double score, Timestamp submissionDate) {
        this.submissionId = submissionId;
        this.quizId = quizId;
        this.studentId = studentId;
        this.score = score;
        this.submissionDate = submissionDate;
    }

    public int getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public Timestamp getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Timestamp submissionDate) {
        this.submissionDate = submissionDate;
    }
}
