-- ============================================================
-- 01_join_enrollments.sql
-- Purpose: show enrollment details using JOIN across several tables.
-- ============================================================

SET search_path TO academic_lab;

SELECT
  e.enrollment_id,
  s.full_name AS student_name,
  d.department_name,
  c.course_code,
  c.course_name,
  t.academic_year,
  t.term_name,
  e.grade,
  e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN departments d ON d.department_id = s.department_id
JOIN courses c ON c.course_id = e.course_id
JOIN terms t ON t.term_id = e.term_id
WHERE t.academic_year = '2025-2026'
ORDER BY d.department_name, s.full_name, c.course_code;
