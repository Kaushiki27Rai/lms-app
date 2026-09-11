package com.lms.service;

import com.lms.util.JsonUtil;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;

/** Boundary for Java-to-ML API communication; safely falls back to rule-based, data-derived advice. */
public class AiInsightsService {
    private final AnalyticsService analytics = new AnalyticsService();
    private final HttpClient http = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(2)).build();
    private final String url = System.getenv().getOrDefault("ML_SERVICE_URL", "http://localhost:8001");

    public Map<String,Object> risk(int studentId) {
        Map<String,Object> metrics = analytics.getStudentMetrics(studentId);
        metrics.put("studentId", studentId); metrics.put("averageAssignmentScore", metrics.get("averageQuizScore"));
        metrics.put("quizAttemptCount", 0); metrics.put("recentActivityScore", Math.min(100, ((Number)metrics.get("weeklyLearningHours")).doubleValue()*10));
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url + "/predict"))
                    .timeout(Duration.ofSeconds(4)).header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(JsonUtil.value(metrics))).build();
            HttpResponse<String> response = http.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) return parsePrediction(response.body(), studentId);
        } catch (Exception ignored) { }
        return localRisk(metrics, studentId);
    }
    private Map<String,Object> parsePrediction(String body, int studentId) {
        Map<String,Object> result=new LinkedHashMap<>(); result.put("studentId",studentId);
        String level=JsonUtil.field(body,"riskLevel"); result.put("riskLevel", level==null?"MEDIUM":level);
        result.put("riskScore", number(body,"riskScore")); result.put("confidence",number(body,"confidence"));
        result.put("source","ml-service"); return result;
    }
    private double number(String body,String field){java.util.regex.Matcher m=java.util.regex.Pattern.compile("\\\""+field+"\\\"\\s*:\\s*([0-9.]+)").matcher(body);return m.find()?Double.parseDouble(m.group(1)):0;}
    public Map<String,Object> recommendations(int studentId) {
        Map<String,Object> result = risk(studentId); Map<String,Object> metrics = analytics.getStudentMetrics(studentId);
        java.util.List<String> advice = new java.util.ArrayList<>();
        if (((Number)metrics.get("attendancePercentage")).doubleValue() < 75) advice.add("Attend the next two scheduled classes and review missed material.");
        if (((Number)metrics.get("assignmentSubmissionRate")).doubleValue() < 80) advice.add("Complete pending assignments before their due dates.");
        if (((Number)metrics.get("averageQuizScore")).doubleValue() < 65) advice.add("Revisit recent modules and attempt the practice quiz.");
        if (((Number)metrics.get("weeklyLearningHours")).doubleValue() < 3) advice.add("Schedule three focused learning sessions this week.");
        if (advice.isEmpty()) advice.add("Maintain your current study rhythm and challenge yourself with the next module.");
        result.put("recommendations", advice); result.put("metrics", metrics); return result;
    }
    private Map<String,Object> localRisk(Map<String,Object> m, int studentId) {
        double score = (100-((Number)m.get("attendancePercentage")).doubleValue())*.30 + (100-((Number)m.get("averageQuizScore")).doubleValue())*.25 + (100-((Number)m.get("assignmentSubmissionRate")).doubleValue())*.25 + Math.min(100,((Number)m.get("missedAssignments")).doubleValue()*25)*.20;
        score = Math.max(0, Math.min(1, score/100)); String level = score >= .65 ? "HIGH" : score >= .35 ? "MEDIUM" : "LOW";
        java.util.List<String> factors = new java.util.ArrayList<>();
        if (((Number)m.get("attendancePercentage")).doubleValue()<75) factors.add("Low attendance");
        if (((Number)m.get("assignmentSubmissionRate")).doubleValue()<80) factors.add("Incomplete assignments");
        if (((Number)m.get("averageQuizScore")).doubleValue()<65) factors.add("Low quiz performance");
        if (factors.isEmpty()) factors.add("Consistent learning activity");
        Map<String,Object> r = new LinkedHashMap<>(); r.put("studentId",studentId); r.put("riskLevel",level); r.put("riskScore",Math.round(score*100.0)/100.0); r.put("confidence",0.60); r.put("keyFactors",factors); r.put("source","rule-based fallback (ML service unavailable)"); return r;
    }
}
