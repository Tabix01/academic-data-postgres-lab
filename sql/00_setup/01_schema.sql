-- ============================================================
-- Academic Data PostgreSQL Lab
-- 01_schema.sql
-- Purpose: create a realistic PostgreSQL schema for an academic system.
-- ============================================================

SET search_path TO academic_lab;

CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  department_name VARCHAR(120) NOT NULL UNIQUE,
  office_room VARCHAR(20),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE instructors (
  instructor_id SERIAL PRIMARY KEY,
  department_id INT NOT NULL REFERENCES departments(department_id),
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  hire_date DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  department_id INT NOT NULL REFERENCES departments(department_id),
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  enrollment_year INT NOT NULL CHECK (enrollment_year BETWEEN 2020 AND 2030),
  gpa NUMERIC(4,2) NOT NULL DEFAULT 0 CHECK (gpa BETWEEN 0 AND 4.00),
  status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'academic_leave', 'graduated', 'expelled')),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
  course_id SERIAL PRIMARY KEY,
  department_id INT NOT NULL REFERENCES departments(department_id),
  instructor_id INT REFERENCES instructors(instructor_id),
  course_code VARCHAR(20) NOT NULL UNIQUE,
  course_name VARCHAR(160) NOT NULL,
  credits INT NOT NULL CHECK (credits BETWEEN 1 AND 6),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE terms (
  term_id SERIAL PRIMARY KEY,
  academic_year VARCHAR(9) NOT NULL,
  term_name VARCHAR(30) NOT NULL CHECK (term_name IN ('Fall', 'Spring', 'Summer')),
  starts_on DATE NOT NULL,
  ends_on DATE NOT NULL,
  is_finalised BOOLEAN NOT NULL DEFAULT FALSE,
  CHECK (ends_on > starts_on),
  UNIQUE (academic_year, term_name)
);

CREATE TABLE enrollments (
  enrollment_id SERIAL PRIMARY KEY,
  student_id INT NOT NULL REFERENCES students(student_id),
  course_id INT NOT NULL REFERENCES courses(course_id),
  term_id INT NOT NULL REFERENCES terms(term_id),
  grade NUMERIC(5,2) CHECK (grade BETWEEN 0 AND 100),
  status VARCHAR(20) NOT NULL DEFAULT 'enrolled' CHECK (status IN ('enrolled', 'completed', 'failed', 'withdrawn')),
  enrolled_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (student_id, course_id, term_id)
);

-- Raw import table: intentionally not fully constrained.
-- It is used to demonstrate audit queries before loading data into normalized tables.
CREATE TABLE staging_enrollments_raw (
  raw_id SERIAL PRIMARY KEY,
  student_email VARCHAR(150),
  course_code VARCHAR(20),
  term_label VARCHAR(30),
  grade_text VARCHAR(20),
  imported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Helpful indexes for foreign-key joins.
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_instructors_department ON instructors(department_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_courses_instructor ON courses(instructor_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_enrollments_term ON enrollments(term_id);
