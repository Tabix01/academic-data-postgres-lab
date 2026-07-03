-- ============================================================
-- 03_window_student_ranking.sql
-- Purpose: rank students inside each department while keeping all rows visible.
-- ============================================================

SET search_path TO academic_lab;

SELECT
  d.department_name,
  s.full_name,
  s.gpa,
  DENSE_RANK() OVER (
    PARTITION BY d.department_id
    ORDER BY s.gpa DESC
  ) AS department_rank,
  LAG(s.gpa) OVER (
    PARTITION BY d.department_id
    ORDER BY s.gpa DESC
  ) AS previous_student_gpa,
  ROUND(
    s.gpa - LAG(s.gpa) OVER (
      PARTITION BY d.department_id
      ORDER BY s.gpa DESC
    ),
    2
  ) AS gap_from_previous
FROM students s
JOIN departments d ON d.department_id = s.department_id
WHERE s.status = 'active'
ORDER BY d.department_name, department_rank, s.full_name;
