-- Create Database
CREATE DATABASE IF NOT EXISTS ManagementSystems;
USE ManagementSystems;

-- 1. Users Table (Supports Students, Instructors, Admins with Role-Specific Metadata)
CREATE TABLE IF NOT EXISTS Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('student', 'instructor', 'admin') DEFAULT 'student',
    student_id VARCHAR(50),
    department VARCHAR(100),
    semester VARCHAR(20),
    year VARCHAR(20),
    employee_id VARCHAR(50),
    designation VARCHAR(100),
    expertise VARCHAR(255),
    profile_pic VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Courses Table
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(50) DEFAULT 'Computer Science',
    instructor_id INT,
    banner_url VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 3. Enrollments Table
CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    progress_percentage DECIMAL(5, 2) DEFAULT 0.00,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_course (user_id, course_id)
);

-- 4. Modules Table (Course Units / Weeks)
CREATE TABLE IF NOT EXISTS Modules (
    module_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    video_url VARCHAR(255),
    pdf_url VARCHAR(255),
    duration_mins INT DEFAULT 45,
    published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 5. Lesson Progress Table
CREATE TABLE IF NOT EXISTS LessonProgress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    module_id INT,
    is_completed BOOLEAN DEFAULT TRUE,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (module_id) REFERENCES Modules(module_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_module (user_id, module_id)
);

-- 6. Assignments Table
CREATE TABLE IF NOT EXISTS Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    instructions TEXT,
    due_date TIMESTAMP,
    max_marks INT DEFAULT 100,
    rubric TEXT,
    late_policy VARCHAR(100) DEFAULT '10% deduction per day late',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 7. Assignment Submissions Table
CREATE TABLE IF NOT EXISTS AssignmentSubmissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT,
    student_id INT,
    submitted_file VARCHAR(255),
    comments TEXT,
    marks_obtained INT,
    feedback TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 8. Attendance Table
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    student_id INT,
    date DATE,
    status ENUM('Present', 'Absent', 'Late') DEFAULT 'Present',
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 9. Quizzes Table
CREATE TABLE IF NOT EXISTS Quizzes (
    quiz_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    time_limit_mins INT DEFAULT 15,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 10. Questions Table
CREATE TABLE IF NOT EXISTS Questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE
);

-- 11. Quiz Submissions Table
CREATE TABLE IF NOT EXISTS QuizSubmissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT,
    student_id INT,
    score DECIMAL(5, 2),
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 12. Announcements Table
CREATE TABLE IF NOT EXISTS Announcements (
    announcement_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    posted_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (posted_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 13. Notifications Table
CREATE TABLE IF NOT EXISTS Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 14. Discussions Table
CREATE TABLE IF NOT EXISTS Discussions (
    discussion_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    title VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    is_answered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 15. Discussion Replies Table
CREATE TABLE IF NOT EXISTS DiscussionReplies (
    reply_id INT PRIMARY KEY AUTO_INCREMENT,
    discussion_id INT,
    user_id INT,
    content TEXT NOT NULL,
    is_answer BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discussion_id) REFERENCES Discussions(discussion_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 16. Learning Sessions Table (Tracks Study Hours)
CREATE TABLE IF NOT EXISTS LearningSessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    duration_mins INT DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Seed Data (Default Instructor & Student)
INSERT INTO Users (user_id, username, password, email, role, employee_id, department, designation, expertise)
VALUES (1, 'Dr. Smith', 'securepassword', 'drsmith@example.com', 'instructor', 'EMP-109', 'Computer Science', 'Senior Professor', 'Database Systems & Algorithms')
ON DUPLICATE KEY UPDATE username=VALUES(username);

INSERT INTO Users (user_id, username, password, email, role, student_id, department, semester, year)
VALUES (2, 'Kaushiki Rai', 'password123', 'alice@example.com', 'student', 'STU-2024-88', 'Computer Science', '4th Semester', '2nd Year')
ON DUPLICATE KEY UPDATE username=VALUES(username);

-- Seed Courses
INSERT INTO Courses (course_id, title, description, category, instructor_id, banner_url, start_date, end_date)
VALUES (1, 'Data Structures & Algorithms', 'Master trees, graphs, dynamic programming, and complexity analysis.', 'Computer Science', 1, 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800', '2026-01-10', '2026-05-30')
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Courses (course_id, title, description, category, instructor_id, banner_url, start_date, end_date)
VALUES (2, 'Database Management Systems', 'Relational database design, SQL queries, indexing, and transaction management.', 'Computer Science', 1, 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800', '2026-01-15', '2026-05-25')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Enrollments
INSERT INTO Enrollments (user_id, course_id, progress_percentage) VALUES (2, 1, 76.00) ON DUPLICATE KEY UPDATE progress_percentage=VALUES(progress_percentage);
INSERT INTO Enrollments (user_id, course_id, progress_percentage) VALUES (2, 2, 45.00) ON DUPLICATE KEY UPDATE progress_percentage=VALUES(progress_percentage);

-- Seed Modules
INSERT INTO Modules (module_id, course_id, title, description, video_url, pdf_url, duration_mins)
VALUES (1, 1, 'Week 1: Introduction to Arrays & Complexity', 'Understanding Big-O notation, memory layout, and array operations.', 'https://www.youtube.com/embed/gDqQfQUN1uc', 'arrays_lecture_notes.pdf', 50)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Modules (module_id, course_id, title, description, video_url, pdf_url, duration_mins)
VALUES (2, 1, 'Week 2: Linked Lists & Recursion', 'Singly and doubly linked lists, recursive stack calls, and pointers.', 'https://www.youtube.com/embed/gDqQfQUN1uc', 'linked_lists.pdf', 60)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Modules (module_id, course_id, title, description, video_url, pdf_url, duration_mins)
VALUES (3, 2, 'Week 1: Relational Algebra & ER Diagrams', 'Entities, relationships, primary keys, and schema design principles.', 'https://www.youtube.com/embed/gDqQfQUN1uc', 'dbms_week1.pdf', 45)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Assignments
INSERT INTO Assignments (assignment_id, course_id, title, instructions, due_date, max_marks)
VALUES (1, 1, 'Binary Search Tree Implementation', 'Implement a balanced BST in Java with insert, delete, and traversal methods.', DATE_ADD(NOW(), INTERVAL 2 DAY), 100)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Assignments (assignment_id, course_id, title, instructions, due_date, max_marks)
VALUES (2, 2, 'SQL Normalization & Indexing', 'Normalize the provided unnormalized database schema to 3NF and write indexes.', DATE_ADD(NOW(), INTERVAL 5 DAY), 50)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Announcements
INSERT INTO Announcements (announcement_id, course_id, title, content, posted_by)
VALUES (1, 1, 'Midterm Project Announcement', 'Please review the BST project guidelines uploaded in Module 2 before Friday.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Announcements (announcement_id, course_id, title, content, posted_by)
VALUES (2, 2, 'SQL Lab Solutions Released', 'Solutions for Lab 3 are now available in the resources section.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Notifications
INSERT INTO Notifications (notification_id, user_id, title, message, link)
VALUES (1, 2, 'New Assignment Posted', 'Binary Search Tree Implementation is due in 2 days.', '/courses?action=view&id=1')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Quizzes & Questions
INSERT INTO Quizzes (quiz_id, course_id, title, description, time_limit_mins)
VALUES (1, 1, 'Data Structures Assessment Quiz', 'Test your knowledge on Arrays, Linked Lists, and Tree Traversal.', 15)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Questions (question_id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option)
VALUES (1, 1, 'What is the worst-case time complexity of searching in a Balanced Binary Search Tree?', 'O(1)', 'O(log N)', 'O(N)', 'O(N^2)', 'B')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text);

INSERT INTO Questions (question_id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option)
VALUES (2, 1, 'Which data structure follows the First-In, First-Out (FIFO) principle?', 'Stack', 'Queue', 'Tree', 'Graph', 'B')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text);

INSERT INTO Questions (question_id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option)
VALUES (3, 1, 'Which data structure is used for Breadth-First Search (BFS) in a graph?', 'Stack', 'Queue', 'Array', 'Heap', 'B')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text);

-- Seed Attendance
INSERT INTO Attendance (course_id, student_id, date, status) VALUES (1, 2, CURRENT_DATE(), 'Present');
INSERT INTO Attendance (course_id, student_id, date, status) VALUES (2, 2, CURRENT_DATE(), 'Present');

-- Seed Learning Sessions
INSERT INTO LearningSessions (user_id, course_id, duration_mins) VALUES (2, 1, 120);
INSERT INTO LearningSessions (user_id, course_id, duration_mins) VALUES (2, 2, 90);