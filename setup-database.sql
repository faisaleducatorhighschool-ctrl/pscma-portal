-- ============================================================
-- PSCMA Portal - Database Setup Script
-- Run this in your Hostinger PostgreSQL database
-- ============================================================

-- Session table (required by connect-pg-simple)
CREATE TABLE IF NOT EXISTS "session" (
  "sid" varchar NOT NULL COLLATE "default",
  "sess" json NOT NULL,
  "expire" timestamp(6) NOT NULL,
  CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE
);
CREATE INDEX IF NOT EXISTS "IDX_session_expire" ON "session" ("expire");

-- Users / Members
CREATE TABLE IF NOT EXISTS "users" (
  "id" serial PRIMARY KEY,
  "email" text NOT NULL UNIQUE,
  "password_hash" text NOT NULL,
  "role" text NOT NULL DEFAULT 'general_member',
  "status" text NOT NULL DEFAULT 'pending',
  "institution_name" text,
  "institution_type" text,
  "owner_name" text,
  "mobile" text,
  "address" text,
  "student_strength" integer,
  "annual_fee" numeric(10,2),
  "logo_url" text,
  "membership_start" timestamp,
  "membership_expiry" timestamp,
  "exec_start_date" timestamp,
  "exec_end_date" timestamp,
  "can_manage_events" boolean NOT NULL DEFAULT false,
  "password_reset_token" text,
  "password_reset_expiry" timestamp,
  "approved_at" timestamp,
  "created_at" timestamp NOT NULL DEFAULT now(),
  "updated_at" timestamp NOT NULL DEFAULT now()
);

-- Events
CREATE TABLE IF NOT EXISTS "events" (
  "id" serial PRIMARY KEY,
  "title" text NOT NULL,
  "title_urdu" text,
  "category" text NOT NULL,
  "description" text NOT NULL,
  "event_date" timestamp NOT NULL,
  "registration_deadline" timestamp NOT NULL,
  "venue" text NOT NULL,
  "status" text NOT NULL DEFAULT 'upcoming',
  "banner_url" text,
  "created_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now(),
  "updated_at" timestamp NOT NULL DEFAULT now()
);

-- Event Registrations
CREATE TABLE IF NOT EXISTS "event_registrations" (
  "id" serial PRIMARY KEY,
  "event_id" integer NOT NULL REFERENCES "events"("id"),
  "member_id" integer NOT NULL REFERENCES "users"("id"),
  "notes" text,
  "registered_at" timestamp NOT NULL DEFAULT now()
);

-- Meetings
CREATE TABLE IF NOT EXISTS "meetings" (
  "id" serial PRIMARY KEY,
  "title" text NOT NULL,
  "title_urdu" text,
  "meeting_date" timestamp NOT NULL,
  "venue" text NOT NULL,
  "agenda" text NOT NULL,
  "status" text NOT NULL DEFAULT 'scheduled',
  "minutes" text,
  "notice_url" text,
  "created_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now(),
  "updated_at" timestamp NOT NULL DEFAULT now()
);

-- Meeting Attendance
CREATE TABLE IF NOT EXISTS "meeting_attendance" (
  "id" serial PRIMARY KEY,
  "meeting_id" integer NOT NULL REFERENCES "meetings"("id"),
  "member_id" integer NOT NULL REFERENCES "users"("id"),
  "present" boolean NOT NULL DEFAULT false,
  "marked_at" timestamp NOT NULL DEFAULT now()
);

-- Elections
CREATE TABLE IF NOT EXISTS "elections" (
  "id" serial PRIMARY KEY,
  "title" text NOT NULL,
  "description" text,
  "start_date" timestamp NOT NULL,
  "end_date" timestamp NOT NULL,
  "status" text NOT NULL DEFAULT 'upcoming',
  "created_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now(),
  "updated_at" timestamp NOT NULL DEFAULT now()
);

-- Candidates
CREATE TABLE IF NOT EXISTS "candidates" (
  "id" serial PRIMARY KEY,
  "election_id" integer NOT NULL REFERENCES "elections"("id"),
  "member_id" integer NOT NULL REFERENCES "users"("id"),
  "position" text NOT NULL,
  "manifesto" text,
  "status" text NOT NULL DEFAULT 'registered',
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Votes
CREATE TABLE IF NOT EXISTS "votes" (
  "id" serial PRIMARY KEY,
  "election_id" integer NOT NULL REFERENCES "elections"("id"),
  "candidate_id" integer NOT NULL REFERENCES "candidates"("id"),
  "voter_id" integer NOT NULL REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Fund Records
CREATE TABLE IF NOT EXISTS "fund_records" (
  "id" serial PRIMARY KEY,
  "type" text NOT NULL,
  "amount" numeric(12,2) NOT NULL,
  "category" text NOT NULL,
  "description" text NOT NULL,
  "date" timestamp NOT NULL,
  "member_id" integer REFERENCES "users"("id"),
  "receipt_url" text,
  "created_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Dues
CREATE TABLE IF NOT EXISTS "dues" (
  "id" serial PRIMARY KEY,
  "member_id" integer NOT NULL REFERENCES "users"("id"),
  "amount" numeric(10,2) NOT NULL,
  "due_date" timestamp NOT NULL,
  "status" text NOT NULL DEFAULT 'pending',
  "year" integer NOT NULL,
  "paid_at" timestamp,
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Documents
CREATE TABLE IF NOT EXISTS "documents" (
  "id" serial PRIMARY KEY,
  "title" text NOT NULL,
  "title_urdu" text,
  "category" text NOT NULL,
  "description" text,
  "file_url" text NOT NULL,
  "file_size" integer,
  "download_count" integer NOT NULL DEFAULT 0,
  "uploaded_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Notifications
CREATE TABLE IF NOT EXISTS "notifications" (
  "id" serial PRIMARY KEY,
  "user_id" integer REFERENCES "users"("id"),
  "title" text NOT NULL,
  "message" text NOT NULL,
  "category" text NOT NULL,
  "is_read" boolean NOT NULL DEFAULT false,
  "link" text,
  "target_role" text,
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Gallery
CREATE TABLE IF NOT EXISTS "gallery_items" (
  "id" serial PRIMARY KEY,
  "title" text NOT NULL,
  "type" text NOT NULL,
  "url" text NOT NULL,
  "thumbnail_url" text,
  "event_id" integer REFERENCES "events"("id"),
  "uploaded_by" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- Activity Log
CREATE TABLE IF NOT EXISTS "activity_log" (
  "id" serial PRIMARY KEY,
  "type" text NOT NULL,
  "description" text NOT NULL,
  "actor_id" integer REFERENCES "users"("id"),
  "created_at" timestamp NOT NULL DEFAULT now()
);

-- System Settings
CREATE TABLE IF NOT EXISTS "system_settings" (
  "id" serial PRIMARY KEY,
  "org_name" text NOT NULL DEFAULT 'PSCMA — Private Schools & Colleges Management Association',
  "contact_email" text NOT NULL DEFAULT 'info@pscma.org.pk',
  "contact_phone" text NOT NULL DEFAULT '+92-XXX-XXXXXXX',
  "contact_address" text NOT NULL DEFAULT 'Khanpur, KPK, Pakistan',
  "website_url" text NOT NULL DEFAULT 'https://pscma.org.pk',
  "updated_at" timestamp NOT NULL DEFAULT now()
);

-- ============================================================
-- SEED DATA - Demo Accounts (password: Password123!)
-- ============================================================

INSERT INTO "users" (email, password_hash, role, status, institution_name, institution_type, owner_name, mobile, address, student_strength, annual_fee, membership_start, membership_expiry, approved_at, created_at, updated_at)
VALUES
  (
    'admin@pscma.org',
    '$2b$12$HRy2mx0BVcsKXd2QfBS2/uz4Oglq0NZzvIAQnWgIbspsoLnCTljTm',
    'super_admin', 'active',
    'PSCMA Head Office', 'Management',
    'Admin User', '+92-300-0000000',
    'Khanpur, KPK, Pakistan',
    0, '0.00',
    now(), now() + interval '2 years',
    now(), now(), now()
  ),
  (
    'executive@pscma.org',
    '$2b$12$HRy2mx0BVcsKXd2QfBS2/uz4Oglq0NZzvIAQnWgIbspsoLnCTljTm',
    'executive_body', 'active',
    'Beacon House School System', 'Private School',
    'Executive Member', '+92-300-1111111',
    'Khanpur, KPK, Pakistan',
    600, '10000.00',
    now(), now() + interval '2 years',
    now(), now(), now()
  ),
  (
    'member@pscma.org',
    '$2b$12$HRy2mx0BVcsKXd2QfBS2/uz4Oglq0NZzvIAQnWgIbspsoLnCTljTm',
    'general_member', 'active',
    'Al-Huda Academy', 'Private School',
    'General Member', '+92-300-2222222',
    'Khanpur, KPK, Pakistan',
    150, '3000.00',
    now(), now() + interval '2 years',
    now(), now(), now()
  ),
  (
    'member23@pscma.org',
    '$2b$12$HRy2mx0BVcsKXd2QfBS2/uz4Oglq0NZzvIAQnWgIbspsoLnCTljTm',
    'general_member', 'pending',
    'Sunrise Academy', 'Private School',
    'Pending Member', '+92-300-3333333',
    'Khanpur, KPK, Pakistan',
    90, '3000.00',
    NULL, NULL,
    NULL, now(), now()
  )
ON CONFLICT (email) DO NOTHING;

-- Default system settings
INSERT INTO "system_settings" (org_name, contact_email, contact_phone, contact_address, website_url)
VALUES (
  'PSCMA — Private Schools & Colleges Management Association',
  'info@pscma.org.pk',
  '+92-XXX-XXXXXXX',
  'Khanpur, KPK, Pakistan',
  'https://pscma.org.pk'
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Done! All tables created and demo data seeded.
-- Login with: admin@pscma.org / Password123!
-- ============================================================
