# 🌐 InternSphere
### Integrated Internship & Online Examination Management System

A full-stack web application built with **Java Servlets, JSP, JDBC, and MySQL** that manages the complete lifecycle of student internships along with an online examination module — all in one platform.

---

## 📌 About the Project

InternSphere is a role-based web portal designed for academic institutions to streamline internship tracking and online examination management. It supports two user roles — **Admin** and **Student** — each with a dedicated dashboard and feature set.

---

## ✨ Features

### 👨‍💼 Admin Panel
- Dashboard with statistics and overview
- Manage Companies & Internship Listings
- Manage Student Applications (approve/reject)
- Create and Manage Online Exams & Questions
- Assign Exams to Students
- View Exam Scores & Evaluate Results
- Generate Reports
- Audit Log Tracking

### 🎓 Student Panel
- Dashboard with internship and exam summary
- Browse & Apply for Internships
- Track Application Status
- Appear for Assigned Online Exams
- View Exam Results & Scores
- Update Profile & Settings

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | JSP, HTML5, CSS3, JavaScript |
| Backend | Java Servlets (Jakarta EE 6.0) |
| Database | MySQL 8+ |
| Server | Apache Tomcat 10.1 |
| JDBC Driver | MySQL Connector/J 9.6.0 |
| Containerization | Docker |

---

## 📁 Project Structure

```
InternSphere/
├── src/                          → Java source files
│   └── com/internsphere/
│       ├── controller/           → Servlet controllers
│       ├── dao/                  → Database Access Objects
│       ├── model/                → Java model/entity classes
│       ├── filter/               → Auth & role-based filters
│       └── util/                 → DBUtil (DB connection)
├── web/                          → Web resources
│   ├── index.jsp                 → Entry point
│   ├── css/                      → Stylesheets
│   ├── js/                       → JavaScript files
│   ├── jsp/
│   │   ├── admin/                → Admin JSP pages
│   │   ├── student/              → Student JSP pages
│   │   └── common/               → Shared components (header, sidebar, footer)
│   └── WEB-INF/
│       ├── web.xml               → Servlet/filter configuration
│       └── lib/                  → JAR dependencies
├── build/                        → Compiled build output
├── sql/
│   ├── schema.sql                → Full database schema
│   └── exam_update.sql           → Exam module SQL updates
├── ScreenShort/                  → Project screenshots
├── Dockerfile                    → Docker configuration
└── README.md                     → This file
```

---

## 🗄️ Database

- **Database:** MySQL 8+
- **Database Name:** `internsphere`
- **Key Tables:** `users`, `students`, `companies`, `internships`, `applications`, `exams`, `questions`, `exam_assignments`, `exam_attempts`, `answers`, `audit_logs`

To set up the database, run the SQL scripts in order:
```sql
-- Step 1: Run schema
source sql/schema.sql

-- Step 2: Run exam updates
source sql/exam_update.sql
```

---

## 🚀 How to Run Locally

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.1
- MySQL 8+
- IDE: IntelliJ IDEA / Eclipse / NetBeans

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yashrajbtoraskar-web/InternSphere.git
   cd InternSphere
   ```

2. **Set up the database**
   - Open MySQL and run `sql/schema.sql`
   - Then run `sql/exam_update.sql`

3. **Configure DB connection**
   - Open `src/com/internsphere/util/DBUtil.java`
   - Update the `URL`, `USER`, and `PASSWORD` fields with your MySQL credentials

4. **Build the project**
   - Compile Java sources and copy class files to `build/WEB-INF/classes/`

5. **Deploy on Tomcat**
   - Copy the `build/` folder contents to Tomcat's `webapps/ROOT/`
   - Start Tomcat: `catalina.sh run`

6. **Access the app**
   - Open browser → `http://localhost:8080`

---

## 🐳 Run with Docker

```bash
# Build Docker image
docker build -t internsphere .

# Run container
docker run -p 8080:8080 internsphere
```

> Note: Make sure to update `DBUtil.java` with your database host before building the Docker image.

---

## 📸 Screenshots

| Screen | Preview |
|---|---|
| Login / Signup | `ScreenShort/Login_Signup page.png` |
| Admin Dashboard | `ScreenShort/AdminDashboard.png` |
| Admin Applications | `ScreenShort/Admin_Application.png` |
| Admin Companies | `ScreenShort/Admin_Company.png` |
| Admin Examinations | `ScreenShort/Admin_Examination.png` |
| Admin Scores | `ScreenShort/Admin_Scores.png` |
| Admin Reports | `ScreenShort/Admin_Report.png` |
| Admin Audit Log | `ScreenShort/Admin_Audit.png` |
| Student Dashboard | `ScreenShort/Student/Student_Dashboard.png` |
| Student Internships | `ScreenShort/Student/Student_Internship.png` |
| Student Examination | `ScreenShort/Student/Student_Examination.png` |
| Student Results | `ScreenShort/Student/Student_Result.png` |
| ER Diagram | `ScreenShort/Student/ERDiagram.png` |

---

## 👤 Roles & Access

| Feature | Admin | Student |
|---|:---:|:---:|
| Manage Companies | ✅ | ❌ |
| Manage Internships | ✅ | ❌ |
| View Applications | ✅ | ✅ |
| Create Exams | ✅ | ❌ |
| Appear for Exam | ❌ | ✅ |
| View Scores | ✅ | ✅ |
| Audit Logs | ✅ | ❌ |
| Profile & Settings | ✅ | ✅ |

---

## 📬 Contact

**Built by Yashraj B. Toraskar**
GitHub: [github.com/yashrajbtoraskar-web](https://github.com/yashrajbtoraskar-web)
