-- Kodiak Supabase PostgreSQL schema snapshot v1.0.0
--
-- This snapshot is safe to run more than once. The server-only `id` column is
-- an identity/indexing key. Sync and relationships use `uuid` and `*_uuid`.
-- Exact coordinates are intentionally not stored; map coordinates are already
-- approximate and fuzzed before they enter this schema.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.app_setting (
  id          bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid        uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  setting_key text NOT NULL UNIQUE,
  value_json  jsonb NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  archived_at timestamptz,
  CONSTRAINT app_setting_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.account (
  id          bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid        uuid NOT NULL UNIQUE,
  role        text NOT NULL DEFAULT 'contributor',
  status      text NOT NULL DEFAULT 'active',
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  archived_at timestamptz,
  CONSTRAINT account_pkey PRIMARY KEY (id),
  CONSTRAINT account_role_check CHECK (
    role IN ('system_administrator', 'administrator', 'moderator', 'contributor', 'guest')
  ),
  CONSTRAINT account_status_check CHECK (status IN ('active', 'archived'))
);

CREATE TABLE IF NOT EXISTS public.vacancy_report (
  id                    bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid                  uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  created_by_uuid       uuid,
  housing_type          text NOT NULL,
  gender_restriction    text,
  description           text,
  location_latitude     numeric(9, 6) NOT NULL,
  location_longitude    numeric(9, 6) NOT NULL,
  location_fuzz_meters  integer NOT NULL,
  observed_at           timestamptz NOT NULL,
  last_confirmed_at     timestamptz,
  active_until          timestamptz NOT NULL,
  hard_expires_at       timestamptz NOT NULL,
  availability_state    text NOT NULL DEFAULT 'available',
  lifecycle_status      text NOT NULL DEFAULT 'active',
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  archived_at           timestamptz,
  CONSTRAINT vacancy_report_pkey PRIMARY KEY (id),
  CONSTRAINT vacancy_report_housing_type_check CHECK (
    housing_type IN ('bedspace', 'solo_room', 'shared_room')
  ),
  CONSTRAINT vacancy_report_description_length_check CHECK (
    description IS NULL OR char_length(description) <= 500
  ),
  CONSTRAINT vacancy_report_latitude_check CHECK (
    location_latitude BETWEEN -90 AND 90
  ),
  CONSTRAINT vacancy_report_longitude_check CHECK (
    location_longitude BETWEEN -180 AND 180
  ),
  CONSTRAINT vacancy_report_fuzz_check CHECK (
    location_fuzz_meters BETWEEN 100 AND 5000
  ),
  CONSTRAINT vacancy_report_availability_check CHECK (
    availability_state IN ('available', 'unavailable')
  ),
  CONSTRAINT vacancy_report_lifecycle_check CHECK (
    lifecycle_status IN ('active', 'inactive', 'removed')
  ),
  CONSTRAINT vacancy_report_expiry_check CHECK (active_until <= hard_expires_at)
);

CREATE TABLE IF NOT EXISTS public.vacancy_feedback (
  id              bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid            uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  report_uuid     uuid NOT NULL,
  feedback_type   text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  archived_at     timestamptz,
  CONSTRAINT vacancy_feedback_pkey PRIMARY KEY (id),
  CONSTRAINT vacancy_feedback_type_check CHECK (
    feedback_type IN ('confirm_available', 'flag_unavailable')
  )
);

CREATE TABLE IF NOT EXISTS public.moderation_report (
  id                 bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  uuid               uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  report_uuid        uuid NOT NULL,
  submitted_by_uuid  uuid,
  category           text NOT NULL,
  details            text,
  queue_status       text NOT NULL DEFAULT 'open',
  resolved_by_uuid   uuid,
  resolved_at        timestamptz,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  archived_at        timestamptz,
  CONSTRAINT moderation_report_pkey PRIMARY KEY (id),
  CONSTRAINT moderation_report_category_check CHECK (
    category IN ('spam', 'wrong_location', 'misleading', 'no_longer_available')
  ),
  CONSTRAINT moderation_report_details_length_check CHECK (
    details IS NULL OR char_length(details) <= 500
  ),
  CONSTRAINT moderation_report_status_check CHECK (
    queue_status IN ('open', 'in_review', 'resolved', 'dismissed')
  )
);

CREATE INDEX IF NOT EXISTS idx_vacancy_report_uuid ON public.vacancy_report (uuid);
CREATE INDEX IF NOT EXISTS idx_vacancy_report_map ON public.vacancy_report
  (housing_type, availability_state, lifecycle_status, active_until)
  WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_vacancy_report_location ON public.vacancy_report
  (location_latitude, location_longitude)
  WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_vacancy_report_created_by
  ON public.vacancy_report (created_by_uuid);
CREATE INDEX IF NOT EXISTS idx_vacancy_feedback_report
  ON public.vacancy_feedback (report_uuid, created_at);
CREATE INDEX IF NOT EXISTS idx_moderation_report_queue
  ON public.moderation_report (queue_status, created_at)
  WHERE archived_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_moderation_report_report
  ON public.moderation_report (report_uuid);

INSERT INTO public.app_setting (setting_key, value_json)
VALUES
  ('vacancy_active_period_days', '{"days": 14}'::jsonb),
  ('vacancy_confirmation_reset_days', '{"days": 14}'::jsonb),
  ('vacancy_creation_hard_cap_days', '{"days": 30}'::jsonb),
  ('vacancy_location_fuzz_meters', '{"meters": 250}'::jsonb)
ON CONFLICT (setting_key) DO NOTHING;

CREATE OR REPLACE FUNCTION public.kodiak_setting_days(
  p_setting_key text,
  p_fallback integer
)
RETURNS integer
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE((value_json ->> 'days')::integer, p_fallback)
  FROM public.app_setting
  WHERE setting_key = p_setting_key
    AND archived_at IS NULL
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.kodiak_setting_meters(
  p_setting_key text,
  p_fallback integer
)
RETURNS integer
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE((value_json ->> 'meters')::integer, p_fallback)
  FROM public.app_setting
  WHERE setting_key = p_setting_key
    AND archived_at IS NULL
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.kodiak_touch_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.kodiak_prepare_vacancy_report()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  active_days integer;
  hard_cap_days integer;
BEGIN
  NEW.created_at := COALESCE(NEW.created_at, now());
  active_days := public.kodiak_setting_days('vacancy_active_period_days', 14);
  hard_cap_days := public.kodiak_setting_days('vacancy_creation_hard_cap_days', 30);
  NEW.hard_expires_at := COALESCE(
    NEW.hard_expires_at,
    NEW.created_at + make_interval(days => hard_cap_days)
  );
  NEW.active_until := LEAST(
    COALESCE(
      NEW.active_until,
      NEW.observed_at + make_interval(days => active_days)
    ),
    NEW.hard_expires_at
  );
  IF NEW.location_fuzz_meters IS NULL THEN
    NEW.location_fuzz_meters := public.kodiak_setting_meters(
      'vacancy_location_fuzz_meters', 250
    );
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.kodiak_apply_vacancy_feedback()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  reset_days integer;
BEGIN
  reset_days := public.kodiak_setting_days(
    'vacancy_confirmation_reset_days', 14
  );
  IF NEW.feedback_type = 'confirm_available' THEN
    UPDATE public.vacancy_report
    SET availability_state = 'available',
        last_confirmed_at = NEW.created_at,
        active_until = LEAST(
          NEW.created_at + make_interval(days => reset_days),
          hard_expires_at
        ),
        updated_at = now()
    WHERE uuid = NEW.report_uuid
      AND archived_at IS NULL;
  ELSE
    UPDATE public.vacancy_report
    SET availability_state = 'unavailable', updated_at = now()
    WHERE uuid = NEW.report_uuid
      AND archived_at IS NULL;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS app_setting_touch_updated_at ON public.app_setting;
CREATE TRIGGER app_setting_touch_updated_at
BEFORE UPDATE ON public.app_setting
FOR EACH ROW EXECUTE FUNCTION public.kodiak_touch_updated_at();

DROP TRIGGER IF EXISTS account_touch_updated_at ON public.account;
CREATE TRIGGER account_touch_updated_at
BEFORE UPDATE ON public.account
FOR EACH ROW EXECUTE FUNCTION public.kodiak_touch_updated_at();

DROP TRIGGER IF EXISTS vacancy_report_prepare ON public.vacancy_report;
CREATE TRIGGER vacancy_report_prepare
BEFORE INSERT ON public.vacancy_report
FOR EACH ROW EXECUTE FUNCTION public.kodiak_prepare_vacancy_report();

DROP TRIGGER IF EXISTS vacancy_report_touch_updated_at ON public.vacancy_report;
CREATE TRIGGER vacancy_report_touch_updated_at
BEFORE UPDATE ON public.vacancy_report
FOR EACH ROW EXECUTE FUNCTION public.kodiak_touch_updated_at();

DROP TRIGGER IF EXISTS vacancy_feedback_touch_updated_at ON public.vacancy_feedback;
CREATE TRIGGER vacancy_feedback_touch_updated_at
BEFORE UPDATE ON public.vacancy_feedback
FOR EACH ROW EXECUTE FUNCTION public.kodiak_touch_updated_at();

DROP TRIGGER IF EXISTS vacancy_feedback_apply ON public.vacancy_feedback;
CREATE TRIGGER vacancy_feedback_apply
AFTER INSERT ON public.vacancy_feedback
FOR EACH ROW EXECUTE FUNCTION public.kodiak_apply_vacancy_feedback();

DROP TRIGGER IF EXISTS moderation_report_touch_updated_at ON public.moderation_report;
CREATE TRIGGER moderation_report_touch_updated_at
BEFORE UPDATE ON public.moderation_report
FOR EACH ROW EXECUTE FUNCTION public.kodiak_touch_updated_at();

CREATE OR REPLACE VIEW public.active_vacancy_map AS
SELECT
  uuid,
  housing_type,
  gender_restriction,
  description,
  location_latitude,
  location_longitude,
  location_fuzz_meters,
  observed_at,
  last_confirmed_at,
  active_until
FROM public.vacancy_report
WHERE archived_at IS NULL
  AND lifecycle_status = 'active'
  AND availability_state = 'available'
  AND now() < active_until
  AND now() < hard_expires_at;

CREATE OR REPLACE VIEW public.moderation_queue AS
SELECT
  uuid,
  report_uuid,
  submitted_by_uuid,
  category,
  details,
  queue_status,
  resolved_by_uuid,
  resolved_at,
  created_at,
  updated_at
FROM public.moderation_report
WHERE archived_at IS NULL
  AND queue_status IN ('open', 'in_review');

-- The API is the authorization boundary. Direct client access remains denied
-- by RLS unless a later policy explicitly grants a narrowly scoped operation.
ALTER TABLE public.app_setting ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.account ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vacancy_report ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vacancy_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.moderation_report ENABLE ROW LEVEL SECURITY;

