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

---

## Versioning & auto-update

The app shows its version at the bottom (e.g. `v1.0.0`) and updates itself
automatically:

- A service worker (`sw.js`) caches the app for offline use and checks for a
  newer version every time it loads (and once a minute while open).
- When you deploy a change, players get it on their next open — no manual
  refresh or cache-clearing needed. The footer briefly shows "updating…" and
  the page reloads once with the new code.

**When you make changes, bump the version in _two_ places so clients update:**

1. In `index.html`: `const APP_VERSION = "1.0.0";`
2. In `sw.js`: `const CACHE_VERSION = "1.0.0";`

Use the same number in both (e.g. `1.0.1`, `1.1.0`). That new value invalidates
the old cache and forces every device to pull the fresh files.

> Note: the service worker only runs over **https** (GitHub Pages is https) or
> on `localhost`. Opening the file directly from disk won't register it, but the
> app still works — it just won't auto-update until it's hosted.

---

## Adding courses (via the database)

Courses live in two Supabase tables so you can add new ones **without editing
the app**:

- `courses` — one row per course (`id`, `name`, `location`, `tee`, `par`, `active`)
- `course_holes` — 18 rows per course (`course_id`, `hole`, `distance`, `par`, `stroke_index`)

**One-time setup:** run `courses.sql` (SQL Editor → paste → Run). It creates the
tables, sets read access + realtime, and seeds the six built-in courses.

**To add a course later**, run something like this (SQL Editor), or use the
Supabase Table Editor to add the rows by hand:

```sql
insert into public.courses (id, name, location, tee, par)
values ('mynewcourse', 'My New Course', 'Town, Prov', 'White', 72);

insert into public.course_holes (course_id, hole, distance, par, stroke_index) values
  ('mynewcourse', 1, 370, 4, 5),
  ('mynewcourse', 2, 150, 3, 15),
  -- ... holes 3–17 ...
  ('mynewcourse', 18, 410, 4, 8);
```

Rules the app expects:
- Exactly **18 holes** per course (courses with fewer are ignored).
- `stroke_index` values **1–18, each used once**.
- `distance` is in **metres** (convert yards × 0.9144 if needed).
- Set a course's `active` to `false` to hide it without deleting.

The app reads the catalogue from the database on load (and falls back to the
six built-in courses when offline or before `courses.sql` has been run). New
courses appear next time the app is opened.

---

## v2 — landing page, progress chart, finalise, spend tracker

The app now opens on a **landing page** (`index.html`) with:
- **New scorecard / Resume round / Past rounds** → the scorecard (`scorecard.html`)
- **Spend tracker** → `spend.html`

New in the scorecard:
- **Progress tab** — swipe right (or tap Progress) for a cumulative chart; toggle
  Strokes / To Par / Points.
- **Mark final** — flags a finished round (still editable). Final games show a
  "Final" tag in the games list and no longer count as the "live" round.

**Extra database setup for v2** (run once each in the SQL Editor):
1. `spend.sql` — creates the spend tracker table.
2. The `final` column was added to `supabase.sql`; if your `scores` table already
   exists, just run this line:
   ```sql
   alter table public.scores add column if not exists final boolean default false;
   ```

Config note: Supabase keys + version now live in **`config.js`**, shared by all
three pages — set them once there (the old inline block is gone).

---

## Full SA course catalogue (v2.11)

`courses.sql` now contains the full set of ~324 South African courses (par,
stroke index, and distances per hole) sourced from the handicaps dataset.

To load them, run `courses.sql` once in the Supabase SQL Editor. It creates/updates
the `courses` and `course_holes` tables and upserts every course, so it's safe to
re-run. Course ids are `c<ref>` (e.g. Kloof = `c380`).

In the app, the course field is now a **searchable box** — start typing a course
name and pick from the list. The app loads the catalogue from Supabase on startup
and still falls back to the built-in courses when offline.

## Planned / Played courses (v2.19)
Run `planned.sql` once in Supabase to create the shared "planned" table.
On the Courses page, tick "Planned" on any course to flag it (syncs between
players). A course you've recorded a round on shows "Played" automatically.
Map markers: green = played, red = planned, blue = neither. The status filter
lets you show only played or only planned courses.
