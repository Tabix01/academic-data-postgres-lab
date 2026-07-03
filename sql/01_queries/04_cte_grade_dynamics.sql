-- ============================================================
-- 04_cte_grade_dynamics.sql
-- Purpose: compare average student grades between Fall and Spring using CTEs.
-- ============================================================

SET search_path TO academic_lab;

WITH fall_avg AS (
  SELECT
    e.student_id,
    ROUND(AVG(e.grade), 2) AS avg_grade_fall
  FROM enrollments e
  JOIN terms t ON t.term_id = e.term_id
  WHERE t.academic_year = '2025-2026'
    AND t.term_name = 'Fall'
    AND e.grade IS NOT NULL
  GROUP BY e.student_id
),
spring_avg AS (
  SELECT
    e.student_id,
    ROUND(AVG(e.grade), 2) AS avg_grade_spring
  FROM enrollments e
  JOIN terms t ON t.term_id = e.term_id
  WHERE t.academic_year = '2025-2026'
    AND t.term_name = 'Spring'
    AND e.grade IS NOT NULL
  GROUP BY e.student_id
),
comparison AS (
  SELECT
    s.student_id,
    s.full_name,
    d.department_name,
    f.avg_grade_fall,
    sp.avg_grade_spring,
    ROUND(sp.avg_grade_spring - f.avg_grade_fall, 2) AS grade_delta
  FROM students s
  JOIN departments d ON d.department_id = s.department_id
  JOIN fall_avg f ON f.student_id = s.student_id
  JOIN spring_avg sp ON sp.student_id = s.student_id
)
SELECT *
FROM comparison
ORDER BY grade_delta ASC;
