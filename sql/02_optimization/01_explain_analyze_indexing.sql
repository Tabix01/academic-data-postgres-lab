-- ============================================================
-- 01_explain_analyze_indexing.sql
-- Purpose: demonstrate query optimization with EXPLAIN ANALYZE and indexing.
-- Notes:
--   A separate synthetic table is used so that the execution plan is visible
--   even on a small local project database.
-- ============================================================

SET search_path TO academic_lab;

DROP TABLE IF EXISTS performance_enrollments;

CREATE TABLE performance_enrollments (
  enrollment_id BIGSERIAL PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  term_id INT NOT NULL,
  grade NUMERIC(5,2) NOT NULL,
  status VARCHAR(20) NOT NULL
);

-- Generate 200,000 synthetic rows.
-- Most grades are passing, and only a small share are below 60.
INSERT INTO performance_enrollments (student_id, course_id, term_id, grade, status)
SELECT
  ((gs - 1) % 12) + 1 AS student_id,
  ((gs - 1) % 8) + 1 AS course_id,
  ((gs - 1) % 2) + 1 AS term_id,
  CASE
    WHEN gs % 100 = 0 THEN (30 + (gs % 30))::NUMERIC(5,2)
    ELSE (60 + (gs % 40))::NUMERIC(5,2)
  END AS grade,
  CASE
    WHEN gs % 100 = 0 THEN 'failed'
    ELSE 'completed'
  END AS status
FROM generate_series(1, 200000) AS gs;

ANALYZE performance_enrollments;

-- ------------------------------------------------------------
-- BEFORE OPTIMIZATION
-- Expected plan: sequential scan on performance_enrollments,
-- because there is no useful index yet.
-- ------------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT
  s.full_name,
  c.course_code,
  p.grade
FROM performance_enrollments p
JOIN students s ON s.student_id = p.student_id
JOIN courses c ON c.course_id = p.course_id
WHERE p.term_id = 2
  AND p.grade < 60;

-- ------------------------------------------------------------
-- INDEX CREATION
-- Composite partial index: term_id + grade, only for low grades.
-- This matches the filter used in the analytical report.
-- ------------------------------------------------------------
CREATE INDEX idx_performance_term_grade_low
ON performance_enrollments (term_id, grade)
WHERE grade < 60;

ANALYZE performance_enrollments;

-- ------------------------------------------------------------
-- AFTER OPTIMIZATION
-- Expected plan: index scan or bitmap index scan using
-- idx_performance_term_grade_low.
-- ------------------------------------------------------------
EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT
  s.full_name,
  c.course_code,
  p.grade
FROM performance_enrollments p
JOIN students s ON s.student_id = p.student_id
JOIN courses c ON c.course_id = p.course_id
WHERE p.term_id = 2
  AND p.grade < 60;
