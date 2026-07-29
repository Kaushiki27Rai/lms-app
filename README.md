# 🎓 LMS — Learn Smarter. Teach Better.

> **A minimal, modern, role-based Learning Management System inspired by Notion, Linear, Apple Education, and Canvas.**

---

## 🎨 Design Philosophy & UX Standards

* **100% Dynamic & Zero Hardcoded Data**: All student profile details, enrolled courses, upcoming assignments, course progress, quiz options, announcements, and notifications are dynamically rendered via Servlets, DAOs, Services, and MySQL.
* **Role-Based Workspaces**:
  * 🎒 **Student Hub**: Dashboard-first experience ("What should I do today?") featuring progress rings, upcoming assignment timelines, and recent announcements.
  * 👨‍🏫 **Instructor Hub**: Focused on class schedules, pending grading queues, quick actions, and student risk alerts.
* **Apple & Linear Style Guide**:
  * Primary: `#2563EB` (Linear Blue)
  * Background: `#F8FAFC` (Apple Slate)
  * Accent: `#10B981` (Emerald Green)
  * Border Radius: `18px` Cards, `12px` Buttons, `10px` Inputs.
  * Soft Shadows (`0 8px 30px rgba(0,0,0,0.06)`) and Glassmorphism cards.

---

## 🛠 Refactored Student Module Highlights

1. **Dynamic Dashboard (`student-dashboard.jsp`)**:
   * Hello `${currentUser.username}` header with department and semester badges.
   * Dynamic Continue Learning card fetching latest enrolled course and progress.
   * Live learning analytics (Weekly hours, Attendance %, Average score %, Completion %).
   * Dynamic announcements loop and upcoming assignments list sorted by due date (`due_date ASC`).
   * Working notification bell with unread counter.

2. **Quiz System Fix (`quiz.jsp` & `QuizServlet.java`)**:
   * Fixed radio button selection bug by using unique radio button group names per question (`name="q_${questionId}"`).
   * Clicking anywhere on an option card highlights and selects the option.
   * Calculates actual score percentage, persists `QuizSubmission` in database, and renders a detailed Question-by-Question Review showing correct vs. incorrect answers.

3. **Tabbed Course Learning Hub & Assignments (`course-detail.jsp` & `AssignmentServlet.java`)**:
   * Modules & Syllabus with expandable video/notes accordions.
   * Multipart file upload form handled by `@WebServlet("/assignments")` controller (`AssignmentServlet.java`).
   * Tracks submission records and updates assignment status badges (*Pending*, *Submitted*, *Overdue*, *Graded*).

4. **Multi-Step Signup Wizard (`signup.jsp`)**:
   * 3-Step interactive onboarding collecting role-specific details (Student ID, Department, Semester, Year vs. Employee ID, Designation, Expertise).

---

## 🏗 Technical Architecture & Database Schema

```
lms-app/
├── schema.sql                       # MySQL schema (Users, Courses, Enrollments, Modules, Assignments, AssignmentSubmissions, Quizzes, Questions, QuizSubmissions, Announcements, Notifications, Discussions, LearningSessions)
├── pom.xml                          # Maven build dependencies & Jetty plugin
├── run.sh                           # 1-Click launcher script
├── src/main/webapp/
│   ├── css/style.css                # Notion/Linear/Apple design system tokens
│   ├── landing.jsp                  # Clean landing page
│   ├── login.jsp                    # Glassmorphism login page
│   ├── signup.jsp                   # 3-step interactive signup wizard
│   ├── student-dashboard.jsp        # Dynamic Student Dashboard
│   ├── instructor-dashboard.jsp     # Instructor Management Hub
│   ├── courses.jsp                  # Course Catalog
│   ├── course-detail.jsp            # Course Hub & Syllabus
│   ├── create-course.jsp            # Course Publisher
│   └── quiz.jsp                     # Interactive Quiz Player & Review
└── src/main/java/com/lms/
    ├── model/                       # Domain Entities (User, Course, Module, Assignment, AssignmentSubmission, Quiz, Question, QuizSubmission, Announcement, Notification)
    ├── util/                        # DBConnection & PasswordUtils
    ├── dao/                         # Data Access Objects (UserDao, CourseDao, QuizDao, AssignmentDao, AnnouncementDao, NotificationDao, ModuleDao)
    ├── service/                     # ViewModels & Services (UserService, CourseService, QuizService)
    └── controller/                  # Servlet Controllers (LandingServlet, AuthServlet, DashboardServlet, CourseServlet, QuizServlet, AssignmentServlet)
```

---

## 🚀 How to Run

1. **Start the Application**:
   ```bash
   ./run.sh
   ```
2. **Open in Browser**:
   * Landing: `http://localhost:8080/`
   * Login: `http://localhost:8080/login`
   * Signup: `http://localhost:8080/signup`

3. **Demo Accounts**:
   * **Student**: `alice@example.com` / `password123`
   * **Instructor**: `drsmith@example.com` / `securepassword`
