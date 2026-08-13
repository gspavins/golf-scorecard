-- Planned courses — shared between Gav & Phil.
-- Run once in the Supabase SQL Editor.
create table if not exists public.planned (
  course_id text primary key,
  planned boolean default true,
  updated_at timestamptz default now()
);
alter table public.planned enable row level security;
drop policy if exists "planned read"  on public.planned;
drop policy if exists "planned write" on public.planned;
create policy "planned read"  on public.planned for select using (true);
create policy "planned write" on public.planned for all using (true) with check (true);
do $$ begin
  alter publication supabase_realtime add table public.planned;
exception when duplicate_object then null; end $$;
