-- Run from repository root with:
-- psql -d academic_data_lab -f sql/run_all.sql

\i sql/00_setup/00_reset.sql
\i sql/00_setup/01_schema.sql
\i sql/00_setup/02_seed_data.sql
\i sql/00_setup/03_data_quality_audit.sql
\i sql/01_queries/01_join_enrollments.sql
\i sql/01_queries/02_group_by_course_statistics.sql
\i sql/01_queries/03_window_student_ranking.sql
\i sql/01_queries/04_cte_grade_dynamics.sql
\i sql/01_queries/05_report_low_performance.sql
\i sql/03_procedures/01_finalize_term_grades.sql
\i sql/03_procedures/02_test_finalize_term_grades.sql
