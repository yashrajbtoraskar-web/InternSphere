-- ============================================================
-- InternSphere - Exam Assignment System Update
-- Adds exam types, sections, explanations, and exam assignments
-- ============================================================

USE internsphere;
SET SQL_SAFE_UPDATES = 0;

-- 1. Add columns to exams table (safe for re-run)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='internsphere' AND TABLE_NAME='exams' AND COLUMN_NAME='exam_type');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE exams ADD COLUMN exam_type ENUM(''INTERNSHIP'',''COMPANY'') DEFAULT ''INTERNSHIP'' AFTER exam_name', 'SELECT ''exam_type already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='internsphere' AND TABLE_NAME='exams' AND COLUMN_NAME='passing_percentage');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE exams ADD COLUMN passing_percentage INT DEFAULT 60 AFTER total_marks', 'SELECT ''passing_percentage already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2. Add columns to questions table (safe for re-run)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='internsphere' AND TABLE_NAME='questions' AND COLUMN_NAME='section');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE questions ADD COLUMN section VARCHAR(100) AFTER type', 'SELECT ''section already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='internsphere' AND TABLE_NAME='questions' AND COLUMN_NAME='explanation');
SET @sql = IF(@col_exists = 0, 'ALTER TABLE questions ADD COLUMN explanation TEXT AFTER marks', 'SELECT ''explanation already exists''');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3. Create exam_assignments table (admin assigns exam to student application)
CREATE TABLE IF NOT EXISTS exam_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    exam_id INT NOT NULL,
    user_id INT NOT NULL,
    assigned_by INT NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    result ENUM('PENDING','PASSED','FAILED','DISQUALIFIED') DEFAULT 'PENDING',
    score DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (application_id) REFERENCES applications(application_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_by) REFERENCES users(user_id),
    UNIQUE KEY unique_app_exam (application_id, exam_id)
);

-- 4. Update existing exams to be INTERNSHIP type
UPDATE exams SET exam_type = 'INTERNSHIP' WHERE exam_type IS NULL;

-- ============================================================
-- INTERNSHIP EXAM: 3 Sections (Logical Reasoning, Python, DSA)
-- ============================================================

-- Delete old exam data for clean slate (order matters for foreign keys)
DELETE FROM answers WHERE attempt_id IN (SELECT attempt_id FROM exam_attempts WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'Internship%Screening%'));
DELETE FROM exam_attempts WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'Internship%Screening%');
DELETE FROM exam_assignments WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'Internship%Screening%');
DELETE FROM options WHERE question_id IN (SELECT question_id FROM questions WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'Internship%Screening%'));
DELETE FROM questions WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'Internship%Screening%');
DELETE FROM exams WHERE exam_name LIKE 'Internship%Screening%';

INSERT INTO exams (exam_name, exam_type, duration, start_time, end_time, total_marks, passing_percentage)
VALUES ('Internship Screening Test', 'INTERNSHIP', 30, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 60, 60);

SET @intern_exam = LAST_INSERT_ID();

-- Section 1: Basic Logical Reasoning (5 questions × 4 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'If all cats are animals and all animals breathe, which statement is definitely TRUE?', 'MCQ', 'Logical Reasoning', 4,
'Since all cats are animals and all animals breathe, by transitive logic (syllogism), all cats must also breathe.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'All cats breathe', TRUE),
(@q, 'All animals are cats', FALSE),
(@q, 'Some cats do not breathe', FALSE),
(@q, 'No cats are animals', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What comes next in the series: 2, 6, 12, 20, 30, ?', 'MCQ', 'Logical Reasoning', 4,
'The differences between consecutive terms are 4, 6, 8, 10, so the next difference is 12. Therefore 30 + 12 = 42.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '36', FALSE),
(@q, '40', FALSE),
(@q, '42', TRUE),
(@q, '44', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'A clock shows 3:15. What is the angle between the hour and minute hands?', 'MCQ', 'Logical Reasoning', 4,
'At 3:15, the minute hand is at 90°. The hour hand moves 0.5° per minute, so at 3:15 it is at 90° + 7.5° = 97.5°. The angle between them is 7.5°.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '0°', FALSE),
(@q, '7.5°', TRUE),
(@q, '15°', FALSE),
(@q, '22.5°', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'If APPLE is coded as 50 (A=1,P=16,P=16,L=12,E=5), what is the code for CAT?', 'MCQ', 'Logical Reasoning', 4,
'C=3, A=1, T=20. Sum = 3 + 1 + 20 = 24.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '22', FALSE),
(@q, '24', TRUE),
(@q, '26', FALSE),
(@q, '28', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'In a race of 5 people, if A finishes before B but after C, and D finishes last while E finishes before C, what is the correct order?', 'MCQ', 'Logical Reasoning', 4,
'E finishes before C, C finishes before A, A finishes before B, and D is last. So the order is: E, C, A, B, D.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'E, C, A, B, D', TRUE),
(@q, 'C, E, A, B, D', FALSE),
(@q, 'A, C, E, B, D', FALSE),
(@q, 'E, A, C, B, D', FALSE);

-- Section 2: Python Basics (5 questions × 4 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What will be the output of: print(type([]) == type(()))', 'MCQ', 'Python Basics', 4,
'[] is a list and () is a tuple. type([]) returns <class ''list''> and type(()) returns <class ''tuple''>. Since they are different types, the comparison returns False.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'True', FALSE),
(@q, 'False', TRUE),
(@q, 'Error', FALSE),
(@q, 'None', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'Which of the following is used to define a function in Python?', 'MCQ', 'Python Basics', 4,
'In Python, the keyword "def" is used to define a function. For example: def my_function(): ...');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'function', FALSE),
(@q, 'def', TRUE),
(@q, 'func', FALSE),
(@q, 'define', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What is the output of: print(list(range(0, 10, 3)))', 'MCQ', 'Python Basics', 4,
'range(0, 10, 3) generates numbers starting from 0, incrementing by 3, and stopping before 10. So: [0, 3, 6, 9].');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '[0, 3, 6, 9]', TRUE),
(@q, '[0, 3, 6, 9, 12]', FALSE),
(@q, '[3, 6, 9]', FALSE),
(@q, '[0, 3, 6]', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'Which data structure in Python uses key-value pairs?', 'MCQ', 'Python Basics', 4,
'A dictionary (dict) in Python stores data as key-value pairs. Example: {"name": "John", "age": 25}.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'List', FALSE),
(@q, 'Tuple', FALSE),
(@q, 'Dictionary', TRUE),
(@q, 'Set', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What will be the output of: x = [1,2,3]; x.append([4,5]); print(len(x))', 'MCQ', 'Python Basics', 4,
'append() adds the entire list [4,5] as a single element. So x becomes [1, 2, 3, [4, 5]], which has 4 elements.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '5', FALSE),
(@q, '4', TRUE),
(@q, '3', FALSE),
(@q, 'Error', FALSE);

-- Section 3: DSA Basics (5 questions × 4 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What is the time complexity of searching an element in a sorted array using Binary Search?', 'MCQ', 'DSA Basics', 4,
'Binary Search divides the search space in half at each step. After k comparisons, the search space is N/2^k. It takes O(log N) comparisons to find the element.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'O(N)', FALSE),
(@q, 'O(N²)', FALSE),
(@q, 'O(log N)', TRUE),
(@q, 'O(1)', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'Which data structure uses FIFO (First In, First Out) ordering?', 'MCQ', 'DSA Basics', 4,
'A Queue follows FIFO ordering — the first element added is the first to be removed. Think of a line at a ticket counter.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'Stack', FALSE),
(@q, 'Queue', TRUE),
(@q, 'Tree', FALSE),
(@q, 'Graph', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What is the time complexity of inserting an element at the beginning of a linked list?', 'MCQ', 'DSA Basics', 4,
'Inserting at the beginning of a linked list only requires creating a new node and updating the head pointer. No shifting is needed, so it takes O(1) time.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'O(1)', TRUE),
(@q, 'O(N)', FALSE),
(@q, 'O(log N)', FALSE),
(@q, 'O(N²)', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'In a stack, which operation removes and returns the top element?', 'MCQ', 'DSA Basics', 4,
'The pop() operation removes and returns the top element from a stack. push() adds an element, peek() only views the top without removing it.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'push()', FALSE),
(@q, 'pop()', TRUE),
(@q, 'peek()', FALSE),
(@q, 'remove()', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@intern_exam, 'What is the worst-case time complexity of Bubble Sort?', 'MCQ', 'DSA Basics', 4,
'Bubble Sort compares adjacent elements and swaps them. In the worst case (reverse sorted array), it requires N-1 passes, each with up to N-1 comparisons, giving O(N²).');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'O(N)', FALSE),
(@q, 'O(N log N)', FALSE),
(@q, 'O(N²)', TRUE),
(@q, 'O(2^N)', FALSE);

-- ============================================================
-- COMPANY EXAM: Coding Round (3 Sections: Easy1, Easy2, Medium)
-- ============================================================

DELETE FROM answers WHERE attempt_id IN (SELECT attempt_id FROM exam_attempts WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'PPO%Coding%'));
DELETE FROM exam_attempts WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'PPO%Coding%');
DELETE FROM exam_assignments WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'PPO%Coding%');
DELETE FROM options WHERE question_id IN (SELECT question_id FROM questions WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'PPO%Coding%'));
DELETE FROM questions WHERE exam_id IN (SELECT exam_id FROM exams WHERE exam_name LIKE 'PPO%Coding%');
DELETE FROM exams WHERE exam_name LIKE 'PPO%Coding%';

INSERT INTO exams (exam_name, exam_type, duration, start_time, end_time, total_marks, passing_percentage)
VALUES ('PPO Coding Round', 'COMPANY', 45, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 60, 50);

SET @company_exam = LAST_INSERT_ID();

-- Section 1: Easy DSA (2 questions × 10 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'Given an array [2, 7, 11, 15] and target = 9, find two numbers that add up to the target. What are their indices?', 'MCQ', 'Easy - Section 1', 10,
'This is the classic Two Sum problem. We need to find two numbers that sum to 9. arr[0]=2 and arr[1]=7, and 2+7=9. So indices are [0, 1]. A HashMap approach gives O(N) time complexity.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '[0, 1]', TRUE),
(@q, '[1, 2]', FALSE),
(@q, '[0, 3]', FALSE),
(@q, '[2, 3]', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'What is the output of reversing the string "hello world"?', 'MCQ', 'Easy - Section 1', 10,
'Reversing a string means reading it from the last character to the first. "hello world" reversed is "dlrow olleh". This is a basic string manipulation problem.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, 'world hello', FALSE),
(@q, 'dlrow olleh', TRUE),
(@q, 'olleh dlrow', FALSE),
(@q, 'hello world', FALSE);

-- Section 2: Easy DSA (2 questions × 10 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'Given a linked list 1→2→3→4→5, what is the middle element?', 'MCQ', 'Easy - Section 2', 10,
'For a linked list with 5 nodes, the middle element is at position 3, which is node with value 3. The slow-fast pointer technique finds the middle in O(N) time with O(1) space.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '2', FALSE),
(@q, '3', TRUE),
(@q, '4', FALSE),
(@q, '1', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'Given the array [1, 1, 2, 2, 3], which element appears an odd number of times?', 'MCQ', 'Easy - Section 2', 10,
'1 appears 2 times (even), 2 appears 2 times (even), 3 appears 1 time (odd). XOR of all elements gives the answer since x⊕x=0 and x⊕0=x. This problem demonstrates the XOR trick.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '1', FALSE),
(@q, '2', FALSE),
(@q, '3', TRUE),
(@q, 'No such element', FALSE);

-- Section 3: Medium DSA (2 questions × 10 marks = 20)
INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'Given the string "abcabcbb", what is the length of the longest substring without repeating characters?', 'MCQ', 'Medium - Section 3', 10,
'Using the sliding window technique: We maintain a window [i,j] and a HashSet. "abc" has length 3, then "bca" has length 3, "cab" has length 3. The maximum is 3 ("abc"). This is LeetCode #3 — the sliding window approach gives O(N) time complexity.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '2', FALSE),
(@q, '3', TRUE),
(@q, '4', FALSE),
(@q, '7', FALSE);

INSERT INTO questions (exam_id, question_text, type, section, marks, explanation)
VALUES (@company_exam, 'You are climbing a staircase that takes N steps. Each time you can climb 1 or 2 steps. How many distinct ways can you climb to the top when N=5?', 'MCQ', 'Medium - Section 3', 10,
'This is the classic Climbing Stairs problem (LeetCode #70). It follows the Fibonacci pattern: ways(1)=1, ways(2)=2, ways(3)=3, ways(4)=5, ways(5)=8. The recurrence is ways(n) = ways(n-1) + ways(n-2). Dynamic programming solves this in O(N) time.');

SET @q = LAST_INSERT_ID();
INSERT INTO options (question_id, option_text, is_correct) VALUES
(@q, '5', FALSE),
(@q, '6', FALSE),
(@q, '8', TRUE),
(@q, '10', FALSE);

-- Verify
SELECT 'Internship Exam Questions:' AS info, COUNT(*) AS count FROM questions WHERE exam_id = @intern_exam;
SELECT 'Company Exam Questions:' AS info, COUNT(*) AS count FROM questions WHERE exam_id = @company_exam;
SELECT exam_id, exam_name, exam_type, total_marks, passing_percentage FROM exams WHERE exam_type IN ('INTERNSHIP','COMPANY');

SET SQL_SAFE_UPDATES = 1;
