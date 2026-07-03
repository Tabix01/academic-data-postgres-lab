-- ============================================================
-- 02_group_by_course_statistics.sql
-- Purpose: calculate summary statistics per course using GROUP BY and HAVING.
-- ============================================================

SET search_path TO academic_lab;

SELECT
  c.course_code,
  c.course_name,
  COUNT(e.enrollment_id) AS enrollment_count,
  ROUND(AVG(e.grade), 2) AS average_grade,
  MIN(e.grade) AS min_grade,
  MAX(e.grade) AS max_grade,
  ROUND(100.0 * COUNT(*) FILTER (WHERE e.grade >= 60) / COUNT(*), 2) AS pass_rate_percent
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.course_id, c.course_code, c.course_name
HAVING COUNT(e.enrollment_id) >= 2
ORDER BY average_grade DESC;
