-- SA Golf Scorecard — Supabase schema
-- Paste this whole file into: Supabase dashboard → SQL Editor → New query → Run

create table if not exists public.scores (
  game_id    text    not null,
  player     text    not null,          -- 'gav', 'phil', or '__meta'
  hole       int     not null,          -- 1..18, or 0 for the meta row
  strokes    int,                       -- gross strokes on the hole
  course     text,                      -- only used on the __meta row
  game_date  date,                      -- round date (on the __meta row)
  hcap_gav   int,
  hcap_phil  int,
  updated_at timestamptz default now(),
  primary key (game_id, player, hole)
);

-- If the table was created by an earlier version, make sure every column exists.
-- (Safe to run repeatedly — only adds what's missing.)
alter table public.scores add column if not exists strokes    int;
alter table public.scores add column if not exists course     text;
alter table public.scores add column if not exists game_date  date;
alter table public.scores add column if not exists hcap_gav   int;
alter table public.scores add column if not exists hcap_phil  int;
alter table public.scores add column if not exists updated_at timestamptz default now();
alter table public.scores add column if not exists final      boolean default false;

-- Simple open policies for a private 2-player app (anon key can read/write).
-- Tighten later with auth if you want it locked down.
alter table public.scores enable row level security;

drop policy if exists "anon read"   on public.scores;
drop policy if exists "anon insert" on public.scores;
drop policy if exists "anon update" on public.scores;
drop policy if exists "anon delete" on public.scores;

create policy "anon read"   on public.scores for select using (true);
create policy "anon insert" on public.scores for insert with check (true);
create policy "anon update" on public.scores for update using (true);
create policy "anon delete" on public.scores for delete using (true);

-- Enable realtime so both phones update live
do $$
begin
  alter publication supabase_realtime add table public.scores;
exception when duplicate_object then null;
end $$;
