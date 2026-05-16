CREATE DATABASE bug_tracking_system;

USE bug_tracking_system;
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PROJECTS TABLE
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50)
);

-- ISSUES TABLE
CREATE TABLE issues (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    assigned_to INT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority VARCHAR(20),
    status VARCHAR(30),
    issue_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- COMMENTS TABLE
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT,
    user_id INT,
    comment_text TEXT,
    commented_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (issue_id) REFERENCES issues(issue_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
USE bug_tracking_system;

-- INSERT USERS
INSERT INTO users (full_name, email, role)
VALUES
('Kasturi Mishra', 'kasturi@gmail.com', 'Admin'),
('Rahul Sharma', 'rahul@gmail.com', 'Developer'),
('Priya Singh', 'priya@gmail.com', 'Tester'),
('Aman Verma', 'aman@gmail.com', 'Project Manager');

-- INSERT PROJECTS
INSERT INTO projects (project_name, description, start_date, end_date, status)
VALUES
('E-Commerce Website', 'Online shopping platform', '2026-01-10', '2026-06-30', 'In Progress'),
('Banking App', 'Mobile banking application', '2026-02-01', '2026-08-15', 'Pending'),
('Inventory System', 'Warehouse inventory management', '2026-03-05', '2026-07-20', 'Completed');

-- INSERT ISSUES
INSERT INTO issues 
(project_id, assigned_to, title, description, priority, status, issue_type)
VALUES
(1, 2, 'Login Page Crash', 'Application crashes on login', 'High', 'Open', 'Bug'),

(1, 2, 'Payment Gateway Error', 'Payment not processing', 'Critical', 'In Progress', 'Bug'),

(2, 3, 'UI Alignment Issue', 'Buttons not aligned properly', 'Low', 'Open', 'UI Bug'),

(3, 2, 'Database Optimization', 'Improve query performance', 'Medium', 'Resolved', 'Task');

-- INSERT COMMENTS
INSERT INTO comments (issue_id, user_id, comment_text)
VALUES
(1, 3, 'Bug reproduced successfully'),
(1, 2, 'Working on fixing the issue'),
(2, 1, 'High priority issue'),
(4, 2, 'Optimization completed');
USE bug_tracking_system;

-- 1. VIEW ALL USERS
SELECT * FROM users;

-- 2. VIEW ALL PROJECTS
SELECT * FROM projects;

-- 3. VIEW ALL ISSUES
SELECT * FROM issues;

-- 4. SHOW ISSUES WITH ASSIGNED DEVELOPER NAME
SELECT 
    issues.issue_id,
    issues.title,
    issues.priority,
    issues.status,
    users.full_name AS assigned_developer
FROM issues
JOIN users
ON issues.assigned_to = users.user_id;

-- 5. SHOW ISSUES WITH PROJECT NAME
SELECT
    issues.issue_id,
    issues.title,
    projects.project_name,
    issues.status
FROM issues
JOIN projects
ON issues.project_id = projects.project_id;

-- 6. COUNT TOTAL ISSUES IN EACH PROJECT
SELECT
    projects.project_name,
    COUNT(issues.issue_id) AS total_issues
FROM projects
LEFT JOIN issues
ON projects.project_id = issues.project_id
GROUP BY projects.project_name;

-- 7. SHOW HIGH PRIORITY ISSUES
SELECT *
FROM issues
WHERE priority = 'High';

-- 8. SHOW OPEN ISSUES
SELECT *
FROM issues
WHERE status = 'Open';

-- 9. SORT ISSUES BY PRIORITY
SELECT *
FROM issues
ORDER BY priority DESC;

-- 10. SHOW COMMENTS WITH USER NAMES
SELECT
    comments.comment_text,
    users.full_name,
    comments.commented_at
FROM comments
JOIN users
ON comments.user_id = users.user_id;
USE bug_tracking_system;

-- 1. COUNT TOTAL USERS
SELECT COUNT(*) AS total_users
FROM users;

-- 2. COUNT TOTAL PROJECTS
SELECT COUNT(*) AS total_projects
FROM projects;

-- 3. COUNT TOTAL ISSUES
SELECT COUNT(*) AS total_issues
FROM issues;

-- 4. COUNT ISSUES BASED ON STATUS
SELECT
    status,
    COUNT(*) AS total
FROM issues
GROUP BY status;

-- 5. COUNT ISSUES BASED ON PRIORITY
SELECT
    priority,
    COUNT(*) AS total
FROM issues
GROUP BY priority;

-- 6. SHOW DEVELOPER WORKLOAD
SELECT
    users.full_name,
    COUNT(issues.issue_id) AS assigned_issues
FROM users
LEFT JOIN issues
ON users.user_id = issues.assigned_to
GROUP BY users.full_name;

-- 7. SHOW PROJECT WITH MAXIMUM ISSUES
SELECT
    projects.project_name,
    COUNT(issues.issue_id) AS total_issues
FROM projects
JOIN issues
ON projects.project_id = issues.project_id
GROUP BY projects.project_name
ORDER BY total_issues DESC;

-- 8. SHOW RESOLVED ISSUES
SELECT *
FROM issues
WHERE status = 'Resolved';

-- 9. SHOW PENDING/OPEN ISSUES
SELECT *
FROM issues
WHERE status IN ('Open', 'In Progress');

-- 10. SHOW ALL BUG TYPE ISSUES
SELECT *
FROM issues
WHERE issue_type = 'Bug';

-- 11. SHOW NUMBER OF COMMENTS ON EACH ISSUE
SELECT
    issues.title,
    COUNT(comments.comment_id) AS total_comments
FROM issues
LEFT JOIN comments
ON issues.issue_id = comments.issue_id
GROUP BY issues.title;

-- 12. SHOW LATEST CREATED ISSUES
SELECT *
FROM issues
ORDER BY created_at DESC;

-- 13. SHOW PROJECT STATUS REPORT
SELECT
    project_name,
    status,
    start_date,
    end_date
FROM projects;

-- 14. SHOW HIGH PRIORITY OPEN ISSUES
SELECT *
FROM issues
WHERE priority = 'High'
AND status = 'Open';