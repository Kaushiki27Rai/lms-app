# 🎓 LMS — Learn Smarter. Teach Better.

> **A minimal, modern, role-based Learning Management System inspired by Notion, Linear, Apple Education, and Canvas.**

---

## 🎨 Design Philosophy & UX Highlights

* **Minimal & Purpose-Driven**: Zero clutter. No unnecessary buttons or navigation noise.
* **Role-Based Workspaces**:
  * 🎒 **Student Hub**: Dashboard-first design focused on "What should I do today?" with progress rings, upcoming assignment timelines, and recent announcements.
  * 👨‍🏫 **Instructor Management Hub**: Focused on "Less learning, more management!" featuring class schedules, pending grading queues, quick actions, and student risk alerts.
* **Apple & Linear Aesthetics**:
  * Color Palette: Primary `#2563EB`, Background `#F8FAFC`, Accent Emerald `#10B981`, Cards `#FFFFFF`.
  * Typography: `Inter` system fonts.
  * Border Radii: `18px` Cards, `12px` Buttons, `10px` Inputs.
  * Soft Shadows (`0 8px 30px rgba(0,0,0,0.06)`) and Glassmorphism cards.
* **🤖 Floating AI Study Assistant**:
  * Integrated study assistant widget for lecture note summaries, quiz generation, and student Q&A.

---

## ✨ Features & Workflows

### 🌐 Landing & Marketing Page (`/landing`)
* Hero Section ("Learn Smarter. Teach Better.")
* Interactive Feature Grid (Assignment Tracking, Live Classes, Attendance, AI Assistant, Analytics, Discussion Forum)
* Direct Role CTA Buttons (`[Start Learning]`, `[Become Instructor]`)

### 🔐 Authentication Flow (`/login` & `/signup`)
* **Glassmorphic Login Card**: Email, password, social SSO placeholders (Google, Microsoft).
* **3-Step Interactive Sign-Up Wizard**:
  * **Step 1**: Full Name, Email, Password.
  * **Step 2**: Role Selection (Student vs. Instructor).
    * *Student Fields*: Student ID, Department, Semester, Year.
    * *Instructor Fields*: Employee ID, Department, Designation, Expertise.
  * **Step 3**: Verification & Completion.

### 📚 Course Management & Interactive Quizzes
* **Student Course Hub**: Overview, Modules, Assignments, Announcements, and Grades.
* **Instructor Course Creator**: Title, Description, Date range, and syllabus publishing.
* **MCQ Quiz Engine**: Automated score calculation and instant performance results.

---

## 🏗 Technical Architecture

```
lms-app/
├── schema.sql                       # Enhanced MySQL schema (Users, Courses, Enrollments, Modules, Assignments, Quizzes, Attendance, Announcements)
├── pom.xml                          # Maven build dependencies & embedded Jetty server
├── run.sh                           # 1-Click launcher script
├── src/main/webapp/
│   ├── css/style.css                # Notion/Linear/Apple design system tokens & utilities
│   ├── landing.jsp                  # Modern marketing landing page
│   ├── login.jsp                    # Glassmorphism login view
│   ├── signup.jsp                   # 3-step interactive signup wizard
│   ├── student-dashboard.jsp        # Student role dashboard
│   ├── instructor-dashboard.jsp     # Instructor management hub
│   ├── courses.jsp                  # Course catalog view
│   ├── course-detail.jsp            # Detailed syllabus & enrollment view
│   ├── create-course.jsp            # Course publisher view
│   └── quiz.jsp                     # Interactive test player
└── src/main/java/com/lms/
    ├── model/                       # Domain Entities (User, Course, Module, Assignment, Quiz, Question, QuizSubmission)
    ├── util/                        # DBConnection & PasswordUtils
    ├── dao/                         # Data Access Objects (UserDao, CourseDao, QuizDao)
    ├── service/                     # ViewModels & Services (UserService, CourseService, QuizService)
    └── controller/                  # Servlet Controllers (LandingServlet, AuthServlet, DashboardServlet, CourseServlet, QuizServlet)
```

---

## 🚀 How to Run

1. **Start the Application**:
   ```bash
   ./run.sh
   ```
2. **Open in Browser**:
   * Landing Page: `http://localhost:8080/`
   * Login: `http://localhost:8080/login`
   * Sign Up: `http://localhost:8080/signup`

3. **Built-in Demo Accounts**:
   * **Student**: `alice@example.com` / `password123`
   * **Instructor**: `drsmith@example.com` / `securepassword`
