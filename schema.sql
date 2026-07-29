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
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
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

-- 5. Assignments Table
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

-- 6. Assignment Submissions Table
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

-- 7. Attendance Table
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    student_id INT,
    date DATE,
    status ENUM('Present', 'Absent', 'Late') DEFAULT 'Present',
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 8. Quizzes Table
CREATE TABLE IF NOT EXISTS Quizzes (
    quiz_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    time_limit_mins INT DEFAULT 15,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- 9. Questions Table
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

-- 10. Quiz Submissions Table
CREATE TABLE IF NOT EXISTS QuizSubmissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT,
    student_id INT,
    score DECIMAL(5, 2),
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 11. Announcements Table
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

-- Seed Data (Default Instructor & Student)
INSERT INTO Users (username, password, email, role, employee_id, department, designation, expertise)
VALUES ('Dr. Smith', 'securepassword', 'drsmith@example.com', 'instructor', 'EMP-109', 'Computer Science', 'Senior Professor', 'Database Systems & Algorithms')
ON DUPLICATE KEY UPDATE username=VALUES(username);

INSERT INTO Users (username, password, email, role, student_id, department, semester, year)
VALUES ('Kaushiki Rai', 'password123', 'alice@example.com', 'student', 'STU-2024-88', 'Computer Science', '4th Semester', '2nd Year')
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
INSERT INTO Modules (course_id, title, description, video_url, pdf_url, duration_mins)
VALUES (1, 'Week 1: Introduction to Arrays & Complexity', 'Understanding Big-O notation, memory layout, and array operations.', 'https://www.youtube.com/embed/gDqQfQUN1uc', 'arrays_lecture_notes.pdf', 50);

-- Seed Assignments
INSERT INTO Assignments (assignment_id, course_id, title, instructions, due_date, max_marks)
VALUES (1, 1, 'Binary Search Tree Implementation', 'Implement a balanced BST in Java with insert, delete, and traversal methods.', '2026-08-05 23:59:59', 100)
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO Assignments (assignment_id, course_id, title, instructions, due_date, max_marks)
VALUES (2, 2, 'SQL Normalization & Indexing', 'Normalize the provided unnormalized database schema to 3NF and write indexes.', '2026-08-08 23:59:59', 50)
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Seed Announcements
INSERT INTO Announcements (course_id, title, content, posted_by)
VALUES (1, 'Midterm Project Announcement', 'Please review the BST project guidelines uploaded in Module 3 before Friday.', 1);