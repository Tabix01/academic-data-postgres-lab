-- ============================================================
-- 02_test_finalize_term_grades.sql
-- Purpose: test the stored procedure with normal and error cases.
-- ============================================================

SET search_path TO academic_lab;

-- Test 1: error case. Non-existing term must raise an exception.
DO $$
BEGIN
  CALL finalize_term_grades(99999);
  RAISE EXCEPTION 'TEST FAILED: expected exception for non-existing term';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLERRM LIKE 'Term % does not exist' THEN
      RAISE NOTICE 'TEST PASSED: non-existing term raises exception';
    ELSE
      RAISE;
    END IF;
END;
$$;

-- Test 2: normal finalization for Spring term.
-- Term 2 is not finalised in seed data, so the procedure should update GPA values.
CALL finalize_term_grades(2);

SELECT
  s.student_id,
  s.full_name,
  s.gpa
FROM students s
ORDER BY s.student_id;

-- Test 3: calling the same procedure again should not duplicate work.
CALL finalize_term_grades(2);
