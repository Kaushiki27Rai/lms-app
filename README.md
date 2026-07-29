# 🎓 LMS Web Application

A full-featured **Learning Management System (LMS)** built with Java Servlets, JSP, MySQL, Bootstrap 5, and Maven using clean **Layered MVC/MVVM Architecture**.

---

## 🌟 Key Features

* **User Authentication & Roles**:
  * Role-based access control for **Students**, **Instructors / Teachers**, and **Admins**.
  * Password security hashing with SHA-256 / BCrypt (`PasswordUtils.java`).
  * Tabbed login and registration UI with live password strength meter.

* **Course Catalog & Management**:
  * Explore courses, view instructor details, start/end dates, and syllabus.
  * Student course enrollment with real-time status tracking.
  * Instructor view to publish new courses.

* **Interactive MCQ Quiz Engine**:
  * Take course assessment quizzes with multiple-choice questions (A, B, C, D).
  * Automated instant score calculation and result reporting.

---

## 🏗 Project Architecture

```
lms-app/
├── schema.sql                     # MySQL database schema & sample seed data
├── pom.xml                        # Maven dependencies & build configuration
├── src/main/java/com/lms/
│   ├── model/                     # Domain Entities (User, Course, Lesson, Quiz, Question, QuizSubmission)
│   ├── util/                      # Utilities (DBConnection, PasswordUtils)
│   ├── dao/                       # Data Access Objects (UserDao, CourseDao, QuizDao)
│   ├── service/                   # ViewModels & Services (UserService, CourseService, QuizService)
│   └── controller/                # Servlet Controllers (AuthServlet, CourseServlet, QuizServlet, DashboardServlet)
└── src/main/webapp/               # JSP Views & Assets (registration, dashboard, courses, course-detail, create-course, quiz)
```

---

## 🛠 Prerequisites & Setup

### 1. Database Configuration
1. Open MySQL workbench or terminal.
2. Execute `schema.sql` to create the `ManagementSystems` database and insert sample seed data:
   ```bash
   mysql -u root -p < schema.sql
   ```

### 2. DB Credentials Configuration
In `src/main/java/com/lms/util/DBConnection.java`, verify your MySQL username and password:
```java
private static final String URL = "jdbc:mysql://localhost:3306/ManagementSystems?...";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

### 3. Run Application
Deploy the WAR package on Apache Tomcat 9/10 or run via your preferred Java IDE (Eclipse, IntelliJ IDEA, NetBeans, or VS Code).

Access the portal at: `http://localhost:8080/lms-app/auth`
