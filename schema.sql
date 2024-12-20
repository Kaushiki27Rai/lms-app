CREATE DATABASE ManagementSystems;
USE ManagementSystems;

-- Create tables
CREATE TABLE Users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       role ENUM('student', 'instructor', 'admin') DEFAULT 'student',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Courses (
                         course_id INT PRIMARY KEY AUTO_INCREMENT,
                         title VARCHAR(100) NOT NULL,
                         description TEXT,
                         instructor_id INT,
                         start_date DATE,
                         end_date DATE,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);

CREATE TABLE Enrollments (
                             enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
                             user_id INT,
                             course_id INT,
                             enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES Users(user_id),
                             FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Lessons (
                         lesson_id INT PRIMARY KEY AUTO_INCREMENT,
                         course_id INT,
                         title VARCHAR(100) NOT NULL,
                         content TEXT,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Assignments (
                             assignment_id INT PRIMARY KEY AUTO_INCREMENT,
                             course_id INT,
                             title VARCHAR(100) NOT NULL,
                             description TEXT,
                             due_date DATE,
                             FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Quizzes (
                         quiz_id INT PRIMARY KEY AUTO_INCREMENT,
                         course_id INT,
                         title VARCHAR(100) NOT NULL,
                         description TEXT,
                         date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Questions (
                           question_id INT PRIMARY KEY AUTO_INCREMENT,
                           quiz_id INT,
                           question_text TEXT,
                           option_a VARCHAR(255),
                           option_b VARCHAR(255),
                           option_c VARCHAR(255),
                           option_d VARCHAR(255),
                           correct_option CHAR(1),
                           FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id)
);

CREATE TABLE QuizSubmissions (
                                 submission_id INT PRIMARY KEY AUTO_INCREMENT,
                                 quiz_id INT,
                                 student_id INT,
                                 score DECIMAL(5, 2),
                                 submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id),
                                 FOREIGN KEY (student_id) REFERENCES Users(user_id)
);

-- Insert sample data for Users (Instructor and Student)
INSERT INTO Users (username, password, email, role)
VALUES ('Dr. Smith', 'securepassword', 'drsmith@example.com', 'instructor');

INSERT INTO Users (username, password, email, role)
VALUES ('Alice Johnson', 'password123', 'alice@example.com', 'student');

-- Insert a course with valid instructor_id
INSERT INTO Courses (title, description, instructor_id, start_date, end_date)
VALUES ('Introduction to SQL', 'Learn SQL basics', 1, '2024-11-10', '2024-12-10');

-- Enroll student in course
INSERT INTO Enrollments (course_id, user_id)
VALUES (1, 2);

-- Insert a quiz for the course
INSERT INTO Quizzes (course_id, title, description)
VALUES (1, 'SQL Basics Quiz', 'Test your knowledge on SQL basics');

-- Insert a quiz submission record for demonstration
INSERT INTO QuizSubmissions (quiz_id, student_id, score, submission_date)
VALUES (1, 2, 0, NOW());

-- Update quiz submission with a score
UPDATE QuizSubmissions
SET score = 85.5
WHERE submission_id = 1;

-- Select courses for a specific student
SELECT C.title, C.description
FROM Courses C
         JOIN Enrollments E ON C.course_id = E.course_id
WHERE E.user_id = 2;

desc Users;
desc Courses;
desc Enrollments;
desc Lessons;
desc Assignments;
desc Quizzes;
desc Questions;
desc QuizSubmissions;