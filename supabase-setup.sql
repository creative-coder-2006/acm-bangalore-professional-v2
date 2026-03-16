-- ============================================================
-- ACM Bangalore Professional Chapter — Supabase Setup
-- Run this entire file in the Supabase SQL Editor
-- Project: rfvbyguseudzomeoozmy
-- ============================================================

-- ADMINS TABLE
CREATE TABLE IF NOT EXISTS admins (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username    TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  created_by  TEXT
);

-- EVENTS TABLE
CREATE TABLE IF NOT EXISTS events (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type         TEXT NOT NULL CHECK (type IN ('upcoming','past')),
  title        TEXT NOT NULL,
  description  TEXT    DEFAULT '',
  article_text TEXT    DEFAULT '',
  event_date   DATE,
  start_time   TEXT    DEFAULT '',
  end_time     TEXT    DEFAULT '',
  location     TEXT    DEFAULT '',
  mode         TEXT    DEFAULT 'In-person',
  speaker_name TEXT    DEFAULT '',
  speaker_org  TEXT    DEFAULT '',
  host_name    TEXT    DEFAULT '',
  host_org     TEXT    DEFAULT '',
  display_order INT   DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- EVENT PHOTOS TABLE
CREATE TABLE IF NOT EXISTS event_photos (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id     UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  url          TEXT NOT NULL,
  storage_path TEXT NOT NULL DEFAULT '',
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- GALLERY PHOTOS TABLE
CREATE TABLE IF NOT EXISTS gallery_photos (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  url          TEXT NOT NULL,
  storage_path TEXT NOT NULL DEFAULT '',
  caption      TEXT DEFAULT '',
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- FORM SUBMISSIONS TABLE
CREATE TABLE IF NOT EXISTS form_submissions (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type         TEXT DEFAULT 'membership' CHECK (type IN ('membership','contact')),
  first_name   TEXT,
  last_name    TEXT,
  email        TEXT NOT NULL,
  affiliation  TEXT,
  role         TEXT,
  interests    TEXT,
  acm_number   TEXT,
  subject      TEXT,
  message      TEXT,
  submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DISABLE ROW LEVEL SECURITY (static site uses anon key)
-- ============================================================
ALTER TABLE admins          DISABLE ROW LEVEL SECURITY;
ALTER TABLE events          DISABLE ROW LEVEL SECURITY;
ALTER TABLE event_photos    DISABLE ROW LEVEL SECURITY;
ALTER TABLE gallery_photos  DISABLE ROW LEVEL SECURITY;
ALTER TABLE form_submissions DISABLE ROW LEVEL SECURITY;

-- Grant full access to anon role
GRANT ALL ON admins          TO anon;
GRANT ALL ON events          TO anon;
GRANT ALL ON event_photos    TO anon;
GRANT ALL ON gallery_photos  TO anon;
GRANT ALL ON form_submissions TO anon;

-- ============================================================
-- SEED: Initial upcoming event (Fireside Chat)
-- ============================================================
INSERT INTO events (type, title, description, event_date, start_time, end_time, location, mode, speaker_name, speaker_org, host_name, host_org)
VALUES (
  'upcoming',
  'Transforming Solar PV Manufacturing with Industrial AI',
  'An insightful fireside chat exploring how Artificial Intelligence is revolutionizing solar PV manufacturing processes at industrial scale — with implications for India''s clean energy future.',
  '2026-03-28',
  '11:00 AM',
  '12:00 PM',
  'Manipal Institute of Technology (MIT), MAHE Bangalore',
  'In-person only',
  'Kedar Kulkarni',
  'Head, AI for New Energy — Reliance Industries Ltd.',
  'Sameep Mehta',
  'Distinguished Engineer — IBM Research India'
);

-- ============================================================
-- STORAGE: After running this SQL, do the following manually:
--
-- 1. Go to Storage in your Supabase dashboard
-- 2. Click "New bucket"
-- 3. Name it exactly:  acm-media
-- 4. Check "Public bucket" → Save
--
-- That's it! The admin dashboard handles all uploads.
-- ============================================================
