-- ============================================================
-- 01_finalize_term_grades.sql
-- Purpose: create a PL/pgSQL stored procedure that finalizes a term.
-- ============================================================

SET search_path TO academic_lab;

CREATE OR REPLACE PROCEDURE finalize_term_grades(p_term_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
  v_updated_students INT;
  v_term_exists BOOLEAN;
  v_already_finalised BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM terms
    WHERE term_id = p_term_id
  ) INTO v_term_exists;

  IF NOT v_term_exists THEN
    RAISE EXCEPTION 'Term % does not exist', p_term_id;
  END IF;

  SELECT is_finalised
  INTO v_already_finalised
  FROM terms
  WHERE term_id = p_term_id;

  IF v_already_finalised THEN
    RAISE NOTICE 'Term % is already finalised. No changes were made.', p_term_id;
    RETURN;
  END IF;

  -- Recalculate GPA using average grade for the selected term.
  -- Conversion rule for this educational project: percentage grade / 25.
  UPDATE students s
  SET gpa = sub.new_gpa
  FROM (
    SELECT
      e.student_id,
      ROUND((AVG(e.grade) / 25.0)::NUMERIC, 2) AS new_gpa
    FROM enrollments e
    WHERE e.term_id = p_term_id
      AND e.grade IS NOT NULL
      AND e.status IN ('completed', 'failed')
    GROUP BY e.student_id
  ) sub
  WHERE s.student_id = sub.student_id;

  GET DIAGNOSTICS v_updated_students = ROW_COUNT;

  UPDATE terms
  SET is_finalised = TRUE
  WHERE term_id = p_term_id;

  RAISE NOTICE 'Term % finalised. % student GPA records updated.', p_term_id, v_updated_students;
END;
$$;
