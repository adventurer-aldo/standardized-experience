SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: heroku_ext; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA heroku_ext;


--
-- Name: queue_classic_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.queue_classic_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN
  perform pg_notify(new.q_name, ''); RETURN NULL;
END $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    question_id integer NOT NULL,
    attempt text[],
    grade numeric DEFAULT 0 NOT NULL,
    question_type smallint DEFAULT 0 NOT NULL,
    variables text[] DEFAULT '{}'::text[] NOT NULL
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: chairs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chairs (
    id integer NOT NULL,
    subject_id integer NOT NULL,
    journey_id integer NOT NULL,
    format smallint DEFAULT 0 NOT NULL,
    first numeric,
    second numeric,
    reposition numeric,
    dissertation numeric,
    exam numeric,
    recurrence numeric
);


--
-- Name: chairs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chairs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chairs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chairs_id_seq OWNED BY public.chairs.id;


--
-- Name: challenges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.challenges (
    id integer NOT NULL,
    subject_id integer DEFAULT 0 NOT NULL,
    quiz_id integer,
    stat_id integer,
    date timestamp without time zone NOT NULL,
    goal smallint DEFAULT 1 NOT NULL,
    completion smallint DEFAULT 0 NOT NULL,
    variables integer[]
);


--
-- Name: challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.challenges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.challenges_id_seq OWNED BY public.challenges.id;


--
-- Name: choices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.choices (
    id integer NOT NULL,
    question_id integer NOT NULL,
    decoy text NOT NULL,
    veracity smallint DEFAULT 0 NOT NULL
);


--
-- Name: choices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.choices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.choices_id_seq OWNED BY public.choices.id;


--
-- Name: journeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.journeys (
    id integer NOT NULL,
    duration smallint NOT NULL,
    start_time time with time zone NOT NULL,
    end_time time with time zone,
    level smallint DEFAULT 1 NOT NULL,
    soundtrack_id integer NOT NULL,
    stat_id integer DEFAULT 2 NOT NULL
);


--
-- Name: journeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.journeys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.journeys_id_seq OWNED BY public.journeys.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    subject_id integer NOT NULL,
    question_types text[] NOT NULL,
    question text NOT NULL,
    answer text[] NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    level smallint DEFAULT 1 NOT NULL,
    frequency integer[] DEFAULT '{0,0,0}'::integer[] NOT NULL,
    parameters text[] DEFAULT '{}'::text[] NOT NULL,
    stat_id integer DEFAULT 2 NOT NULL,
    evaluable smallint DEFAULT 1 NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: queue_classic_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.queue_classic_jobs (
    id bigint NOT NULL,
    q_name text NOT NULL,
    method text NOT NULL,
    args jsonb NOT NULL,
    locked_at timestamp with time zone,
    locked_by integer,
    created_at timestamp with time zone DEFAULT now(),
    scheduled_at timestamp with time zone DEFAULT now(),
    CONSTRAINT queue_classic_jobs_method_check CHECK ((length(method) > 0)),
    CONSTRAINT queue_classic_jobs_q_name_check CHECK ((length(q_name) > 0))
);


--
-- Name: queue_classic_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.queue_classic_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: queue_classic_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.queue_classic_jobs_id_seq OWNED BY public.queue_classic_jobs.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    first_name text,
    last_name text,
    subject_id integer NOT NULL,
    journey_id integer DEFAULT 0 NOT NULL,
    start_time time with time zone NOT NULL,
    end_time time with time zone,
    format smallint DEFAULT 0 NOT NULL,
    level smallint DEFAULT 0 NOT NULL
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: seq_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seq_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: soundtracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.soundtracks (
    id integer NOT NULL,
    name text NOT NULL,
    home text NOT NULL,
    preparations text NOT NULL,
    preparations_second text NOT NULL,
    preparations_exam text NOT NULL,
    practice text[],
    first text[],
    first_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    second text[],
    second_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    dissertation text[],
    exam text[],
    exam_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    recurrence text[],
    recurrence_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    dissertation_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    practice_rush text[] DEFAULT '{""}'::text[] NOT NULL,
    preparations_dissertation text NOT NULL
);


--
-- Name: soundtrack_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.soundtrack_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: soundtrack_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.soundtrack_id_seq OWNED BY public.soundtracks.id;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stats (
    id integer NOT NULL,
    skip_dissertation smallint DEFAULT 0 NOT NULL,
    long_journey smallint DEFAULT 0 NOT NULL,
    lenient_answer smallint DEFAULT 0 NOT NULL,
    lenient_name smallint DEFAULT 1 NOT NULL,
    avoid_negative smallint DEFAULT 1 NOT NULL,
    focus_level smallint DEFAULT 0 NOT NULL,
    questions_pref smallint DEFAULT 0 NOT NULL,
    journey_id integer DEFAULT 0 NOT NULL,
    theme_id integer DEFAULT 1 NOT NULL,
    user_id integer DEFAULT 1 NOT NULL
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stats_id_seq OWNED BY public.stats.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subjects (
    id integer NOT NULL,
    title text NOT NULL,
    difficulty integer NOT NULL,
    formula smallint DEFAULT 0 NOT NULL,
    evaluable smallint DEFAULT 1 NOT NULL,
    stat_id integer DEFAULT 2 NOT NULL
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subjects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subjects_id_seq OWNED BY public.subjects.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.themes (
    id integer NOT NULL,
    name text NOT NULL,
    background text NOT NULL,
    color text NOT NULL,
    element text NOT NULL
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.themes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.themes_id_seq OWNED BY public.themes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    profile_id integer,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: chairs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chairs ALTER COLUMN id SET DEFAULT nextval('public.chairs_id_seq'::regclass);


--
-- Name: challenges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.challenges ALTER COLUMN id SET DEFAULT nextval('public.challenges_id_seq'::regclass);


--
-- Name: choices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.choices ALTER COLUMN id SET DEFAULT nextval('public.choices_id_seq'::regclass);


--
-- Name: journeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys ALTER COLUMN id SET DEFAULT nextval('public.journeys_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: queue_classic_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue_classic_jobs ALTER COLUMN id SET DEFAULT nextval('public.queue_classic_jobs_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: soundtracks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.soundtracks ALTER COLUMN id SET DEFAULT nextval('public.soundtrack_id_seq'::regclass);


--
-- Name: stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats ALTER COLUMN id SET DEFAULT nextval('public.stats_id_seq'::regclass);


--
-- Name: subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects ALTER COLUMN id SET DEFAULT nextval('public.subjects_id_seq'::regclass);


--
-- Name: themes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.themes ALTER COLUMN id SET DEFAULT nextval('public.themes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: chairs chairs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chairs
    ADD CONSTRAINT chairs_pkey PRIMARY KEY (id);


--
-- Name: challenges challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: choices choices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.choices
    ADD CONSTRAINT choices_pkey PRIMARY KEY (id);


--
-- Name: journeys journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: queue_classic_jobs queue_classic_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue_classic_jobs
    ADD CONSTRAINT queue_classic_jobs_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: soundtracks soundtrack_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.soundtracks
    ADD CONSTRAINT soundtrack_pkey PRIMARY KEY (id);


--
-- Name: stats stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: subjects subjects_title_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_title_key UNIQUE (title);


--
-- Name: themes themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_qc_on_name_only_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qc_on_name_only_unlocked ON public.queue_classic_jobs USING btree (q_name, id) WHERE (locked_at IS NULL);


--
-- Name: idx_qc_on_scheduled_at_only_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qc_on_scheduled_at_only_unlocked ON public.queue_classic_jobs USING btree (scheduled_at, id) WHERE (locked_at IS NULL);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: queue_classic_jobs queue_classic_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER queue_classic_notify AFTER INSERT ON public.queue_classic_jobs FOR EACH ROW EXECUTE FUNCTION public.queue_classic_notify();


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: chairs journey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chairs
    ADD CONSTRAINT journey FOREIGN KEY (journey_id) REFERENCES public.journeys(id) NOT VALID;


--
-- Name: stats journey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT journey FOREIGN KEY (journey_id) REFERENCES public.journeys(id) NOT VALID;


--
-- Name: journeys journeys_soundtrack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_soundtrack_id_fkey FOREIGN KEY (soundtrack_id) REFERENCES public.soundtracks(id) NOT VALID;


--
-- Name: answers question; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT question FOREIGN KEY (question_id) REFERENCES public.questions(id) NOT VALID;


--
-- Name: choices question; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.choices
    ADD CONSTRAINT question FOREIGN KEY (question_id) REFERENCES public.questions(id) NOT VALID;


--
-- Name: answers quiz; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT quiz FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) NOT VALID;


--
-- Name: chairs subject; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chairs
    ADD CONSTRAINT subject FOREIGN KEY (subject_id) REFERENCES public.subjects(id) NOT VALID;


--
-- Name: stats theme; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT theme FOREIGN KEY (theme_id) REFERENCES public.themes(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220318143645'),
('20220514093759'),
('20220830153130'),
('20220830153131'),
('20220830153132'),
('20220830153133'),
('20220830153134'),
('20220831100336');


