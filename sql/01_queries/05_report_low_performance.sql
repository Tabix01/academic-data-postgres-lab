-- ============================================================
-- 05_report_low_performance.sql
-- Purpose: generate a practical report of students at academic risk.
-- ============================================================

SET search_path TO academic_lab;

WITH student_course_stats AS (
  SELECT
    s.student_id,
    s.full_name,
    d.department_name,
    COUNT(e.enrollment_id) AS total_courses,
    COUNT(*) FILTER (WHERE e.grade < 60) AS failed_courses,
    ROUND(AVG(e.grade), 2) AS avg_grade
  FROM students s
  JOIN departments d ON d.department_id = s.department_id
  JOIN enrollments e ON e.student_id = s.student_id
  GROUP BY s.student_id, s.full_name, d.department_name
),
risk_level AS (
  SELECT
    *,
    CASE
      WHEN failed_courses >= 2 THEN 'High risk'
      WHEN avg_grade < 65 THEN 'Medium risk'
      ELSE 'Low risk'
    END AS academic_risk
  FROM student_course_stats
)
SELECT *
FROM risk_level
WHERE academic_risk <> 'Low risk'
ORDER BY
  CASE academic_risk
    WHEN 'High risk' THEN 1
    WHEN 'Medium risk' THEN 2
    ELSE 3
  END,
  avg_grade ASC;
