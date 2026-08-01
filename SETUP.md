# SA Golf Scorecard — Setup

A single-file scorecard for match-play + Stableford between Gav and Phil, with a
course dropdown (Kloof, Durban CC, Royal Johannesburg East, King David Mowbray)
and optional live sync via Supabase so both phones see the same card.

The file works immediately with **no setup** — it just saves to the device it's
opened on. Follow the steps below only if you want live shared scoring.

---

## 1. Create the Supabase table

In your Supabase project: **SQL Editor → New query**, paste this, and run it.

```sql
create table if not exists public.scores (
  game_id    text    not null,
  player     text    not null,          -- 'gav', 'phil', or '__meta'
  hole       int     not null,          -- 1..18, or 0 for the meta row
  strokes    int,                       -- gross strokes on the hole
  course     text,                       -- only used on the __meta row
  game_date  date,                       -- round date (on the __meta row)
  hcap_gav   int,
  hcap_phil  int,
  updated_at timestamptz default now(),
  primary key (game_id, player, hole)
);
alter table public.scores add column if not exists game_date date;

-- allow the anon key to read/write (simple setup for a private 2-player app)
alter table public.scores enable row level security;

create policy "anon read"   on public.scores for select using (true);
create policy "anon insert" on public.scores for insert with check (true);
create policy "anon update" on public.scores for update using (true);
create policy "anon delete" on public.scores for delete using (true);

-- enable realtime
alter publication supabase_realtime add table public.scores;
```

> These policies are wide open (anyone with the anon key + a game id can write).
> That's fine for a private game between two people. If you want it locked down,
> add auth later and tighten the policies.

## 2. Paste your keys into the HTML

Open `index.html`, find the CONFIG block near the top of the script:

```js
const SUPABASE_URL = "";       // https://xxxx.supabase.co
const SUPABASE_ANON_KEY = "";  // eyJhbGci...
```

Fill both in from **Supabase → Project Settings → API**
(`Project URL` and the `anon` `public` key). Save.

The status strip under the course picker turns **green** when live sync is on.

## 3. Host on GitHub Pages

1. Create a repo (e.g. `golf-scorecard`) and upload all the files in this
   folder (`index.html`, `golf-icon.png`, etc.), keeping them together.
2. **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   pick `main` / `root`, save.
3. After a minute your site is live at
   `https://<your-username>.github.io/golf-scorecard/`.

## 4. Play

- Open the site. A game id is created and shown at the bottom, and added to the
  URL as `?game=xxxxxx`.
- **Share that URL** with the other player — same game id = same shared card.
- Tap **New game** to start a fresh card with a new id.
- Pick the course from the dropdown; the whole card (par, stroke index, tee
  distances) swaps to match. The choice syncs to both phones.
- Set the **date** with the date picker (defaults to today).
- Set each handicap top-right — stroke dots and Stableford points update live.
- Tap **Games** to see previous rounds. Pick one to open and edit its scores,
  or tap **Back to round in progress** / **Return to live round** to come back
  to the current game. A gold banner shows when you're viewing a past round.

## Notes on course data

Par, stroke index and per-hole distances were taken from published scorecards
and converted to metres. Tee used per course: Kloof = White, Durban CC = Yellow,
Royal Johannesburg (East) = Blue, Mowbray = Blue. Only courses with a full,
verifiable hole-by-hole scorecard are included. To add another, extend the
`COURSES` object in the script with the same `{n,d,par,si}` shape.
