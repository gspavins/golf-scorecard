-- Add handicap-index columns to the scores table (for the __meta row).
-- The app stores each player's Handicap Index here, and computes the Course
-- Handicap from the course's Slope/CR at scoring time.
-- Safe to re-run.
alter table public.scores add column if not exists hindex_gav numeric;
alter table public.scores add column if not exists hindex_phil numeric;
