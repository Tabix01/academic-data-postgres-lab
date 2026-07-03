-- ============================================================
-- Academic Data PostgreSQL Lab
-- 00_reset.sql
-- Purpose: drop and recreate the project schema.
-- ============================================================

DROP SCHEMA IF EXISTS academic_lab CASCADE;
CREATE SCHEMA academic_lab;
SET search_path TO academic_lab;
