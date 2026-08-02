-- ============================================================
-- SA Golf — SPEND TRACKER table
-- Run in Supabase SQL Editor. Safe to re-run.
-- ============================================================
create table if not exists public.spend (
  id          text primary key,
  who         text not null,          -- 'gav' or 'phil'
  description text,
  amount      numeric not null,       -- rand
  created_at  timestamptz default now()
);

alter table public.spend enable row level security;
drop policy if exists "spend all" on public.spend;
create policy "spend all" on public.spend for all using (true) with check (true);

alter publication supabase_realtime add table public.spend;
