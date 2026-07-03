-- ============================================================
-- Academic Data PostgreSQL Lab
-- 03_data_quality_audit.sql
-- Purpose: demonstrate data audit queries before analysis.
-- ============================================================

SET search_path TO academic_lab;

-- Audit 1: rows from raw import with an unknown student email.
SELECT r.raw_id, r.student_email, r.course_code, r.grade_text
FROM staging_enrollments_raw r
LEFT JOIN students s ON s.email = r.student_email
WHERE s.student_id IS NULL;

-- Audit 2: rows from raw import with an unknown course code.
SELECT r.raw_id, r.student_email, r.course_code, r.grade_text
FROM staging_enrollments_raw r
LEFT JOIN courses c ON c.course_code = r.course_code
WHERE c.course_id IS NULL;

-- Audit 3: invalid grade values in raw import.
SELECT raw_id, student_email, course_code, grade_text
FROM staging_enrollments_raw
WHERE grade_text !~ '^\d+(\.\d+)?$'
   OR grade_text::NUMERIC < 0
   OR grade_text::NUMERIC > 100;

-- Audit 4: check whether normalized enrollments have grades outside allowed range.
-- This should return 0 rows because the table has a CHECK constraint.
SELECT enrollment_id, student_id, course_id, grade
FROM enrollments
WHERE grade < 0 OR grade > 100;

-- Audit 5: find students without any enrollments.
SELECT s.student_id, s.full_name, d.department_name
FROM students s
JOIN departments d ON d.department_id = s.department_id
LEFT JOIN enrollments e ON e.student_id = s.student_id
WHERE e.enrollment_id IS NULL;
