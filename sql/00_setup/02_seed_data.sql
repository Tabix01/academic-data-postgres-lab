-- ============================================================
-- Academic Data PostgreSQL Lab
-- 02_seed_data.sql
-- Purpose: insert synthetic sample data.
-- ============================================================

SET search_path TO academic_lab;

INSERT INTO departments (department_name, office_room) VALUES
  ('Computer Science', 'A-301'),
  ('Information Systems', 'B-204'),
  ('Data Analytics', 'C-110'),
  ('Cybersecurity', 'D-405');

INSERT INTO instructors (department_id, full_name, email, hire_date) VALUES
  (1, 'Aidar Sakenov', 'aidar.sakenov@example.edu', '2021-09-01'),
  (1, 'Madina Karimova', 'madina.karimova@example.edu', '2020-08-20'),
  (2, 'Nurlan Bektas', 'nurlan.bektas@example.edu', '2019-01-15'),
  (3, 'Laura Kim', 'laura.kim@example.edu', '2022-02-10'),
  (4, 'Dmitry Orlov', 'dmitry.orlov@example.edu', '2021-03-11');

INSERT INTO students (department_id, full_name, email, enrollment_year, gpa, status) VALUES
  (1, 'Tamerlan Aitzhanov', 't.aitzhanov@example.edu', 2024, 3.15, 'active'),
  (1, 'Arman Nurpeisov', 'arman.nurpeisov@example.edu', 2024, 3.72, 'active'),
  (1, 'Aruzhan Serik', 'aruzhan.serik@example.edu', 2023, 3.50, 'active'),
  (1, 'Merei Darmen', 'merei.darmen@example.edu', 2023, 2.80, 'active'),
  (2, 'Ayaulym Kuanysh', 'ayaulym.kuanysh@example.edu', 2024, 3.92, 'active'),
  (2, 'Daniyar Askar', 'daniyar.askar@example.edu', 2022, 2.95, 'active'),
  (2, 'Aliya Smagul', 'aliya.smagul@example.edu', 2023, 3.25, 'active'),
  (3, 'Eldar Zhan', 'eldar.zhan@example.edu', 2024, 3.66, 'active'),
  (3, 'Dana Tulegen', 'dana.tulegen@example.edu', 2023, 3.10, 'active'),
  (3, 'Nikita Ivanov', 'nikita.ivanov@example.edu', 2022, 2.40, 'active'),
  (4, 'Alina Sarsen', 'alina.sarsen@example.edu', 2024, 3.47, 'active'),
  (4, 'Bekzat Omar', 'bekzat.omar@example.edu', 2022, 2.10, 'academic_leave');

INSERT INTO courses (department_id, instructor_id, course_code, course_name, credits) VALUES
  (1, 1, 'CS101', 'Programming Fundamentals', 5),
  (1, 2, 'CS205', 'Database Systems', 5),
  (1, 1, 'CS310', 'Backend Development', 6),
  (2, 3, 'IS210', 'Information Systems Analysis', 4),
  (3, 4, 'DA220', 'Data Analysis with SQL', 5),
  (3, 4, 'DA330', 'Business Intelligence', 4),
  (4, 5, 'CY201', 'Network Security', 5),
  (4, 5, 'CY315', 'Secure Backend Systems', 5);

INSERT INTO terms (academic_year, term_name, starts_on, ends_on, is_finalised) VALUES
  ('2025-2026', 'Fall', '2025-09-01', '2025-12-20', TRUE),
  ('2025-2026', 'Spring', '2026-01-20', '2026-05-25', FALSE);

INSERT INTO enrollments (student_id, course_id, term_id, grade, status) VALUES
  (1, 1, 1, 78, 'completed'),
  (1, 2, 1, 82, 'completed'),
  (1, 3, 2, 86, 'completed'),
  (1, 5, 2, 73, 'completed'),
  (2, 1, 1, 91, 'completed'),
  (2, 2, 1, 88, 'completed'),
  (2, 3, 2, 94, 'completed'),
  (2, 5, 2, 89, 'completed'),
  (3, 1, 1, 85, 'completed'),
  (3, 2, 1, 90, 'completed'),
  (3, 3, 2, 77, 'completed'),
  (3, 6, 2, 80, 'completed'),
  (4, 1, 1, 69, 'completed'),
  (4, 2, 1, 61, 'completed'),
  (4, 3, 2, 58, 'failed'),
  (5, 4, 1, 96, 'completed'),
  (5, 2, 1, 93, 'completed'),
  (5, 4, 2, 95, 'completed'),
  (5, 6, 2, 91, 'completed'),
  (6, 4, 1, 70, 'completed'),
  (6, 2, 1, 65, 'completed'),
  (6, 4, 2, 62, 'completed'),
  (7, 4, 1, 76, 'completed'),
  (7, 5, 2, 81, 'completed'),
  (8, 5, 1, 88, 'completed'),
  (8, 6, 1, 92, 'completed'),
  (8, 5, 2, 90, 'completed'),
  (8, 6, 2, 86, 'completed'),
  (9, 5, 1, 74, 'completed'),
  (9, 6, 2, 71, 'completed'),
  (10, 5, 1, 59, 'failed'),
  (10, 6, 2, 64, 'completed'),
  (11, 7, 1, 83, 'completed'),
  (11, 8, 2, 87, 'completed'),
  (12, 7, 1, 55, 'failed'),
  (12, 8, 2, 50, 'failed');

-- Raw import data for audit examples.
-- Some rows intentionally contain missing emails, unknown course codes and invalid grades.
INSERT INTO staging_enrollments_raw (student_email, course_code, term_label, grade_text) VALUES
  ('t.aitzhanov@example.edu', 'CS310', 'Spring 2026', '86'),
  ('unknown.student@example.edu', 'CS310', 'Spring 2026', '74'),
  ('arman.nurpeisov@example.edu', 'UNKNOWN101', 'Spring 2026', '80'),
  ('aruzhan.serik@example.edu', 'CS310', 'Spring 2026', 'not_available'),
  (NULL, 'DA220', 'Spring 2026', '88'),
  ('bekzat.omar@example.edu', 'CY315', 'Spring 2026', '150');
