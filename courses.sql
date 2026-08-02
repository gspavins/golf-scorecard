-- ============================================================
-- SA Golf Scorecard — COURSE catalogue schema
-- Run this in: Supabase dashboard -> SQL Editor -> New query -> Run
-- (Run this once. It creates the course tables, seeds the six
--  built-in courses, and sets read access + realtime.)
-- ============================================================

-- One row per course
create table if not exists public.courses (
  id        text primary key,          -- short slug, e.g. 'kloof'
  name      text not null,             -- 'Kloof Country Club'
  location  text,                      -- 'Kloof, KZN'
  tee       text,                      -- tee colour the distances refer to
  par       int  not null,
  active    boolean default true,      -- set false to hide without deleting
  created_at timestamptz default now()
);

-- One row per hole of each course
create table if not exists public.course_holes (
  course_id    text not null references public.courses(id) on delete cascade,
  hole         int  not null,          -- 1..18
  distance     int,                    -- metres (from the course's tee)
  par          int  not null,
  stroke_index int  not null,          -- 1..18
  primary key (course_id, hole)
);

-- ---- Access: courses are public reference data (read for everyone) ----
alter table public.courses      enable row level security;
alter table public.course_holes enable row level security;

drop policy if exists "courses read"  on public.courses;
drop policy if exists "holes read"     on public.course_holes;
drop policy if exists "courses write"  on public.courses;
drop policy if exists "holes write"    on public.course_holes;

-- everyone can read
create policy "courses read" on public.courses      for select using (true);
create policy "holes read"    on public.course_holes for select using (true);

-- allow the anon key to add/edit courses too (simple setup).
-- If you'd rather add courses only from the Supabase table editor,
-- delete these two policies.
create policy "courses write" on public.courses      for all using (true) with check (true);
create policy "holes write"    on public.course_holes for all using (true) with check (true);

-- realtime so a newly added course appears without a redeploy
alter publication supabase_realtime add table public.courses;
alter publication supabase_realtime add table public.course_holes;

-- Course data — seed the built-in courses
-- Safe to re-run: upserts on primary keys

insert into public.courses (id, name, location, tee, par) values
  ('kloof', 'Kloof Country Club', 'Kloof, KZN', 'Yellow', 70)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('kloof', 1, 370, 4, 4),
  ('kloof', 2, 148, 3, 14),
  ('kloof', 3, 328, 4, 2),
  ('kloof', 4, 166, 3, 8),
  ('kloof', 5, 475, 5, 10),
  ('kloof', 6, 173, 3, 12),
  ('kloof', 7, 428, 5, 16),
  ('kloof', 8, 292, 4, 18),
  ('kloof', 9, 356, 4, 6),
  ('kloof', 10, 441, 4, 1),
  ('kloof', 11, 155, 3, 15),
  ('kloof', 12, 325, 4, 17),
  ('kloof', 13, 329, 4, 13),
  ('kloof', 14, 412, 4, 5),
  ('kloof', 15, 390, 4, 3),
  ('kloof', 16, 364, 4, 7),
  ('kloof', 17, 477, 5, 11),
  ('kloof', 18, 175, 3, 9)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('durban', 'Durban Country Club', 'Durban, KZN', 'Yellow', 72)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('durban', 1, 354, 4, 5),
  ('durban', 2, 172, 3, 13),
  ('durban', 3, 468, 5, 9),
  ('durban', 4, 165, 3, 17),
  ('durban', 5, 420, 4, 1),
  ('durban', 6, 322, 4, 11),
  ('durban', 7, 340, 4, 7),
  ('durban', 8, 458, 5, 15),
  ('durban', 9, 397, 4, 3),
  ('durban', 10, 512, 5, 8),
  ('durban', 11, 439, 4, 2),
  ('durban', 12, 143, 3, 12),
  ('durban', 13, 310, 4, 14),
  ('durban', 14, 482, 5, 10),
  ('durban', 15, 177, 3, 16),
  ('durban', 16, 381, 4, 4),
  ('durban', 17, 367, 4, 6),
  ('durban', 18, 250, 4, 18)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('rjhb', 'Royal Johannesburg & Kensington (East)', 'Johannesburg', 'Blue', 72)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('rjhb', 1, 432, 5, 18),
  ('rjhb', 2, 211, 3, 6),
  ('rjhb', 3, 420, 4, 4),
  ('rjhb', 4, 398, 4, 2),
  ('rjhb', 5, 148, 3, 12),
  ('rjhb', 6, 485, 5, 14),
  ('rjhb', 7, 384, 4, 10),
  ('rjhb', 8, 463, 5, 16),
  ('rjhb', 9, 356, 4, 8),
  ('rjhb', 10, 433, 4, 3),
  ('rjhb', 11, 418, 4, 1),
  ('rjhb', 12, 166, 3, 9),
  ('rjhb', 13, 351, 4, 7),
  ('rjhb', 14, 378, 4, 11),
  ('rjhb', 15, 402, 4, 5),
  ('rjhb', 16, 174, 3, 13),
  ('rjhb', 17, 324, 4, 15),
  ('rjhb', 18, 461, 5, 17)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('mowbray', 'King David Mowbray', 'Cape Town', 'Blue', 71)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('mowbray', 1, 371, 4, 3),
  ('mowbray', 2, 318, 4, 15),
  ('mowbray', 3, 490, 5, 6),
  ('mowbray', 4, 134, 3, 18),
  ('mowbray', 5, 379, 4, 2),
  ('mowbray', 6, 315, 4, 11),
  ('mowbray', 7, 413, 4, 1),
  ('mowbray', 8, 165, 3, 10),
  ('mowbray', 9, 315, 4, 17),
  ('mowbray', 10, 174, 3, 8),
  ('mowbray', 11, 385, 4, 4),
  ('mowbray', 12, 500, 5, 5),
  ('mowbray', 13, 369, 4, 9),
  ('mowbray', 14, 342, 4, 12),
  ('mowbray', 15, 380, 4, 7),
  ('mowbray', 16, 326, 4, 16),
  ('mowbray', 17, 351, 4, 13),
  ('mowbray', 18, 279, 4, 14)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('zimbali', 'Zimbali Country Club', 'Ballito, KZN', 'White', 72)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('zimbali', 1, 331, 4, 6),
  ('zimbali', 2, 278, 4, 18),
  ('zimbali', 3, 418, 5, 14),
  ('zimbali', 4, 364, 4, 2),
  ('zimbali', 5, 153, 3, 16),
  ('zimbali', 6, 408, 5, 8),
  ('zimbali', 7, 306, 4, 4),
  ('zimbali', 8, 319, 4, 10),
  ('zimbali', 9, 176, 3, 12),
  ('zimbali', 10, 319, 4, 7),
  ('zimbali', 11, 153, 3, 13),
  ('zimbali', 12, 457, 5, 5),
  ('zimbali', 13, 328, 4, 9),
  ('zimbali', 14, 123, 3, 17),
  ('zimbali', 15, 326, 4, 1),
  ('zimbali', 16, 315, 4, 11),
  ('zimbali', 17, 380, 5, 15),
  ('zimbali', 18, 379, 4, 3)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('selborne', 'Selborne Golf Club', 'Pennington, KZN', 'White', 72)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('selborne', 1, 364, 5, 9),
  ('selborne', 2, 242, 4, 13),
  ('selborne', 3, 436, 5, 5),
  ('selborne', 4, 123, 3, 15),
  ('selborne', 5, 314, 4, 1),
  ('selborne', 6, 135, 3, 11),
  ('selborne', 7, 308, 4, 7),
  ('selborne', 8, 207, 4, 17),
  ('selborne', 9, 347, 4, 3),
  ('selborne', 10, 437, 5, 10),
  ('selborne', 11, 115, 3, 18),
  ('selborne', 12, 436, 5, 2),
  ('selborne', 13, 320, 4, 4),
  ('selborne', 14, 286, 4, 12),
  ('selborne', 15, 135, 3, 14),
  ('selborne', 16, 328, 4, 8),
  ('selborne', 17, 302, 4, 6),
  ('selborne', 18, 272, 4, 16)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('victoria', 'Victoria Country Club', 'Pietermaritzburg, KZN', 'White', 71)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('victoria', 1, 304, 4, 16),
  ('victoria', 2, 370, 4, 6),
  ('victoria', 3, 478, 5, 10),
  ('victoria', 4, 404, 4, 2),
  ('victoria', 5, 372, 4, 4),
  ('victoria', 6, 150, 3, 12),
  ('victoria', 7, 272, 4, 14),
  ('victoria', 8, 134, 3, 18),
  ('victoria', 9, 354, 4, 8),
  ('victoria', 10, 374, 4, 5),
  ('victoria', 11, 519, 5, 7),
  ('victoria', 12, 420, 4, 1),
  ('victoria', 13, 124, 3, 15),
  ('victoria', 14, 402, 4, 3),
  ('victoria', 15, 330, 4, 9),
  ('victoria', 16, 319, 4, 13),
  ('victoria', 17, 144, 3, 17),
  ('victoria', 18, 460, 5, 11)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;

insert into public.courses (id, name, location, tee, par) values
  ('cotswold', 'Cotswold Downs', 'Hillcrest, KZN', 'Black', 72)
  on conflict (id) do update set name=excluded.name, location=excluded.location, tee=excluded.tee, par=excluded.par;
insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('cotswold', 1, 496, 5, 6),
  ('cotswold', 2, 382, 4, 8),
  ('cotswold', 3, 349, 4, 12),
  ('cotswold', 4, 366, 4, 4),
  ('cotswold', 5, 157, 3, 18),
  ('cotswold', 6, 289, 4, 14),
  ('cotswold', 7, 154, 3, 16),
  ('cotswold', 8, 371, 4, 2),
  ('cotswold', 9, 472, 5, 10),
  ('cotswold', 10, 310, 4, 7),
  ('cotswold', 11, 312, 4, 13),
  ('cotswold', 12, 383, 4, 3),
  ('cotswold', 13, 480, 5, 9),
  ('cotswold', 14, 182, 3, 17),
  ('cotswold', 15, 359, 4, 11),
  ('cotswold', 16, 151, 3, 15),
  ('cotswold', 17, 376, 4, 1),
  ('cotswold', 18, 507, 5, 5)
  on conflict (course_id, hole) do update set distance=excluded.distance, par=excluded.par, stroke_index=excluded.stroke_index;
