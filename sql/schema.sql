-- ============================================================
-- InternSphere - Integrated Internship & Online Examination
-- Management System
-- Database: MySQL 8+
-- ============================================================

DROP DATABASE IF EXISTS internsphere;
CREATE DATABASE internsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE internsphere;

-- ============================================================
-- 1. USERS - Authentication & role info
-- ============================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','STUDENT') NOT NULL,
    is_logged_in BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. STUDENTS - Student profile linked to user
-- ============================================================
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    user_id INT UNIQUE,
    course VARCHAR(100) NOT NULL,
    cgpa DECIMAL(3,2) CHECK (cgpa BETWEEN 0 AND 10),
    phone VARCHAR(15) UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- 3. COMPANIES
-- ============================================================
CREATE TABLE companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(150) NOT NULL,
    location VARCHAR(100) NOT NULL,
    eligibility_cgpa DECIMAL(3,2) NOT NULL CHECK (eligibility_cgpa BETWEEN 0 AND 10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. INTERNSHIPS
-- ============================================================
CREATE TABLE internships (
    internship_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    stipend DECIMAL(10,2) CHECK (stipend >= 0),
    deadline DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

-- ============================================================
-- 5. APPLICATIONS
-- ============================================================
CREATE TABLE applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    internship_id INT NOT NULL,
    status ENUM('APPLIED','SHORTLISTED','REJECTED','SELECTED') DEFAULT 'APPLIED',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, internship_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (internship_id) REFERENCES internships(internship_id) ON DELETE CASCADE
);

-- ============================================================
-- 6. APPLICATION_LOGS
-- ============================================================
CREATE TABLE application_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    action VARCHAR(100) NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
);

-- ============================================================
-- 7. EXAMS
-- ============================================================
CREATE TABLE exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(150) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    total_marks INT CHECK (total_marks > 0)
);

-- ============================================================
-- 8. QUESTIONS
-- ============================================================
CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    question_text TEXT NOT NULL,
    type ENUM('MCQ','SUBJECTIVE') NOT NULL,
    marks INT NOT NULL CHECK (marks > 0),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);

-- ============================================================
-- 9. OPTIONS (for MCQ questions)
-- ============================================================
CREATE TABLE options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

-- ============================================================
-- 10. EXAM_ATTEMPTS
-- ============================================================
CREATE TABLE exam_attempts (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    exam_id INT NOT NULL,
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_time DATETIME,
    status ENUM('IN_PROGRESS','SUBMITTED','AUTO_SUBMITTED') DEFAULT 'IN_PROGRESS',
    UNIQUE(user_id, exam_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);

-- ============================================================
-- 11. ANSWERS
-- ============================================================
CREATE TABLE answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option INT,
    descriptive_answer TEXT,
    marks_awarded DECIMAL(5,2) DEFAULT 0,
    UNIQUE(attempt_id, question_id),
    FOREIGN KEY (attempt_id) REFERENCES exam_attempts(attempt_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
    FOREIGN KEY (selected_option) REFERENCES options(option_id) ON DELETE SET NULL
);

-- ============================================================
-- 12. AUDIT_LOGS
-- ============================================================
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(255) NOT NULL,
    ip_address VARCHAR(50),
    user_agent VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ============================================================
-- 13. SESSION_TRACKING (Advanced Security)
-- ============================================================
CREATE TABLE session_tracking (
    session_id VARCHAR(100) PRIMARY KEY,
    user_id INT UNIQUE,
    ip_address VARCHAR(50),
    user_agent VARCHAR(255),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_students_cgpa ON students(cgpa);
CREATE INDEX idx_internships_deadline ON internships(deadline);
CREATE INDEX idx_internships_company ON internships(company_id);
CREATE INDEX idx_applications_student ON applications(student_id);
CREATE INDEX idx_applications_internship ON applications(internship_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_questions_exam ON questions(exam_id);
CREATE INDEX idx_options_question ON options(question_id);
CREATE INDEX idx_exam_attempts_user ON exam_attempts(user_id);
CREATE INDEX idx_answers_attempt ON answers(attempt_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_time ON audit_logs(log_time);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Admin user (password: admin123)
INSERT INTO users (name, email, password, role) VALUES
('System Administrator', 'admin@internsphere.io', 'admin123', 'ADMIN');

-- Student users (password: student123)
INSERT INTO users (name, email, password, role) VALUES
('Elena Rodriguez', 'elena@university.edu', 'student123', 'STUDENT'),
('David Chen', 'david@university.edu', 'student123', 'STUDENT'),
('Marcus King', 'marcus@university.edu', 'student123', 'STUDENT'),
('Priya Sharma', 'priya@university.edu', 'student123', 'STUDENT'),
('Alex Turner', 'alex@university.edu', 'student123', 'STUDENT');

-- Student profiles
INSERT INTO students (student_id, user_id, course, cgpa, phone) VALUES
(1001, 2, 'Computer Science', 8.50, '9876543210'),
(1002, 3, 'Data Science', 7.80, '9876543211'),
(1003, 4, 'UX Design', 6.90, '9876543212'),
(1004, 5, 'Computer Science', 9.20, '9876543213'),
(1005, 6, 'Information Technology', 5.50, '9876543214');

-- Companies
INSERT INTO companies (company_name, location, eligibility_cgpa) VALUES
('NeuralTech Systems', 'Seattle, WA', 7.00),
('Atmosphere Labs', 'Remote', 6.50),
('DataForge Inc.', 'San Francisco, CA', 8.00),
('CyberNova Solutions', 'Bangalore, India', 7.50),
('Quantum Dynamics', 'New York, NY', 8.50);

-- Internships
INSERT INTO internships (company_id, role, stipend, deadline) VALUES
(1, 'Machine Learning Intern', 25000.00, '2026-06-30'),
(2, 'UX/UI Design Fellow', 20000.00, '2026-07-15'),
(3, 'Data Analyst Intern', 30000.00, '2026-06-15'),
(4, 'Frontend Developer', 22000.00, '2026-08-01'),
(5, 'Research Intern', 35000.00, '2026-05-30');

-- Sample applications
INSERT INTO applications (student_id, internship_id, status) VALUES
(1001, 1, 'SHORTLISTED'),
(1002, 3, 'APPLIED'),
(1003, 2, 'APPLIED'),
(1004, 1, 'SELECTED'),
(1004, 5, 'APPLIED');

-- Application logs
INSERT INTO application_logs (application_id, action) VALUES
(1, 'APPLIED'),
(1, 'SHORTLISTED'),
(2, 'APPLIED'),
(3, 'APPLIED'),
(4, 'APPLIED'),
(4, 'SHORTLISTED'),
(4, 'SELECTED'),
(5, 'APPLIED');

-- Exam
INSERT INTO exams (exam_name, duration, start_time, end_time, total_marks) VALUES
('Certification Exam - NeuralTech ML', 60, '2026-07-01 09:00:00', '2026-07-01 10:00:00', 50);

-- Questions for exam 1
INSERT INTO questions (exam_id, question_text, type, marks) VALUES
(1, 'Which algorithm is best suited for classification tasks with labeled data?', 'MCQ', 5),
(1, 'What is the purpose of a loss function in neural networks?', 'MCQ', 5),
(1, 'Which of the following is NOT a type of machine learning?', 'MCQ', 5),
(1, 'What does the term "overfitting" mean in machine learning?', 'MCQ', 5),
(1, 'Which activation function is commonly used in the output layer for binary classification?', 'MCQ', 5),
(1, 'Explain the difference between supervised and unsupervised learning with real-world examples.', 'SUBJECTIVE', 10),
(1, 'Describe the backpropagation algorithm and its role in training neural networks.', 'SUBJECTIVE', 15);

-- Options for MCQ questions
-- Q1 options
INSERT INTO options (question_id, option_text, is_correct) VALUES
(1, 'K-Means Clustering', FALSE),
(1, 'Random Forest', TRUE),
(1, 'Principal Component Analysis', FALSE),
(1, 'Apriori Algorithm', FALSE);

-- Q2 options
INSERT INTO options (question_id, option_text, is_correct) VALUES
(2, 'To increase the number of features', FALSE),
(2, 'To measure how well the model predictions match actual values', TRUE),
(2, 'To split data into training and testing sets', FALSE),
(2, 'To visualize the data', FALSE);

-- Q3 options
INSERT INTO options (question_id, option_text, is_correct) VALUES
(3, 'Supervised Learning', FALSE),
(3, 'Reinforcement Learning', FALSE),
(3, 'Prescriptive Learning', TRUE),
(3, 'Unsupervised Learning', FALSE);

-- Q4 options
INSERT INTO options (question_id, option_text, is_correct) VALUES
(4, 'The model performs well on both training and test data', FALSE),
(4, 'The model memorizes training data and fails on unseen data', TRUE),
(4, 'The model is too simple to capture patterns', FALSE),
(4, 'The training process takes too long', FALSE);

-- Q5 options
INSERT INTO options (question_id, option_text, is_correct) VALUES
(5, 'ReLU', FALSE),
(5, 'Tanh', FALSE),
(5, 'Sigmoid', TRUE),
(5, 'Leaky ReLU', FALSE);

-- Sample audit logs
INSERT INTO audit_logs (user_id, action, ip_address, user_agent) VALUES
(1, 'ADMIN_LOGIN', '127.0.0.1', 'Mozilla/5.0'),
(2, 'STUDENT_LOGIN', '192.168.1.10', 'Mozilla/5.0'),
(2, 'APPLIED_INTERNSHIP', '192.168.1.10', 'Mozilla/5.0'),
(4, 'STUDENT_LOGIN', '192.168.1.12', 'Mozilla/5.0'),
(4, 'TAB_SWITCH_DETECTED', '192.168.1.12', 'Mozilla/5.0');

SELECT 'InternSphere database created successfully!' AS status;
