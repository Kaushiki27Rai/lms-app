package com.lms.controller;

import com.lms.dto.ApiResponse;
import com.lms.model.User;
import com.lms.service.AiInsightsService;
import com.lms.service.AnalyticsService;
import com.lms.service.CourseService;
import com.lms.service.UserService;
import com.lms.util.JsonUtil;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/** Session-authenticated JSON API. Its resource paths are intentionally stable for web or mobile clients. */
@WebServlet("/api/*")
public class ApiServlet extends HttpServlet {
    private final CourseService courses = new CourseService();
    private final AnalyticsService analytics = new AnalyticsService();
    private final AiInsightsService ai = new AiInsightsService();
    private final UserService users = new UserService();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if ("/courses".equals(path)) { List<Map<String,Object>> data=new ArrayList<>(); for(com.lms.model.Course c:courses.getAllCourses()) data.add(Map.of("id",c.getCourseId(),"title",c.getTitle(),"description",c.getDescription(),"category",c.getCategory())); write(resp,200,ApiResponse.ok("Courses retrieved successfully",data)); return; }
        User current = current(req); if (current == null) { write(resp,401,ApiResponse.error("Authentication required")); return; }
        if (path.matches("/students/\\d+/dashboard") || path.matches("/analytics/student/\\d+")) {
            int id=id(path); if (!ownsOrInstructor(current,id)) { forbidden(resp); return; }
            write(resp,200,ApiResponse.ok("Student analytics retrieved successfully",analytics.getStudentMetrics(id))); return;
        }
        if (path.matches("/ai/risk/\\d+")) { int id=id(path); if (!ownsOrInstructor(current,id)) { forbidden(resp); return; } write(resp,200,ApiResponse.ok("Risk prediction retrieved successfully",ai.risk(id))); return; }
        if (path.matches("/ai/recommendations/\\d+")) { int id=id(path); if (!ownsOrInstructor(current,id)) { forbidden(resp); return; } write(resp,200,ApiResponse.ok("Recommendations retrieved successfully",ai.recommendations(id))); return; }
        write(resp,404,ApiResponse.error("API resource not found"));
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path=req.getPathInfo()==null?"":req.getPathInfo();
        if ("/auth/login".equals(path)) {
            String body=new String(req.getInputStream().readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
            User user=users.login(JsonUtil.field(body,"email"),JsonUtil.field(body,"password"));
            if(user==null){write(resp,401,ApiResponse.error("Invalid email address or password"));return;}
            req.getSession(true).setAttribute("user",user); req.getSession().setAttribute("userRole",user.getRole());
            write(resp,200,ApiResponse.ok("Login successful",safeUser(user))); return;
        }
        User current=current(req); if(current==null){write(resp,401,ApiResponse.error("Authentication required"));return;}
        if(path.matches("/courses/\\d+/enroll")) { if(!"student".equalsIgnoreCase(current.getRole())){forbidden(resp);return;} int course=id(path); boolean enrolled=courses.enrollStudent(current.getUserId(),course); write(resp,enrolled?201:400,enrolled?ApiResponse.ok("Enrollment successful",Map.of("courseId",course)):ApiResponse.error("Enrollment failed")); return; }
        write(resp,404,ApiResponse.error("API resource not found"));
    }
    private User current(HttpServletRequest r){HttpSession s=r.getSession(false);return s==null?null:(User)s.getAttribute("user");}
    private boolean ownsOrInstructor(User u,int id){return u.getUserId()==id || "admin".equalsIgnoreCase(u.getRole()) || ("instructor".equalsIgnoreCase(u.getRole()) && analytics.instructorOwnsStudent(u.getUserId(), id));}
    private int id(String path){String[] p=path.split("/");return Integer.parseInt(p[p.length-1].matches("\\d+")?p[p.length-1]:p[p.length-2]);}
    private Map<String,Object> safeUser(User u){return Map.of("id",u.getUserId(),"name",u.getUsername(),"email",u.getEmail(),"role",u.getRole());}
    private void forbidden(HttpServletResponse r)throws IOException{write(r,403,ApiResponse.error("You are not authorized to access this resource"));}
    private void write(HttpServletResponse r,int status,ApiResponse<?> body)throws IOException{r.setStatus(status);r.setContentType("application/json;charset=UTF-8");Map<String,Object> payload=new LinkedHashMap<>();payload.put("success",body.success);payload.put("message",body.message);payload.put("data",body.data);r.getWriter().write(JsonUtil.value(payload));}
}
