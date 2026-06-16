--
-- PostgreSQL database dump
--

\restrict iwKjTABby3HbMpfQhw9bA6BevoFg5TANy4eQnONfpUJHDczndGcgn2PFVABuxJH

-- Dumped from database version 14.23 (Debian 14.23-1.pgdg13+1)
-- Dumped by pg_dump version 14.23 (Debian 14.23-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.activity (
    id text NOT NULL,
    "timestamp" timestamp without time zone,
    user_id text,
    object_id text,
    activity_type text,
    data text
);


ALTER TABLE public.activity OWNER TO ckan_default;

--
-- Name: activity_detail; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.activity_detail (
    id text NOT NULL,
    activity_id text,
    object_id text,
    object_type text,
    activity_type text,
    data text
);


ALTER TABLE public.activity_detail OWNER TO ckan_default;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO ckan_default;

--
-- Name: api_token; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.api_token (
    id text NOT NULL,
    name text,
    user_id text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_access timestamp without time zone,
    plugin_extras jsonb
);


ALTER TABLE public.api_token OWNER TO ckan_default;

--
-- Name: dashboard; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.dashboard (
    user_id text NOT NULL,
    activity_stream_last_viewed timestamp without time zone NOT NULL,
    email_last_sent timestamp without time zone DEFAULT LOCALTIMESTAMP NOT NULL
);


ALTER TABLE public.dashboard OWNER TO ckan_default;

--
-- Name: file; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.file (
    id text NOT NULL,
    name text NOT NULL,
    storage text NOT NULL,
    location text NOT NULL,
    content_type text DEFAULT 'application/octet-stream'::text NOT NULL,
    size bigint DEFAULT '0'::bigint NOT NULL,
    hash text DEFAULT ''::text NOT NULL,
    algorithm text DEFAULT ''::text NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    storage_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    plugin_data jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.file OWNER TO ckan_default;

--
-- Name: file_owner; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.file_owner (
    file_id text NOT NULL,
    owner_type text NOT NULL,
    owner_id text NOT NULL,
    pinned boolean DEFAULT false NOT NULL
);


ALTER TABLE public.file_owner OWNER TO ckan_default;

--
-- Name: file_owner_transfer_history; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.file_owner_transfer_history (
    id text NOT NULL,
    file_id text NOT NULL,
    owner_id text NOT NULL,
    owner_type text NOT NULL,
    at timestamp with time zone DEFAULT now() NOT NULL,
    actor text NOT NULL,
    action text DEFAULT 'transfer'::text NOT NULL
);


ALTER TABLE public.file_owner_transfer_history OWNER TO ckan_default;

--
-- Name: group; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public."group" (
    id text NOT NULL,
    name text NOT NULL,
    title text,
    description text,
    created timestamp without time zone,
    state text,
    type text NOT NULL,
    approval_status text,
    image_url text,
    is_organization boolean DEFAULT false,
    extras jsonb,
    CONSTRAINT group_flat_extras CHECK (((jsonb_typeof(extras) = 'object'::text) AND (NOT jsonb_path_exists(extras, '$.*?(@.type() != "string")'::jsonpath))))
);


ALTER TABLE public."group" OWNER TO ckan_default;

--
-- Name: member; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.member (
    id text NOT NULL,
    group_id text,
    table_id text NOT NULL,
    state text,
    table_name text NOT NULL,
    capacity text NOT NULL
);


ALTER TABLE public.member OWNER TO ckan_default;

--
-- Name: package; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.package (
    id text NOT NULL,
    name character varying(100) NOT NULL,
    title text,
    version character varying(100),
    url text,
    notes text,
    author text,
    author_email text,
    maintainer text,
    maintainer_email text,
    state text,
    license_id text,
    type text,
    owner_org text,
    private boolean DEFAULT false,
    metadata_modified timestamp without time zone,
    creator_user_id text,
    metadata_created timestamp without time zone,
    plugin_data jsonb,
    extras jsonb,
    CONSTRAINT package_flat_extras CHECK (((jsonb_typeof(extras) = 'object'::text) AND (NOT jsonb_path_exists(extras, '$.*?(@.type() != "string")'::jsonpath))))
);


ALTER TABLE public.package OWNER TO ckan_default;

--
-- Name: package_member; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.package_member (
    package_id text NOT NULL,
    user_id text NOT NULL,
    capacity text NOT NULL,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.package_member OWNER TO ckan_default;

--
-- Name: package_relationship; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.package_relationship (
    id text NOT NULL,
    subject_package_id text,
    object_package_id text,
    type text,
    comment text,
    state text
);


ALTER TABLE public.package_relationship OWNER TO ckan_default;

--
-- Name: package_tag; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.package_tag (
    id text NOT NULL,
    state text,
    package_id text,
    tag_id text
);


ALTER TABLE public.package_tag OWNER TO ckan_default;

--
-- Name: resource; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.resource (
    id text NOT NULL,
    url text NOT NULL,
    format text,
    description text,
    "position" integer,
    hash text,
    state text,
    extras text,
    name text,
    resource_type text,
    mimetype text,
    mimetype_inner text,
    size bigint,
    last_modified timestamp without time zone,
    cache_url text,
    cache_last_updated timestamp without time zone,
    created timestamp without time zone,
    url_type text,
    package_id text DEFAULT ''::text NOT NULL,
    metadata_modified timestamp without time zone
);


ALTER TABLE public.resource OWNER TO ckan_default;

--
-- Name: resource_view; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.resource_view (
    id text NOT NULL,
    resource_id text,
    title text,
    description text,
    view_type text NOT NULL,
    "order" integer NOT NULL,
    config text
);


ALTER TABLE public.resource_view OWNER TO ckan_default;

--
-- Name: system_info; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.system_info (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    state text DEFAULT 'active'::text NOT NULL
);


ALTER TABLE public.system_info OWNER TO ckan_default;

--
-- Name: system_info_id_seq; Type: SEQUENCE; Schema: public; Owner: ckan_default
--

CREATE SEQUENCE public.system_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_info_id_seq OWNER TO ckan_default;

--
-- Name: system_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ckan_default
--

ALTER SEQUENCE public.system_info_id_seq OWNED BY public.system_info.id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.tag (
    id text NOT NULL,
    name character varying(100) NOT NULL,
    vocabulary_id character varying(100)
);


ALTER TABLE public.tag OWNER TO ckan_default;

--
-- Name: task_status; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.task_status (
    id text NOT NULL,
    entity_id text NOT NULL,
    entity_type text NOT NULL,
    task_type text NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    state text,
    error text,
    last_updated timestamp without time zone
);


ALTER TABLE public.task_status OWNER TO ckan_default;

--
-- Name: term_translation; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.term_translation (
    term text NOT NULL,
    term_translation text NOT NULL,
    lang_code text NOT NULL
);


ALTER TABLE public.term_translation OWNER TO ckan_default;

--
-- Name: tracking_raw; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.tracking_raw (
    user_key character varying(100) NOT NULL,
    url text NOT NULL,
    tracking_type character varying(10) NOT NULL,
    access_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tracking_raw OWNER TO ckan_default;

--
-- Name: tracking_summary; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.tracking_summary (
    url text NOT NULL,
    package_id text,
    tracking_type character varying(10) NOT NULL,
    count integer NOT NULL,
    running_total integer DEFAULT 0 NOT NULL,
    recent_views integer DEFAULT 0 NOT NULL,
    tracking_date date
);


ALTER TABLE public.tracking_summary OWNER TO ckan_default;

--
-- Name: user; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public."user" (
    id text NOT NULL,
    name text NOT NULL,
    apikey text,
    created timestamp without time zone,
    about text,
    password text,
    fullname text,
    email text,
    reset_key text,
    sysadmin boolean DEFAULT false,
    activity_streams_email_notifications boolean DEFAULT false,
    state text DEFAULT 'active'::text NOT NULL,
    plugin_extras jsonb,
    image_url text,
    last_active timestamp without time zone
);


ALTER TABLE public."user" OWNER TO ckan_default;

--
-- Name: user_following_dataset; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.user_following_dataset (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.user_following_dataset OWNER TO ckan_default;

--
-- Name: user_following_group; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.user_following_group (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.user_following_group OWNER TO ckan_default;

--
-- Name: user_following_user; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.user_following_user (
    follower_id text NOT NULL,
    object_id text NOT NULL,
    datetime timestamp without time zone NOT NULL
);


ALTER TABLE public.user_following_user OWNER TO ckan_default;

--
-- Name: vocabulary; Type: TABLE; Schema: public; Owner: ckan_default
--

CREATE TABLE public.vocabulary (
    id text NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.vocabulary OWNER TO ckan_default;

--
-- Name: system_info id; Type: DEFAULT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.system_info ALTER COLUMN id SET DEFAULT nextval('public.system_info_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.activity (id, "timestamp", user_id, object_id, activity_type, data) FROM stdin;
8c423d3b-11ee-4c19-9ef9-ffef581a78f9	2026-06-07 15:34:52.099325	1ecba460-a929-4fd0-918d-da926ace8d0f	1ecba460-a929-4fd0-918d-da926ace8d0f	new user	\N
db033f23-6244-48d0-9f2f-ccdec0c91df9	2026-06-07 15:36:37.882755	1ecba460-a929-4fd0-918d-da926ace8d0f	1ecba460-a929-4fd0-918d-da926ace8d0f	changed user	\N
1a0203c8-30c5-44fc-97b9-4034bb20ea43	2026-06-07 15:40:56.733761	f45d3f4c-fed7-4931-ae77-ad0dabc91162	71ba2e16-6c79-4313-86e5-731b209fff31	new organization	{"group": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}}
a77cb140-e723-42e7-b377-b3e091fe1f5c	2026-06-07 15:44:38.785886	f45d3f4c-fed7-4931-ae77-ad0dabc91162	26b7e4f3-0df3-400f-938f-085d5cabab4d	new package	{"package": {"author": "Deserunt cupidatat p", "author_email": "tykyr@mailinator.com", "creator_user_id": "f45d3f4c-fed7-4931-ae77-ad0dabc91162", "id": "26b7e4f3-0df3-400f-938f-085d5cabab4d", "isopen": true, "license_id": "cc-by", "license_title": "Creative Commons Attribution", "license_url": "http://www.opendefinition.org/licenses/cc-by", "maintainer": "Irure sit mollitia i", "maintainer_email": "fuhuqasep@mailinator.com", "metadata_created": "2026-06-07T15:44:37.883843", "metadata_modified": "2026-06-07T15:44:37.883860", "name": "akklahfdkh", "notes": "Reiciendis id conseq", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Aliqua Neque volupt", "type": "dataset", "url": "Molestias ad delectu", "version": "Cupidatat velit id", "extras": [{"key": "Duis tempore laudan", "value": "Itaque laborum in cu"}, {"key": "Enim velit velit au", "value": "Occaecat architecto "}, {"key": "Nulla eum voluptatem", "value": "Officia et ad elit "}], "tags": [{"display_name": "Dolor ex quia pariat", "id": "d1639a80-e891-4668-b8ef-20be5e21b1c9", "name": "Dolor ex quia pariat", "state": "active", "vocabulary_id": null}], "resources": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "default"}
0466ecd5-ec14-4ace-987f-931002f78011	2026-06-07 15:45:26.15013	f45d3f4c-fed7-4931-ae77-ad0dabc91162	a199f77a-3127-4fa8-933e-f9bbfdfad9ed	new package	{"package": {"author": "Hic facere est est ", "author_email": "qyfak@mailinator.com", "creator_user_id": "f45d3f4c-fed7-4931-ae77-ad0dabc91162", "id": "a199f77a-3127-4fa8-933e-f9bbfdfad9ed", "isopen": false, "license_id": "cc-nc", "license_title": "Creative Commons Non-Commercial (Any)", "license_url": "http://creativecommons.org/licenses/by-nc/2.0/", "maintainer": "Enim qui qui aut pla", "maintainer_email": "bacodedu@mailinator.com", "metadata_created": "2026-06-07T15:45:25.665535", "metadata_modified": "2026-06-07T15:45:25.665551", "name": "disodfadh", "notes": "Aute ducimus volupt", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Labore commodi repre", "type": "dataset", "url": "Mollit sed facilis p", "version": "Et laborum animi no", "extras": [{"key": "Iure sit deserunt v", "value": "Veniam nisi nulla d"}, {"key": "Quidem consequatur ", "value": "Id obcaecati cupidit"}, {"key": "Rerum esse vel et d", "value": "Dolor et sed eiusmod"}], "tags": [{"display_name": "Totam laborum ipsum", "id": "56e8073a-a8c1-455e-a64e-f226cd774d48", "name": "Totam laborum ipsum", "state": "active", "vocabulary_id": null}], "resources": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "default"}
d0773d90-8add-4d0f-96c2-8e3dd4fe0e65	2026-06-07 15:46:32.92562	f45d3f4c-fed7-4931-ae77-ad0dabc91162	a3c1575b-7a96-4286-bdb0-946eac22466e	new package	{"package": {"author": "Hic facere est est ", "author_email": "qyfak@mailinator.com", "creator_user_id": "f45d3f4c-fed7-4931-ae77-ad0dabc91162", "id": "a3c1575b-7a96-4286-bdb0-946eac22466e", "isopen": false, "license_id": "cc-nc", "license_title": "Creative Commons Non-Commercial (Any)", "license_url": "http://creativecommons.org/licenses/by-nc/2.0/", "maintainer": "Enim qui qui aut pla", "maintainer_email": "bacodedu@mailinator.com", "metadata_created": "2026-06-07T15:46:32.475943", "metadata_modified": "2026-06-07T15:46:32.475959", "name": "afsfsdfasdafdf", "notes": "Aute ducimus volupt", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Labore commodi repre", "type": "dataset", "url": "Mollit sed facilis p", "version": "Et laborum animi no", "extras": [{"key": "Iure sit deserunt v", "value": "Veniam nisi nulla d"}, {"key": "Quidem consequatur ", "value": "Id obcaecati cupidit"}, {"key": "Rerum esse vel et d", "value": "Dolor et sed eiusmod"}], "tags": [{"display_name": "Totam laborum ipsum", "id": "56e8073a-a8c1-455e-a64e-f226cd774d48", "name": "Totam laborum ipsum", "state": "active", "vocabulary_id": null}], "resources": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "default"}
3fdfdde7-d1f9-4e06-92ec-72f9eabe6202	2026-06-07 15:48:18.840061	1ecba460-a929-4fd0-918d-da926ace8d0f	a34d7551-26a7-47d8-b938-c651d0dca95c	new package	{"package": {"author": "Voluptate saepe sed ", "author_email": "faduri@mailinator.com", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "a34d7551-26a7-47d8-b938-c651d0dca95c", "isopen": false, "license_id": "other-nc", "license_title": "Other (Non-Commercial)", "maintainer": "Odit maxime ab qui a", "maintainer_email": "luvezo@mailinator.com", "metadata_created": "2026-06-07T15:48:18.304704", "metadata_modified": "2026-06-07T15:48:18.304729", "name": "adaf-asdfa", "notes": "Labore dicta in veli", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Quae voluptatibus to", "type": "dataset", "url": "Facilis odit quis al", "version": "Explicabo Omnis rep", "extras": [{"key": "Earum culpa vel sit", "value": "Aliquam debitis aut "}, {"key": "Qui est quis corrupt", "value": "Qui ducimus corpori"}, {"key": "Vitae qui rem non qu", "value": "Obcaecati voluptatem"}], "tags": [{"display_name": "Incidunt nostrum vo", "id": "10150254-e9e3-4d07-92f6-083d667d421b", "name": "Incidunt nostrum vo", "state": "active", "vocabulary_id": null}], "resources": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
a66d8a3a-1a69-467d-a400-203c2de0e5b2	2026-06-07 15:49:36.838536	1ecba460-a929-4fd0-918d-da926ace8d0f	a34d7551-26a7-47d8-b938-c651d0dca95c	changed package	{"package": {"author": "Voluptate saepe sed ", "author_email": "faduri@mailinator.com", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "a34d7551-26a7-47d8-b938-c651d0dca95c", "isopen": false, "license_id": "other-nc", "license_title": "Other (Non-Commercial)", "maintainer": "Odit maxime ab qui a", "maintainer_email": "luvezo@mailinator.com", "metadata_created": "2026-06-07T15:48:18.304704", "metadata_modified": "2026-06-07T15:49:36.714950", "name": "adaf-asdfa", "notes": "Labore dicta in veli", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Quae voluptatibus to", "type": "dataset", "url": "Facilis odit quis al", "version": "Explicabo Omnis rep", "extras": [{"key": "Earum culpa vel sit", "value": "Aliquam debitis aut "}, {"key": "Qui est quis corrupt", "value": "Qui ducimus corpori"}, {"key": "Vitae qui rem non qu", "value": "Obcaecati voluptatem"}], "tags": [{"display_name": "Incidunt nostrum vo", "id": "10150254-e9e3-4d07-92f6-083d667d421b", "name": "Incidunt nostrum vo", "state": "active", "vocabulary_id": null}], "resources": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
c610c130-a1af-4a75-b3c9-9f6743e77827	2026-06-07 16:10:34.986796	1ecba460-a929-4fd0-918d-da926ace8d0f	a34d7551-26a7-47d8-b938-c651d0dca95c	changed package	{"package": {"author": "Voluptate saepe sed ", "author_email": "faduri@mailinator.com", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "a34d7551-26a7-47d8-b938-c651d0dca95c", "isopen": false, "license_id": "other-nc", "license_title": "Other (Non-Commercial)", "maintainer": "Odit maxime ab qui a", "maintainer_email": "luvezo@mailinator.com", "metadata_created": "2026-06-07T15:48:18.304704", "metadata_modified": "2026-06-07T16:10:34.434907", "name": "adaf-asdfa", "notes": "Labore dicta in veli", "num_resources": 0, "num_tags": 1, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Quae voluptatibus to", "type": "dataset", "url": "Facilis odit quis al", "version": "Explicabo Omnis rep", "tags": [{"display_name": "Incidunt nostrum vo", "id": "10150254-e9e3-4d07-92f6-083d667d421b", "name": "Incidunt nostrum vo", "state": "active", "vocabulary_id": null}], "resources": [], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
8759f8e8-227b-4421-a774-2242c3624d87	2026-06-07 16:11:58.990881	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	new package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:11:58.402593", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 0, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "resources": [], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
3de28adb-23fe-4093-b100-ebc9b2e05d10	2026-06-07 16:12:24.964356	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	changed package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:12:24.827555", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 1, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "draft", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "resources": [{"cache_last_updated": null, "cache_url": null, "created": "2026-06-07T16:12:24.873945", "description": "", "format": "CSV", "hash": "", "id": "dd64b0d8-17a9-4fd9-949e-ce3a529ea27b", "last_modified": null, "metadata_modified": "2026-06-07T16:12:24.849309", "mimetype": null, "mimetype_inner": null, "name": "", "package_id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "position": 0, "resource_type": null, "size": null, "state": "active", "url": "", "url_type": ""}], "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
81a4aa8c-75fa-4cd9-b5e4-097a4cb98452	2026-06-07 16:12:25.586218	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	changed package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:12:25.280734", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 1, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "active", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "resources": [{"cache_last_updated": null, "cache_url": null, "created": "2026-06-07T16:12:24.873945", "description": "", "format": "CSV", "hash": "", "id": "dd64b0d8-17a9-4fd9-949e-ce3a529ea27b", "last_modified": null, "metadata_modified": "2026-06-07T16:12:24.849309", "mimetype": null, "mimetype_inner": null, "name": "", "package_id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "position": 0, "resource_type": null, "size": null, "state": "active", "url": "", "url_type": ""}], "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
faa64634-2d4b-4b80-81b5-1945ce3016fb	2026-06-07 16:13:12.667473	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	changed package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:13:12.558777", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 1, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "active", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "resources": [{"cache_last_updated": null, "cache_url": null, "created": "2026-06-07T16:12:24.873945", "description": "", "format": "CSV", "hash": "", "id": "dd64b0d8-17a9-4fd9-949e-ce3a529ea27b", "last_modified": null, "metadata_modified": "2026-06-07T16:12:24.849309", "mimetype": null, "mimetype_inner": null, "name": "", "package_id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "position": 0, "resource_type": null, "size": null, "state": "active", "url": "", "url_type": ""}], "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
ec95c1e2-d031-412c-b748-2a77cc2aa06b	2026-06-07 16:16:16.733549	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	changed package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:16:16.394767", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 0, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "active", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "resources": [], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
8a9a0cf4-be87-474f-9ea1-ced59515e8df	2026-06-07 16:25:10.425275	1ecba460-a929-4fd0-918d-da926ace8d0f	ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3	changed package	{"package": {"author": "", "author_email": "", "creator_user_id": "1ecba460-a929-4fd0-918d-da926ace8d0f", "id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "isopen": false, "license_id": "", "license_title": "", "maintainer": "", "maintainer_email": "", "metadata_created": "2026-06-07T16:11:58.402576", "metadata_modified": "2026-06-07T16:25:10.190138", "name": "layanan-call-center-112", "notes": "Data rekap tahunan call center 112", "num_resources": 1, "num_tags": 3, "organization": {"id": "71ba2e16-6c79-4313-86e5-731b209fff31", "name": "diskominfo", "title": "Dinas Komunikasi dan Informatika", "type": "organization", "description": "", "image_url": "", "created": "2026-06-07T15:40:56.584119", "is_organization": true, "approval_status": "approved", "state": "active"}, "owner_org": "71ba2e16-6c79-4313-86e5-731b209fff31", "private": false, "state": "active", "title": "Layanan Call Center 112", "type": "dataset", "url": "", "version": "", "resources": [{"cache_last_updated": null, "cache_url": null, "created": "2026-06-07T16:25:10.292799", "description": "", "format": "CSV", "hash": "", "id": "abbfef72-2889-449f-aa0e-f5a45c2df662", "last_modified": "2026-06-07T16:25:10.163040", "metadata_modified": "2026-06-07T16:25:10.235931", "mimetype": "text/csv", "mimetype_inner": null, "name": "Nabung Emas 5 Tahun - SUI.csv", "package_id": "ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3", "position": 0, "resource_type": null, "size": 385, "state": "active", "url": "http://localhost:5000/dataset/ba7ed390-dbb7-4d54-9dc4-a02e2c0603d3/resource/abbfef72-2889-449f-aa0e-f5a45c2df662/download/nabung-emas-5-tahun-sui.csv", "url_type": "upload"}], "tags": [{"display_name": "112", "id": "76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8", "name": "112", "state": "active", "vocabulary_id": null}, {"display_name": "Call Center", "id": "cb162de2-3be7-4b23-8f5e-9f464c139648", "name": "Call Center", "state": "active", "vocabulary_id": null}, {"display_name": "Public Service", "id": "81f52d8f-487a-4c6e-9525-687300b1d717", "name": "Public Service", "state": "active", "vocabulary_id": null}], "extras": [], "groups": [], "relationships_as_subject": [], "relationships_as_object": []}, "actor": "ckan_admin"}
\.


--
-- Data for Name: activity_detail; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.activity_detail (id, activity_id, object_id, object_type, activity_type, data) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.alembic_version (version_num) FROM stdin;
9445ce34fc23
\.


--
-- Data for Name: api_token; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.api_token (id, name, user_id, created_at, last_access, plugin_extras) FROM stdin;
eTkEgB1cu96qIKTl2EeBvi6YTvOTyBiKjNtN3n3e0a4	datapusher	1ecba460-a929-4fd0-918d-da926ace8d0f	2026-06-12 08:06:06.026683	2026-06-15 22:55:54.482301	\N
\.


--
-- Data for Name: dashboard; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.dashboard (user_id, activity_stream_last_viewed, email_last_sent) FROM stdin;
1ecba460-a929-4fd0-918d-da926ace8d0f	2026-06-07 15:34:52.090553	2026-06-07 15:34:52.090563
b68d0318-8694-4411-a4ae-d9aa9bcdd5d2	2026-06-15 22:46:17.744377	2026-06-15 22:46:17.744402
ae8481ec-9efd-44e2-8819-a649fb141ef2	2026-06-15 23:24:20.62826	2026-06-15 23:24:20.628264
0fa4cc7f-c2c5-41a9-a932-cb46fa5fcafc	2026-06-15 23:38:16.968202	2026-06-15 23:38:16.968206
94ac333d-b70b-4a73-803d-20ddd1b14873	2026-06-16 04:41:53.403319	2026-06-16 04:41:53.403337
975cd397-3b9f-444b-b605-e5ae65703085	2026-06-16 04:44:41.599551	2026-06-16 04:44:41.59957
7ca8f8cf-22dc-4459-b9fe-2586753c2bff	2026-06-16 04:52:50.014376	2026-06-16 04:52:50.0144
5c2e4bf3-0f24-4a9f-8d73-e7ae93099ddc	2026-06-16 04:54:32.098694	2026-06-16 04:54:32.098711
dea08c51-9c0a-44eb-8ffb-16a05d3f360b	2026-06-16 04:55:00.472349	2026-06-16 04:55:00.472364
018826dd-ca2e-4c93-8dfc-0c684b8d8a3b	2026-06-16 04:57:39.183514	2026-06-16 04:57:39.183535
0a85ba18-93fe-478e-af42-12305431e5c9	2026-06-16 04:58:31.244001	2026-06-16 04:58:31.244023
f797cbf0-2614-49c8-bc1a-0c3532ff9303	2026-06-16 05:01:02.728003	2026-06-16 05:01:02.728015
4aaa69c1-0168-440c-a449-fa2c2961ef09	2026-06-16 05:02:24.349427	2026-06-16 05:02:24.349448
1bec422e-50d7-4949-8eec-087c2fd8593b	2026-06-16 05:03:17.685022	2026-06-16 05:03:17.685039
75381928-6189-47e9-a2fc-8926fdc637d7	2026-06-16 05:04:10.59925	2026-06-16 05:04:10.599266
a2c23ac6-921f-4cf3-ba59-db57f61b185e	2026-06-16 05:04:53.843112	2026-06-16 05:04:53.843124
7451ce91-9d76-45d5-b9c4-76adf416ce64	2026-06-16 05:05:39.375092	2026-06-16 05:05:39.375111
c720aa59-4c14-4647-bfdd-202a69078b4f	2026-06-16 05:06:34.230995	2026-06-16 05:06:34.231009
f2938c54-fbef-4aaf-b107-91ac38017394	2026-06-16 05:08:09.882008	2026-06-16 05:08:09.882014
02610c00-315f-4e62-9003-f87e6fe9f16a	2026-06-16 05:09:01.621171	2026-06-16 05:09:01.621177
a5c70df3-209e-45f8-88e5-ff1ecef1fce4	2026-06-16 05:10:21.480323	2026-06-16 05:10:21.48033
2eda759d-9be0-4b8c-90e8-0d77e86eaef9	2026-06-16 05:10:56.233844	2026-06-16 05:10:56.233849
b7327420-c2a1-4719-8061-22d1ebca7d3d	2026-06-16 05:11:39.651899	2026-06-16 05:11:39.651904
c2e9c708-538b-42a4-b08c-d034f7b337a4	2026-06-16 05:12:23.543108	2026-06-16 05:12:23.543116
78e40015-1e4c-4367-99cb-b4cf78bc8c40	2026-06-16 05:12:58.026947	2026-06-16 05:12:58.026957
70ce8cd0-a15f-459e-9707-0ff7deec71ad	2026-06-16 05:13:39.55362	2026-06-16 05:13:39.553624
9ab7f247-3171-48a0-acb3-206bec24196a	2026-06-16 05:14:47.329083	2026-06-16 05:14:47.329093
3c5b8747-6349-452c-9aaa-c98e19c314b8	2026-06-16 05:15:54.020914	2026-06-16 05:15:54.020926
43dc1949-3059-456e-9a48-28be33cd1138	2026-06-16 05:17:57.68204	2026-06-16 05:17:57.682044
268d7f9c-81a0-4f26-bb02-2a3eaa520386	2026-06-16 05:18:42.934038	2026-06-16 05:18:42.934044
5637f386-24bd-4fe2-b369-33ad666b66d9	2026-06-16 05:19:36.286755	2026-06-16 05:19:36.286762
56f6a936-9632-4958-955b-fee71c1354a4	2026-06-16 05:20:43.275039	2026-06-16 05:20:43.275054
934c8103-6c93-44e8-9bb4-18bed33b43ce	2026-06-16 05:21:51.963833	2026-06-16 05:21:51.963841
a6d80551-94ff-45fa-a962-45f7e6ac9b5e	2026-06-16 05:22:51.685481	2026-06-16 05:22:51.685485
b81e9f9a-b86b-41ce-b3e3-a5eb2f7cfe14	2026-06-16 05:24:00.802125	2026-06-16 05:24:00.802148
1850ca4d-4896-4b60-81ce-5d14b63249f8	2026-06-16 05:25:53.345966	2026-06-16 05:25:53.345973
cd5886d0-db01-45b0-b40e-a041e3a91ade	2026-06-16 05:26:30.330894	2026-06-16 05:26:30.33091
b9f93bb1-fe46-41f6-84e3-c192e4edcfa6	2026-06-16 05:27:44.429474	2026-06-16 05:27:44.429477
903e974e-e87b-429c-be07-fa30ecf451ec	2026-06-16 05:28:31.044722	2026-06-16 05:28:31.044725
48835434-f85e-4d1d-9432-505392deee4f	2026-06-16 05:29:44.179099	2026-06-16 05:29:44.179105
f5e5b358-3b9e-4546-8146-3963034e9ca6	2026-06-16 05:30:22.43517	2026-06-16 05:30:22.435179
78c9a180-dc15-409f-b6d2-e1cf8c285298	2026-06-16 05:31:05.951222	2026-06-16 05:31:05.951225
3d8a85b7-48b4-4980-95a2-d9bc3bbfbfa9	2026-06-16 05:31:42.99195	2026-06-16 05:31:42.991965
2c5c2e38-31f5-43fd-bfe5-67bb1154a544	2026-06-16 05:32:47.094773	2026-06-16 05:32:47.094783
\.


--
-- Data for Name: file; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.file (id, name, storage, location, content_type, size, hash, algorithm, created, storage_data, plugin_data) FROM stdin;
\.


--
-- Data for Name: file_owner; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.file_owner (file_id, owner_type, owner_id, pinned) FROM stdin;
\.


--
-- Data for Name: file_owner_transfer_history; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.file_owner_transfer_history (id, file_id, owner_id, owner_type, at, actor, action) FROM stdin;
\.


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public."group" (id, name, title, description, created, state, type, approval_status, image_url, is_organization, extras) FROM stdin;
bfe491dc-19e1-4877-b34e-baa35463ff23	inspektorat	Inspektorat	Inspektorat merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam membina dan mengawasi pelaksanaan urusan pemerintahan yang menjadi kewenangan daerah dan tugas pembantuan oleh perangkat daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nInspektorat berperan dalam perumusan kebijakan teknis pembinaan dan pengawasan, pelaksanaan pengawasan internal terhadap kinerja dan keuangan melalui audit, review, evaluasi, pemantauan, dan asistensi, serta pengawasan untuk tujuan tertentu. Selain itu, Inspektorat juga bertanggung jawab dalam penegakan integritas, pencegahan dan pemberantasan korupsi, kolusi, dan nepotisme, serta penanganan pengaduan masyarakat terkait jalannya tata kelola pemerintahan.\r\n\r\nDalam menjalankan tugas dan fungsinya, Inspektorat menyelenggarakan penguatan sistem pengendalian intern pemerintah (SPIP), peningkatan kapabilitas aparat pengawasan intern pemerintah (APIP), serta pendampingan manajemen risiko di lingkungan pemerintah daerah. Pelaksanaan tugas dilakukan melalui koordinasi dengan aparat penegak hukum, instansi pengawas eksternal, serta pemangku kepentingan lainnya guna mewujudkan tata kelola pemerintahan yang bersih, transparan, akuntabel, dan bebas dari penyimpangan demi mendukung efektivitas penyelenggaraan pembangunan dan pelayanan publik.	2026-06-08 01:16:47.762211	active	organization	approved	2026-06-08-051201.982478inspektorat.webp	t	{}
8fd34d1b-f4ad-49bb-8f8c-77fc62ad9b5c	dinas-pekerjaan-umum-dan-penataan-ruang	Dinas Pekerjaan Umum dan Penataan Ruang	Dinas Pekerjaan Umum dan Penataan Ruang merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pekerjaan umum dan penataan ruang sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan pembangunan infrastruktur daerah yang meliputi pengelolaan sumber daya air, pembangunan dan pemeliharaan jalan dan jembatan, sistem drainase, sanitasi, serta infrastruktur permukiman. Selain itu, Dinas Pekerjaan Umum dan Penataan Ruang juga bertanggung jawab dalam penyusunan, pengendalian, dan pengawasan penataan ruang wilayah guna mewujudkan tata ruang yang aman, nyaman, produktif, dan berkelanjutan.\r\n\r\nDalam menjalankan tugas dan fungsinya, Dinas Pekerjaan Umum dan Penataan Ruang mengedepankan prinsip efisiensi, kualitas, keselamatan, dan kelestarian lingkungan, serta melakukan koordinasi lintas sektor dengan perangkat daerah, pemerintah pusat dan provinsi, dunia usaha, dan masyarakat dalam rangka mendukung pembangunan daerah yang terencana dan berwawasan lingkungan.	2026-06-08 00:33:53.070483	active	organization	approved	2026-06-08-051933.235969LogoPURGB.jpg	t	{}
71ba2e16-6c79-4313-86e5-731b209fff31	diskominfo	Dinas Komunikasi dan Informatika	Dinas Komunikasi dan Informatika merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang komunikasi dan informatika, statistik sektoral, serta persandian sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Komunikasi dan Informatika berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan informasi dan komunikasi publik, pengembangan dan pengelolaan sistem pemerintahan berbasis elektronik (SPBE), layanan infrastruktur teknologi informasi dan komunikasi, serta pengelolaan data dan statistik sektoral daerah.\r\n\r\nSelain itu, Dinas Komunikasi dan Informatika juga menyelenggarakan pengamanan informasi dan persandian, pengelolaan pusat data dan jaringan, diseminasi informasi kebijakan pemerintah, serta peningkatan literasi digital masyarakat. Dalam menjalankan tugas dan fungsinya, Diskominfo melakukan kerja sama lintas sektor dengan perangkat daerah, instansi vertikal, dunia usaha, dan masyarakat guna mewujudkan tata kelola pemerintahan yang transparan, efektif, dan berbasis teknologi informasi.	2026-06-07 15:40:56.584119	active	organization	approved	2026-06-08-052852.347091download.jpg	t	{}
3e41a3f7-44c5-4cc0-a1b9-36de9b0af6d9	dinas-perumahan-kawasan-permukiman-dan-pertanahan	Dinas Perumahan, Kawasan Permukiman dan Pertanahan	Dinas Perumahan, Kawasan Permukiman, dan Pertanahan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perumahan, kawasan permukiman, serta pertanahan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan pembangunan dan pengelolaan perumahan dan kawasan permukiman yang layak, aman, dan berkelanjutan. Pelaksanaan tugas tersebut mencakup penyediaan perumahan, penataan dan peningkatan kualitas kawasan permukiman, penanganan kawasan kumuh, serta pengembangan prasarana, sarana, dan utilitas umum permukiman.\r\n\r\nSelain itu, Dinas Perumahan, Kawasan Permukiman, dan Pertanahan juga menyelenggarakan urusan pertanahan sesuai kewenangan daerah, pengelolaan data dan informasi perumahan dan pertanahan, serta fasilitasi kepastian hukum dan pemanfaatan tanah untuk kepentingan pembangunan. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, instansi terkait, dunia usaha, dan masyarakat guna mewujudkan lingkungan permukiman yang tertata, layak huni, dan berkeadilan.	2026-06-16 00:17:53.541537	active	organization	approved	2026-06-16-001753.529785LambangKotaKendari.webp	t	{}
c00b536e-bb7e-4fa1-8eb9-d3dbd9607410	dinas-tenaga-kerja-dan-perindustrian	Dinas Tenaga Kerja dan Perindustrian	Dinas Tenaga Kerja dan Perindustrian merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang ketenagakerjaan dan perindustrian sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pembangunan ketenagakerjaan yang meliputi peningkatan kompetensi dan produktivitas tenaga kerja, penempatan dan perluasan kesempatan kerja, perlindungan tenaga kerja, serta pembinaan hubungan industrial yang harmonis. Di bidang perindustrian, dinas bertanggung jawab dalam pengembangan dan pembinaan industri daerah, peningkatan daya saing industri, serta penguatan struktur dan hilirisasi industri berbasis potensi lokal.\r\n\r\nSelain itu, Dinas Tenaga Kerja dan Perindustrian juga menyelenggarakan pengelolaan data dan informasi ketenagakerjaan dan industri, fasilitasi pelatihan dan sertifikasi kompetensi, serta pengembangan kawasan dan sentra industri. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, dunia usaha, lembaga pendidikan dan pelatihan, serta pemangku kepentingan lainnya guna mendorong penciptaan lapangan kerja dan pertumbuhan industri yang berkelanjutan.	2026-06-16 00:12:47.182696	active	organization	approved	2026-06-16-001247.172338b8c364831e660c0586fca6f11f69c5b6.png	t	{}
2fec2312-cfb4-479f-a652-611f99239352	dinas-sosial	Dinas Sosial	Dinas Sosial merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang sosial sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Sosial berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan kesejahteraan sosial yang bertujuan untuk meningkatkan perlindungan dan pelayanan sosial bagi penyandang masalah kesejahteraan sosial, kelompok rentan, serta masyarakat kurang mampu. Pelaksanaan tugas tersebut mencakup penanganan fakir miskin, rehabilitasi sosial, perlindungan dan jaminan sosial, penanggulangan bencana sosial, serta pemberdayaan sosial masyarakat.\r\n\r\nSelain itu, Dinas Sosial juga menyelenggarakan pengelolaan data dan informasi kesejahteraan sosial, fasilitasi bantuan dan layanan sosial, serta penguatan peran lembaga kesejahteraan sosial dan partisipasi masyarakat. Dalam menjalankan tugas dan fungsinya, Dinas Sosial melakukan kerja sama lintas sektor dengan perangkat daerah, lembaga pemerintah dan nonpemerintah, serta pemangku kepentingan lainnya guna mewujudkan kesejahteraan sosial yang inklusif, berkeadilan, dan berkelanjutan.	2026-06-16 00:15:10.050194	active	organization	approved	2026-06-16-001510.042827dinas-sosial.png	t	{}
5d7b5adb-2c1d-4e6d-ae6b-2635e1ca03b4	dinas-perpustakaan-dan-kearsipan	Dinas Perpustakaan dan Kearsipan	Dinas Perpustakaan dan Kearsipan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perpustakaan dan kearsipan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan dan pengembangan perpustakaan guna meningkatkan budaya literasi, minat baca, serta akses masyarakat terhadap sumber informasi dan pengetahuan. Di bidang kearsipan, dinas bertanggung jawab dalam penyelenggaraan pengelolaan arsip yang tertib, autentik, terpercaya, dan berkelanjutan sebagai sumber informasi dan pertanggungjawaban penyelenggaraan pemerintahan.\r\n\r\nSelain itu, Dinas Perpustakaan dan Kearsipan juga menyelenggarakan pengelolaan sistem informasi perpustakaan dan kearsipan, pelestarian bahan pustaka dan arsip, pembinaan kearsipan pada perangkat daerah, serta penguatan layanan kepada masyarakat. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, lembaga pendidikan, komunitas literasi, dan pemangku kepentingan lainnya guna mewujudkan masyarakat yang cerdas, berpengetahuan, dan berbudaya arsip.	2026-06-16 00:20:29.676853	active	organization	approved	2026-06-16-002029.667361perpustakaan.png	t	{}
060a358b-3f82-4602-8420-ab50ca35bf99	dinas-perikanan	Dinas Perikanan	Dinas Perikanan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perikanan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Perikanan berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan dan pengembangan sektor perikanan yang mencakup perikanan tangkap, perikanan budidaya, pengolahan dan pemasaran hasil perikanan, serta pengelolaan sumber daya perikanan yang berkelanjutan. Pelaksanaan tugas tersebut bertujuan untuk meningkatkan produksi, nilai tambah, dan kesejahteraan pelaku usaha perikanan.\r\n\r\nSelain itu, Dinas Perikanan juga menyelenggarakan pengelolaan data dan informasi perikanan, peningkatan kapasitas nelayan dan pembudidaya ikan, fasilitasi sarana dan prasarana perikanan, serta pengawasan pemanfaatan sumber daya perikanan. Dalam menjalankan tugas dan fungsinya, Dinas Perikanan menjalin kerja sama lintas sektor dengan perangkat daerah, instansi terkait, dunia usaha, dan masyarakat guna mewujudkan sektor perikanan yang maju, berdaya saing, dan berkelanjutan.	2026-06-16 00:22:34.620879	active	organization	approved	2026-06-16-002234.615548perikanan.png	t	{}
02286cfe-d99d-4eec-be22-0cfad931ef0b	dinas-perhubungan	Dinas Perhubungan	Dinas Perhubungan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perhubungan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Perhubungan berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan transportasi darat, laut, dan/atau udara sesuai kewenangan daerah. Pelaksanaan tugas tersebut mencakup pengelolaan lalu lintas dan angkutan jalan, pengembangan sarana dan prasarana transportasi, keselamatan dan keamanan transportasi, serta pengendalian dan penataan sistem transportasi yang tertib dan berkelanjutan.\r\n\r\nSelain itu, Dinas Perhubungan juga menyelenggarakan pengelolaan data dan informasi perhubungan, pengawasan operasional angkutan, serta edukasi keselamatan berlalu lintas kepada masyarakat. Dalam menjalankan tugas dan fungsinya, Dinas Perhubungan melakukan kerja sama lintas sektor dengan perangkat daerah, aparat penegak hukum, operator transportasi, dan pemangku kepentingan lainnya guna mewujudkan sistem transportasi daerah yang aman, lancar, dan berdaya saing.	2026-06-16 00:23:53.343717	active	organization	approved	2026-06-16-002425.254314perhubungan.png	t	{}
5fcbba9f-43a5-4da1-a8c6-220c74d34b76	dinas-perdagangan-koperasi-dan-ukm	Dinas Perdagangan, Koperasi dan UKM	Dinas Perdagangan, Koperasi, dan Usaha Kecil Menengah merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perdagangan, perkoperasian, serta pemberdayaan dan pengembangan usaha mikro, kecil, dan menengah (UMKM) sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta fasilitasi kegiatan perdagangan dalam rangka menjaga stabilitas distribusi dan harga barang, meningkatkan daya saing produk lokal, serta memperkuat sistem perdagangan yang adil, tertib, dan berkelanjutan.\r\n\r\nSelain itu, Dinas Perdagangan, Koperasi, dan UKM juga menyelenggarakan pembinaan dan pengembangan koperasi serta UMKM melalui peningkatan kapasitas kelembagaan, akses permodalan, pendampingan usaha, pelatihan kewirausahaan, dan perluasan akses pasar. Pelaksanaan tugas dan fungsi dinas dilakukan melalui koordinasi lintas sektor dengan instansi pemerintah, pelaku usaha, lembaga keuangan, dan pemangku kepentingan lainnya guna mendorong pertumbuhan ekonomi daerah yang inklusif dan berdaya saing.	2026-06-16 00:26:34.04057	active	organization	approved	2026-06-16-002634.033257c673f70da96ae1630449dac001fed3ee.png	t	{}
85598710-3fa3-4f86-8db9-f812b5925a2a	dinas-pengendalian-penduduk-dan-keluarga-berencana	Dinas Pengendalian Penduduk dan Keluarga Berencana	Dinas Pengendalian Penduduk dan Keluarga Berencana merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pengendalian penduduk, keluarga berencana, serta pembangunan keluarga sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi program pengendalian laju pertumbuhan penduduk, peningkatan kualitas keluarga, dan pemenuhan hak reproduksi secara bertanggung jawab. Pelaksanaan tugas tersebut mencakup penyelenggaraan pelayanan keluarga berencana, kesehatan reproduksi, ketahanan dan kesejahteraan keluarga, serta penguatan peran keluarga dalam pembangunan sumber daya manusia.\r\n\r\nSelain itu, Dinas Pengendalian Penduduk dan Keluarga Berencana juga menyelenggarakan pengelolaan data dan informasi kependudukan, advokasi dan edukasi program Bangga Kencana, serta pengembangan kemitraan dengan perangkat daerah, fasilitas kesehatan, lembaga masyarakat, dan pemangku kepentingan lainnya guna mewujudkan penduduk yang tumbuh seimbang, keluarga yang berkualitas, dan pembangunan daerah yang berkelanjutan.	2026-06-16 00:29:26.688242	active	organization	approved	2026-06-16-002926.679925dpkkb.jpg	t	{}
26cd21d1-36aa-4c2f-ba25-29a14abadf5c	dinas-pendidikan-dan-kebudayaan	Dinas Pendidikan dan Kebudayaan	Dinas Pendidikan dan Kebudayaan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pendidikan dan kebudayaan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pembangunan pendidikan yang meliputi pengelolaan pendidikan anak usia dini (PAUD), pendidikan dasar, dan pendidikan nonformal. Hal ini mencakup peningkatan aksesibilitas, pemerataan, dan kualitas mutu pendidikan, pemenuhan sarana dan prasarana sekolah, serta pembinaan dan pengembangan pendidik dan tenaga kependidikan. Di bidang kebudayaan, dinas bertanggung jawab dalam pelestarian, perlindungan, pengembangan, dan pemanfaatan adat istiadat, sejarah, cagar budaya, serta kesenian tradisional berbasis kearifan lokal.\r\n\r\nSelain itu, Dinas Pendidikan dan Kebudayaan juga menyelenggarakan pengelolaan data dan informasi pendidikan (seperti Data Pokok Pendidikan/Dapodik), fasilitasi akreditasi dan sertifikasi, serta pembinaan nilai-nilai karakter dan literasi bagi peserta didik. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, institusi pendidikan tinggi, dewan kesenian, komunitas budaya, serta pemangku kepentingan lainnya guna mendorong terciptanya ekosistem pendidikan yang unggul dan pemajuan kebudayaan yang berkelanjutan.	2026-06-16 00:32:41.226204	active	organization	approved	2026-06-16-003241.220394pendidikan.png	t	{}
da4f8861-b8dc-486b-bac6-d1b7d8597132	dinas-penanaman-modal-dan-pelayanan-terpadu-satu-pintu	Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu	Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang penanaman modal serta penyelenggaraan pelayanan perizinan dan nonperizinan secara terpadu satu pintu sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pelayanan perizinan dan nonperizinan yang transparan, cepat, mudah, dan akuntabel. Selain itu, DPMPTSP juga bertanggung jawab dalam fasilitasi dan promosi penanaman modal, peningkatan iklim investasi, pendampingan pelaku usaha, serta pengendalian dan pemantauan realisasi investasi di daerah.\r\n\r\nDalam menjalankan tugas dan fungsinya, Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu mengintegrasikan layanan perizinan berbasis sistem elektronik, melakukan koordinasi lintas sektor dengan perangkat daerah dan instansi terkait, serta menjalin kemitraan dengan dunia usaha dan pemangku kepentingan lainnya guna mendorong pertumbuhan investasi dan peningkatan pelayanan publik yang berkualitas.	2026-06-16 00:34:57.35532	active	organization	approved	2026-06-16-003457.349338modal.png	t	{}
fdbc68bf-00db-4644-8889-0d7b614c64d0	dinas-pemuda-dan-olahraga	Dinas Pemuda dan Olahraga	Dinas Pemuda dan Olahraga merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang kepemudaan dan keolahragaan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengembangan potensi pemuda melalui peningkatan kapasitas, kreativitas, kewirausahaan, dan peran serta pemuda dalam pembangunan daerah. Di bidang olahraga, dinas bertanggung jawab dalam pembinaan olahraga pendidikan, olahraga prestasi, dan olahraga rekreasi, serta pengelolaan sarana dan prasarana olahraga yang memadai dan berkelanjutan.\r\n\r\nDalam menjalankan tugas dan fungsinya, Dinas Pemuda dan Olahraga menjalin kerja sama lintas sektor dengan perangkat daerah, organisasi kepemudaan dan keolahragaan, dunia pendidikan, serta pemangku kepentingan lainnya guna mewujudkan pemuda yang berkarakter, berdaya saing, dan masyarakat yang sehat, aktif, serta berprestasi.	2026-06-16 00:36:21.078466	active	organization	approved	2026-06-16-003621.071558LambangKotaKendari.webp	t	{}
816b2c2f-2628-4623-89ed-d5129fb26772	dinas-pemberdayaan-perempuan-dan-perlindungan-anak	Dinas Pemberdayaan Perempuan dan Perlindungan Anak	Dinas Pemberdayaan Perempuan dan Perlindungan Anak merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pemberdayaan perempuan, perlindungan anak, pemenuhan hak anak, serta perlindungan khusus perempuan dan anak sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, koordinasi, pembinaan, serta pengawasan program yang bertujuan untuk meningkatkan kualitas hidup perempuan, mewujudkan kesetaraan dan keadilan gender, serta menjamin terpenuhinya hak-hak anak agar dapat tumbuh dan berkembang secara optimal, terlindungi dari segala bentuk kekerasan, eksploitasi, dan diskriminasi.\r\n\r\nDalam pelaksanaan tugasnya, Dinas Pemberdayaan Perempuan dan Perlindungan Anak menyelenggarakan fungsi perencanaan, pelaksanaan, monitoring, evaluasi, serta fasilitasi layanan dan kerja sama lintas sektor dengan instansi pemerintah, lembaga masyarakat, dunia usaha, dan pemangku kepentingan lainnya guna mendukung terwujudnya pembangunan yang responsif gender dan ramah anak.	2026-06-16 00:37:52.305762	active	organization	approved	2026-06-16-003752.299202anak.png	t	{}
9204456e-3ec2-4264-bd02-156c703423bd	dinas-pariwisata-dan-ekonomi-kreatif	Dinas Pariwisata dan Ekonomi Kreatif	Dinas Pariwisata dan Ekonomi Kreatif merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pariwisata dan ekonomi kreatif sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pembangunan destinasi dan pemasaran pariwisata yang meliputi pengembangan daya tarik wisata, pengelolaan kawasan strategis pariwisata, peningkatan sarana prasarana wisata, serta promosi pariwisata daerah. Di bidang ekonomi kreatif, dinas bertanggung jawab dalam pengembangan, pembinaan, dan fasilitasi subsektor ekonomi kreatif potensial—seperti kriya, kuliner, fashion, aplikasi, hingga seni pertunjukan—melalui peningkatan daya saing, inovasi, dan hilirisasi produk kreatif berbasis kearifan lokal.\r\n\r\nSelain itu, Dinas Pariwisata dan Ekonomi Kreatif juga menyelenggarakan pengelolaan data dan informasi kepariwisataan serta ekraf, fasilitasi standardisasi dan sertifikasi usaha (CHSE/industri pariwisata), serta pembinaan kapasitas SDM pariwisata dan pelaku kreatif. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, asosiasi perhotelan dan perjalanan, komunitas kreatif, dunia usaha, serta pemangku kepentingan lainnya guna mendorong pertumbuhan investasi, penciptaan lapangan kerja, dan pembangunan pariwisata yang berkelanjutan.	2026-06-16 00:41:00.338347	active	organization	approved	2026-06-16-004100.332986ekonomi.png	t	{}
c8f2a74f-5b7f-4f9a-ae8d-41f111ffb6ce	dinas-ketahanan-pangan	Dinas Ketahanan Pangan	Dinas Ketahanan Pangan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang ketahanan pangan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Ketahanan Pangan berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan ketahanan pangan daerah yang mencakup ketersediaan, keterjangkauan, keamanan, dan stabilitas pangan. Pelaksanaan tugas tersebut dilakukan melalui penguatan sistem produksi dan distribusi pangan, pengendalian kerawanan pangan, serta pengawasan mutu dan keamanan pangan.\r\n\r\nSelain itu, Dinas Ketahanan Pangan juga menyelenggarakan pengelolaan data dan informasi pangan, pelaksanaan pemantauan dan evaluasi kondisi pangan daerah, diversifikasi konsumsi pangan berbasis potensi lokal, serta edukasi dan pemberdayaan masyarakat. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, pelaku usaha, dan pemangku kepentingan lainnya guna mewujudkan ketahanan pangan daerah yang mandiri, berkelanjutan, dan berkeadilan.	2026-06-16 00:42:56.713695	active	organization	approved	2026-06-16-004256.706879pangan.png	t	{}
18807f8c-eb71-4588-a2f8-fc569c46fb39	dinas-lingkungan-hidup	Dinas Lingkungan Hidup	Dinas Lingkungan Hidup dan Kebersihan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang perlindungan dan pengelolaan lingkungan hidup serta kebersihan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi upaya pelestarian lingkungan hidup yang mencakup pengendalian pencemaran dan kerusakan lingkungan, pengelolaan persampahan dan kebersihan, penataan ruang terbuka hijau, serta peningkatan kualitas lingkungan permukiman. Pelaksanaan tugas tersebut dilakukan dengan memperhatikan prinsip pembangunan berkelanjutan dan kelestarian lingkungan.\r\n\r\nSelain itu, Dinas Lingkungan Hidup dan Kebersihan juga menyelenggarakan pengelolaan data dan informasi lingkungan, pelaksanaan penilaian dan pengawasan kepatuhan lingkungan, serta edukasi dan partisipasi masyarakat dalam menjaga kebersihan dan kelestarian lingkungan. Dalam menjalankan tugas dan fungsinya, dinas menjalin kerja sama lintas sektor dengan perangkat daerah, dunia usaha, dan masyarakat guna mewujudkan lingkungan yang bersih, sehat, dan berkelanjutan.	2026-06-16 00:44:31.901753	active	organization	approved	2026-06-16-004431.895934hidup.png	t	{}
3ed47057-c11e-4762-8e7e-cf6da022d47d	dinas-kesehatan	Dinas Kesehatan	Dinas Kesehatan merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang kesehatan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Kesehatan berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan pembangunan kesehatan yang bertujuan untuk meningkatkan derajat kesehatan masyarakat secara optimal, merata, dan berkelanjutan. Pelaksanaan tugas tersebut mencakup upaya promotif, preventif, kuratif, dan rehabilitatif melalui pelayanan kesehatan yang bermutu, terjangkau, dan berkeadilan.\r\n\r\nSelain itu, Dinas Kesehatan juga menyelenggarakan pengelolaan sumber daya kesehatan, peningkatan kualitas fasilitas dan tenaga kesehatan, pengendalian penyakit dan penyehatan lingkungan, serta penguatan sistem kesehatan daerah. Dalam menjalankan fungsinya, Dinas Kesehatan melakukan kerja sama lintas sektor dengan perangkat daerah, fasilitas pelayanan kesehatan, dunia usaha, dan pemangku kepentingan lainnya guna mewujudkan masyarakat yang sehat, produktif, dan sejahtera.	2026-06-16 00:48:34.154203	active	organization	approved	2026-06-16-004834.148446kesehatan-1.png	t	{}
a613f382-2484-41d1-9ba4-1f1e0ad54d2b	dinas-kependudukan-dan-catatan-sipil	Dinas Kependudukan dan Catatan Sipil	Dinas Kependudukan dan Pencatatan Sipil merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang administrasi kependudukan dan pencatatan sipil sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan pelayanan administrasi kependudukan dan pencatatan sipil yang meliputi pendaftaran penduduk, penerbitan dokumen kependudukan, serta pencatatan peristiwa penting dan peristiwa kependudukan. Pelaksanaan tugas tersebut bertujuan untuk mewujudkan tertib administrasi kependudukan dan memberikan kepastian hukum atas status kependudukan masyarakat.\r\n\r\nSelain itu, Dinas Kependudukan dan Pencatatan Sipil juga menyelenggarakan pengelolaan dan pemanfaatan data kependudukan, pengembangan sistem informasi administrasi kependudukan, serta peningkatan kualitas pelayanan publik yang cepat, akurat, dan transparan. Dalam menjalankan tugas dan fungsinya, dinas melakukan kerja sama lintas sektor dengan perangkat daerah dan instansi terkait guna mendukung perencanaan pembangunan dan pelayanan publik berbasis data kependudukan yang valid dan terintegrasi.	2026-06-16 00:50:25.842994	active	organization	approved	2026-06-16-005140.187796logo-dukcapil-1773470192-1.jpg	t	{}
9e5ac50f-b372-495d-84ee-24ab09898742	dinas-damkar-dan-penyelamatan	Dinas Damkar dan Penyelamatan	Dinas Kebakaran merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pencegahan dan penanggulangan kebakaran, serta penyelamatan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas ini berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi upaya pencegahan, penanggulangan, dan penanganan pascakebakaran. Pelaksanaan tugas tersebut mencakup pelayanan pemadaman kebakaran, operasi penyelamatan dalam kondisi darurat, inspeksi dan pengawasan sistem proteksi kebakaran, serta edukasi dan sosialisasi keselamatan kebakaran kepada masyarakat.\r\n\r\nSelain itu, Dinas Pemadam Kebakaran juga menyelenggarakan peningkatan kapasitas sumber daya manusia, pengelolaan sarana dan prasarana pemadam kebakaran, serta penguatan sistem respons darurat yang cepat, tepat, dan terkoordinasi. Dalam menjalankan fungsinya, dinas melakukan kerja sama lintas sektor dengan perangkat daerah, aparat keamanan, dunia usaha, dan masyarakat guna mewujudkan lingkungan yang aman, tangguh, dan siap menghadapi risiko kebakaran dan keadaan darurat lainnya.	2026-06-16 00:53:12.453444	active	organization	approved	2026-06-16-005312.448199LOGO-DAMKAR.png	t	{}
38ccfafb-fd19-496d-9834-a8556f46f67b	dinas-pertanian	Dinas Pertanian	Dinas Pertanian merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan urusan pemerintahan di bidang pertanian sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nDinas Pertanian berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan dan pengembangan sektor pertanian yang meliputi tanaman pangan, hortikultura, perkebunan, serta peternakan dan kesehatan hewan. Pelaksanaan tugas tersebut bertujuan untuk meningkatkan produktivitas, ketahanan pangan, nilai tambah hasil pertanian, serta kesejahteraan petani dan pelaku usaha pertanian.\r\n\r\nSelain itu, Dinas Pertanian juga menyelenggarakan pengelolaan sumber daya pertanian secara berkelanjutan, peningkatan kapasitas petani melalui penyuluhan dan pendampingan, pengendalian hama dan penyakit, serta pengembangan sarana dan prasarana pertanian. Dalam menjalankan tugas dan fungsinya, Dinas Pertanian menjalin kerja sama lintas sektor dengan perangkat daerah, instansi terkait, dunia usaha, dan masyarakat guna mewujudkan sektor pertanian yang maju, mandiri, dan berdaya saing.	2026-06-16 00:54:14.700614	active	organization	approved	2026-06-16-005414.695419LogoKementerianPertanianRepublikIndonesia.svg.png	t	{}
64ea4800-881b-4464-8b50-4a934a755391	badan-penanggulangan-bencana-daerah	Badan Penanggulangan Bencana Daerah	Badan Penanggulangan Bencana Daerah merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang penanggulangan bencana sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBPBD berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penyelenggaraan penanggulangan bencana yang meliputi tahap pencegahan dan mitigasi, kesiapsiagaan, tanggap darurat, serta rehabilitasi dan rekonstruksi. Pelaksanaan tugas tersebut bertujuan untuk mengurangi risiko bencana, melindungi masyarakat, serta memulihkan kondisi pascabencana secara cepat dan berkelanjutan.\r\n\r\nSelain itu, Badan Penanggulangan Bencana Daerah juga menyelenggarakan pemetaan dan pengelolaan data risiko bencana, pengembangan sistem peringatan dini, peningkatan kapasitas aparatur dan masyarakat, serta koordinasi lintas sektor dengan perangkat daerah, instansi vertikal, dunia usaha, dan masyarakat. Dalam menjalankan tugas dan fungsinya, BPBD mengedepankan prinsip koordinasi, keterpaduan, dan partisipasi masyarakat guna mewujudkan daerah yang tangguh terhadap bencana.	2026-06-16 02:59:08.809039	active	organization	approved	2026-06-16-025908.795048bpbd.png	t	{}
ff4546ef-4428-4a60-9daa-f6582f8c1b07	badan-perencanaan-pembangunan-daerah	Badan Perencanaan Pembangunan Daerah	Badan Perencanaan Pembangunan Daerah merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang perencanaan pembangunan daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBappeda berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengoordinasian, serta pengendalian perencanaan pembangunan daerah yang meliputi penyusunan dokumen perencanaan jangka panjang, jangka menengah, dan tahunan. Pelaksanaan tugas tersebut mencakup integrasi perencanaan lintas sektor dan wilayah, sinkronisasi perencanaan pusat dan daerah, serta penguatan perencanaan berbasis data dan evidence-based policy.\r\n\r\nSelain itu, Badan Perencanaan Pembangunan Daerah juga menyelenggarakan pemantauan, evaluasi, dan pengendalian pelaksanaan pembangunan daerah, pengelolaan data dan sistem informasi perencanaan, serta fasilitasi partisipasi masyarakat melalui mekanisme perencanaan pembangunan partisipatif. Dalam menjalankan tugas dan fungsinya, Bappeda melakukan koordinasi dengan perangkat daerah dan pemangku kepentingan lainnya guna mewujudkan perencanaan pembangunan daerah yang terarah, terpadu, dan berkelanjutan.	2026-06-16 03:01:16.681464	active	organization	approved	2026-06-16-030116.665675LambangKotaKendari.webp	t	{}
dba1556d-5013-4863-bbd6-62dd6f3ec845	badan-pendapatan-daerah	Badan Pendapatan Daerah	Badan Pendapatan Daerah merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang pengelolaan pendapatan daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBapenda berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan pendapatan daerah yang meliputi perencanaan, pemungutan, penatausahaan, dan pengendalian pendapatan asli daerah (PAD) serta sumber pendapatan daerah lainnya. Pelaksanaan tugas tersebut bertujuan untuk meningkatkan kemandirian fiskal daerah melalui optimalisasi potensi pendapatan yang efektif, efisien, dan berkeadilan.\r\n\r\nSelain itu, Badan Pendapatan Daerah juga menyelenggarakan pengelolaan data dan informasi perpajakan dan retribusi daerah, peningkatan kualitas pelayanan kepada wajib pajak, serta pengembangan sistem pemungutan pendapatan berbasis teknologi informasi. Dalam menjalankan tugas dan fungsinya, Bapenda menjalin koordinasi dengan perangkat daerah dan pemangku kepentingan lainnya guna mewujudkan pengelolaan pendapatan daerah yang transparan, akuntabel, dan berkelanjutan.	2026-06-16 03:02:36.661802	active	organization	approved	2026-06-16-030236.644696LambangKotaKendari.webp	t	{}
71f36199-1137-4540-8939-9f9ea35fe879	badan-keuangan-dan-aset-daerah	Badan Keuangan dan Aset Daerah	Badan Keuangan dan Aset Daerah merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang pengelolaan keuangan daerah dan pengelolaan barang milik daerah/aset daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBPKAD berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan keuangan daerah yang meliputi perencanaan dan penganggaran, pelaksanaan anggaran, penatausahaan, akuntansi, pelaporan, dan pertanggungjawaban keuangan daerah. Selain itu, BPKAD juga bertanggung jawab dalam pengelolaan aset daerah secara tertib, efektif, efisien, dan akuntabel guna mendukung penyelenggaraan pemerintahan dan pelayanan publik.\r\n\r\nDalam menjalankan tugas dan fungsinya, Badan Pengelola Keuangan dan Aset Daerah menyelenggarakan pengelolaan kas daerah, penatausahaan barang milik daerah, pengamanan dan pemanfaatan aset, serta pengembangan sistem informasi keuangan dan aset daerah. Pelaksanaan tugas dilakukan melalui koordinasi dengan perangkat daerah dan pemangku	2026-06-16 03:05:13.763871	active	organization	approved	2026-06-16-030739.515400GeminiGeneratedImagew3g63tw3g63tw3g6.webp	t	{}
f16105b8-7bd2-42e8-9274-c10b7daf3d16	badan-kesatuan-bangsa-dan-politik	Badan Kesatuan Bangsa dan Politik	Badan Kesatuan Bangsa dan Politik merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang kesatuan bangsa, politik dalam negeri, serta kewaspadaan nasional sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBakesbangpol berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pembinaan ideologi Pancasila, wawasan kebangsaan, serta pemeliharaan persatuan dan kesatuan bangsa. Pelaksanaan tugas tersebut mencakup fasilitasi pendidikan politik masyarakat, pembinaan kehidupan demokrasi, serta penguatan stabilitas politik dan keamanan daerah.\r\n\r\nSelain itu, Badan Kesatuan Bangsa dan Politik juga menyelenggarakan pemantauan dan evaluasi kondisi sosial politik daerah, penguatan kewaspadaan dini dan penanganan potensi konflik, serta pembinaan dan fasilitasi organisasi kemasyarakatan dan partai politik sesuai kewenangan daerah. Dalam menjalankan tugas dan fungsinya, Bakesbangpol melakukan koordinasi lintas sektor dengan perangkat daerah, aparat keamanan, dan pemangku kepentingan lainnya guna mewujudkan kondisi daerah yang aman, stabil, dan kondusif bagi pembangunan.	2026-06-16 03:07:23.905474	active	organization	approved	2026-06-16-030851.417179kesbangpol.jpg	t	{}
5b7462b1-e8fb-4c95-bcde-7af2cca6e9dc	badan-kepegawaian-dan-pengembangan-sumber-daya-manusia	Badan Kepegawaian dan Pengembangan Sumber Daya Manusia	Badan Kepegawaian dan Pengembangan Sumber Daya Manusia merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam melaksanakan fungsi penunjang urusan pemerintahan di bidang manajemen kepegawaian dan pengembangan sumber daya manusia aparatur sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBKPSDM berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi pengelolaan aparatur sipil negara yang meliputi perencanaan kebutuhan pegawai, pengadaan, mutasi, promosi, pengembangan karier, penilaian kinerja, serta pembinaan disiplin dan kesejahteraan pegawai. Selain itu, BKPSDM juga bertanggung jawab dalam perencanaan dan pelaksanaan pengembangan kompetensi aparatur melalui pendidikan dan pelatihan yang terarah dan berkelanjutan.\r\n\r\nDalam menjalankan tugas dan fungsinya, Badan Kepegawaian dan Pengembangan Sumber Daya Manusia menyelenggarakan pengelolaan data dan sistem informasi kepegawaian, penguatan manajemen talenta, serta peningkatan profesionalisme aparatur. Pelaksanaan tugas dilakukan melalui koordinasi dengan perangkat daerah dan pemangku kepentingan lainnya guna mewujudkan aparatur yang kompeten, berintegritas, dan berdaya saing dalam mendukung penyelenggaraan pemerintahan dan pelayanan publik	2026-06-16 03:10:17.284107	active	organization	approved	2026-06-16-031017.270745LambangKotaKendari.webp	t	{}
383c2230-9f10-4d12-a2c2-54ad9d9ccf24	satuan-polisi-pamong-praja	Satuan Polisi Pamong Praja	Satuan Polisi Pamong Praja merupakan perangkat daerah yang mempunyai tugas membantu Kepala Daerah dalam menegakkan Peraturan Daerah dan Peraturan Kepala Daerah, menyelenggarakan ketertiban umum dan ketenteraman masyarakat, serta memberikan perlindungan kepada masyarakat sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nSatpol PP berperan dalam perumusan dan pelaksanaan kebijakan, pembinaan, pengawasan, serta koordinasi penegakan peraturan daerah dan penyelenggaraan ketertiban umum. Pelaksanaan tugas tersebut mencakup kegiatan penertiban, pengawasan, penindakan nonyustisial, pengamanan kegiatan pemerintah daerah, serta penanganan gangguan ketenteraman dan ketertiban umum di wilayah daerah.\r\n\r\nSelain itu, Satuan Polisi Pamong Praja juga menyelenggarakan peningkatan kapasitas sumber daya aparatur, penguatan sarana dan prasarana operasional, serta kerja sama lintas sektor dengan perangkat daerah, aparat penegak hukum, dan masyarakat. Dalam menjalankan fungsinya, Satpol PP mengedepankan pendekatan humanis, persuasif, dan berkeadilan guna mewujudkan lingkungan daerah yang tertib, aman, dan kondusif.	2026-06-16 03:11:24.265266	active	organization	approved	2026-06-16-031124.244314LambangKotaKendari.webp	t	{}
351749bf-9847-4991-8012-6c820f7d083f	bagian-administrasi-pembangunan-setda	Bagian Administrasi Pembangunan Setda	Bagian Administrasi Pembangunan Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Perekonomian dan Pembangunan dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang administrasi pembangunan sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengoordinasian program, pemantauan, serta evaluasi terhadap pelaksanaan pembangunan daerah. Ruang lingkup tugasnya meliputi penyusunan program pembangunan, pengendalian program (monitoring dan evaluasi capaian fisik serta keuangan), penyerapan anggaran, hingga pelaporan berkala atas pelaksanaan Rencana Pembangunan Jangka Menengah Daerah (RPJMD) dan Rencana Kerja Pemerintah Daerah (RKPD). Selain itu, bagian ini bertanggung jawab dalam fasilitasi percepatan pembangunan proyek strategis daerah dan koordinasi pengadaan barang/jasa pemerintah.\r\n\r\nSelain itu, Bagian Administrasi Pembangunan Setda juga menyelenggarakan pengelolaan sistem data dan informasi administrasi pembangunan (seperti aplikasi pelaporan e-Monev), fasilitasi penyelesaian hambatan (bottlenecking) pelaksanaan proyek fisik, serta penyusunan laporan akuntabilitas kinerja instansi pemerintah (LKjIP) di lingkup sekretariat daerah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan seluruh perangkat daerah, instansi vertikal, serta pemangku kepentingan terkait guna mendorong terciptanya tata kelola pembangunan yang transparan, akuntabel, tepat waktu, dan berkelanjutan.	2026-06-16 03:12:52.883752	active	organization	approved	2026-06-16-031252.866983LambangKotaKendari.webp	t	{}
5abe93fc-1e2a-4058-9a6e-d4fdc66ca76d	bagian-hukum-dan-ham-setda	Bagian Hukum dan HAM Setda	Bagian Hukum dan Hak Asasi Manusia (HAM) Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Pemerintahan dan Kesejahteraan Rakyat dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang hukum dan perundang-undangan serta pemajuan hak asasi manusia sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengkajian, harmonisasi, dan penyusunan produk hukum daerah seperti Rancangan Peraturan Daerah (Raperda) dan Rancangan Peraturan Kepala Daerah (Raperkada). Ruang lingkup tugasnya meliputi pemberian bantuan hukum, pendapat hukum (legal opinion), dan advokasi atas sengketa hukum yang dihadapi oleh pemerintah daerah dan aparatur sipil negara. Di bidang HAM, bagian ini bertanggung jawab dalam pengoordinasian, fasilitasi, dan pelaporan Rencana Aksi Nasional Hak Asasi Manusia (RANHAM) serta pemenuhan kriteria kabupaten/kota peduli HAM.\r\n\r\nSelain itu, Bagian Hukum dan HAM Setda juga menyelenggarakan pengelolaan Dokumentasi dan Informasi Hukum melalui sistem Jaringan Dokumentasi dan Informasi Hukum (JDIH), fasilitasi penyuluhan dan sosialisasi produk hukum kepada masyarakat, serta evaluasi dan pengawasan terhadap implementasi peraturan di tingkat daerah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan seluruh perangkat daerah, instansi vertikal (seperti Kementerian Hukum dan HAM), lembaga peradilan, serta pemangku kepentingan terkait guna mendorong terciptanya kepastian hukum, tertib administrasi, dan penegakan prinsip-prinsip HAM yang berkelanjutan.	2026-06-16 03:13:29.361217	active	organization	approved	2026-06-16-031329.344144LambangKotaKendari.webp	t	{}
b8f22f98-21bf-4ff3-be0c-82aebb6bf9c6	bagian-kerjasama-setda	Bagian Kerjasama Setda	Bagian Kerja Sama Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Pemerintahan dan Kesejahteraan Rakyat (atau Asisten Perekonomian dan Pembangunan, menyesuaikan tata kerja daerah) dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang fasilitasi dan pemantauan kerja sama daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengkajian, penyiapan, dan penyusunan administrasi dokumen kerja sama formal, baik berupa Nota Kesepahaman (MoU) maupun Perjanjian Kerja Sama (PKS). Ruang lingkup tugasnya meliputi pemetaan potensi kerja sama, fasilitasi perundingan antarpihak, serta koordinasi pelaksanaan kerja sama daerah yang mencakup kerja sama antar-daerah (KSDD), kerja sama dengan pihak ketiga (KSDPK) seperti dunia usaha, serta kerja sama dengan lembaga atau pemerintah di luar negeri (KSDPL).\r\n\r\nSelain itu, Bagian Kerja Sama Setda juga menyelenggarakan pemantauan, evaluasi, dan pelaporan berkala terhadap efektivitas serta dampak dari dokumen kerja sama yang telah disepakati, serta pengelolaan sistem data dan informasi kemitraan daerah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan seluruh perangkat daerah, badan usaha (BUMD/swasta), institusi pendidikan, organisasi non-pemerintah, serta pemangku kepentingan lainnya guna mendorong percepatan pembangunan, peningkatan pelayanan publik, dan kesejahteraan masyarakat yang berkelanjutan.	2026-06-16 03:13:59.278285	active	organization	approved	2026-06-16-031359.268364LambangKotaKendari.webp	t	{}
893840e4-47ab-4d33-8f18-b973184e4ff7	bagian-keuangan-setda	Bagian Keuangan Setda	Bagian Keuangan Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Administrasi Umum dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang pengelolaan keuangan lingkup sekretariat daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis serta pengoordinasian perencanaan, penganggaran, penatausahaan, pencatatan, dan pelaporan keuangan. Ruang lingkup tugasnya meliputi penyusunan Rencana Kerja dan Anggaran (RKA) serta Dokumen Pelaksanaan Anggaran (DPA) Sekretariat Daerah, pengujian atas tagihan belanja, penerbitan Surat Perintah Membayar (SPM), hingga pengelolaan kas dan pembayaran gaji serta tunjangan aparatur sipil negara di lingkungan Setda.\r\n\r\nSelain itu, Bagian Keuangan Setda juga menyelenggarakan akuntansi keuangan, penyusunan laporan keuangan berkala (Laporan Realisasi Anggaran, Neraca, dan Catatan atas Laporan Keuangan), serta fasilitasi penyelesaian tindak lanjut hasil pemeriksaan aparat pengawas fungsional (seperti Inspektorat atau BPK). Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan Badan Pengelola Keuangan dan Aset Daerah (BPKAD), instansi perbankan, serta seluruh bagian di lingkungan sekretariat daerah guna mendorong terciptanya tata kelola keuangan yang tertib, transparan, akuntabel, dan taat pada peraturan perundang-undangan.	2026-06-16 03:15:24.482942	active	organization	approved	2026-06-16-031524.466521LambangKotaKendari.webp	t	{}
318d1db3-6db7-4045-8e7f-f33c6d439b8a	bagian-organisasi-setda	Bagian Organisasi Setda	Bagian Organisasi Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Administrasi Umum dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang kelembagaan, tatalaksana, dan akuntabilitas kinerja aparatur sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, penataan, dan evaluasi kelembagaan perangkat daerah guna mewujudkan struktur organisasi pemerintah yang tepat fungsi dan tepat ukuran (right-sizing). Ruang lingkup tugasnya meliputi penyusunan instrumen tatalaksana kerja (seperti Standar Operasional Prosedur/SOP, analisis jabatan/ANJAB, analisis beban kerja/ABK, dan evaluasi jabatan), serta pengoordinasian pelaksanaan reformasi birokrasi, pemantauan indeks pelayanan publik, dan penerapan zona integritas di lingkungan pemerintah daerah.\r\n\r\nSelain itu, Bagian Organisasi Setda juga menyelenggarakan pengoordinasian dan penyusunan dokumen Sistem Akuntabilitas Kinerja Instansi Pemerintah (SAKIP), yang mencakup Laporan Kinerja Instansi Pemerintah (LKjIP) serta Perjanjian Kinerja (PK) kepala daerah dan perangkat daerah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan Badan Kepegawaian dan Pengembangan SDM (BKPSDM), Inspektorat Daerah, Kementerian PANRB, serta seluruh unit kerja terkait guna mendorong terciptanya tata kelola pemerintahan yang efektif, efisien, profesional, dan berorientasi pada pelayanan publik yang berkualitas.	2026-06-16 03:15:55.227902	active	organization	approved	2026-06-16-031555.211954LambangKotaKendari.webp	t	{}
a472e665-935d-4c9a-96ef-a280700a3d0b	bagian-pengadaan-barang-dan-jasa-setda	Bagian Pengadaan Barang dan Jasa Setda	Bagian Pengadaan Barang dan Jasa Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Perekonomian dan Pembangunan dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang pembinaan dan pelaksanaan pengadaan barang/jasa sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan sebagai Unit Kerja Pengadaan Barang/Jasa (UKPBJ) yang menjadi pusat keunggulan (Center of Excellence) pengadaan di tingkat daerah. Ruang lingkup tugasnya meliputi pelaksanaan pengadaan barang/jasa pemerintah mulai dari perencanaan, pemilihan penyedia (tender/seleksi), reviu dokumen persiapan pengadaan, hingga pengelolaan kontrak strategis. Selain itu, bagian ini bertanggung jawab dalam pembinaan personel dan kelembagaan pengadaan, serta pendampingan teknis bagi seluruh perangkat daerah dalam mengeksekusi anggaran belanja modal secara akuntabel.\r\n\r\nSelain itu, Bagian Pengadaan Barang dan Jasa Setda juga menyelenggarakan pengelolaan dan pembinaan terhadap Layanan Pengadaan Secara Elektronik (LPSE), fasilitasi pemanfaatan sistem pengadaan digital (seperti e-Katalog Lokal, SIRUP, dan Toko Daring), serta mitigasi risiko sengketa hukum pengadaan. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan Lembaga Kebijakan Pengadaan Barang/Jasa Pemerintah (LKPP), Inspektorat Daerah, pelaku usaha/asosiasi, serta seluruh perangkat daerah guna mendorong proses pengadaan yang kredibel, transparan, efektif, efisien, dan berorientasi pada peningkatan penggunaan produk dalam negeri (PDN).	2026-06-16 03:16:34.03424	active	organization	approved	2026-06-16-031634.016288LambangKotaKendari.webp	t	{}
1f54d9d5-a146-4213-9f67-649db9f3029f	bagian-perekonomian-setda	Bagian Perekonomian Setda	Bagian Perekonomian Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Perekonomian dan Pembangunan dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang pembinaan perekonomian, pengendalian inflasi, serta optimalisasi sumber daya ekonomi daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengkajian, dan pengoordinasian program peningkatan ketahanan ekonomi daerah. Ruang lingkup tugasnya meliputi pemantauan stabilitas harga dan ketersediaan bahan pokok melalui fasilitasi Tim Pengendali Inflasi Daerah (TPID), pengembangan ekonomi makro dan sektor riil, pembinaan usaha mikro, kecil, dan menengah (UMKM), serta koordinasi peningkatan investasi dan kemitraan ekonomi. Selain itu, bagian ini bertanggung jawab dalam pembinaan, pengawasan kinerja, dan pelaporan tata kelola Badan Usaha Milik Daerah (BUMD) serta Badan Layanan Umum Daerah (BLUD).\r\n\r\nSelain itu, Bagian Perekonomian Setda juga menyelenggarakan pengelolaan data dan informasi perekonomian daerah, fasilitasi akses pembiayaan dan perbankan bagi pelaku usaha, serta evaluasi terhadap kebijakan stimulus ekonomi lokal. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan Bank Indonesia, Dinas Perindustrian dan Perdagangan, Dinas Koperasi dan UMKM, kalangan dunia usaha/perbankan, serta pemangku kepentingan terkait guna mendorong pertumbuhan ekonomi yang inklusif, berdaya saing, dan berkelanjutan.	2026-06-16 03:17:04.846935	active	organization	approved	2026-06-16-031704.834737LambangKotaKendari.webp	t	{}
625c0767-2822-425a-9895-c1fe1dad575f	bagian-protokol-dan-komunikasi-pimpinan-setda	Bagian Protokol dan Komunikasi Pimpinan Setda	Bagian Protokol dan Komunikasi Pimpinan (Prokopim) Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Administrasi Umum (atau Asisten Pemerintahan, menyesuaikan tata kerja daerah) dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang keprotokolan, komunikasi pimpinan, dan dokumentasi sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan penting dalam menjaga citra, kelancaran jalannya roda birokrasi, serta komunikasi publik dari unsur pimpinan daerah (Kepala Daerah dan Wakil Kepala Daerah). Ruang lingkup tugasnya meliputi pengaturan tata tempat, tata upacara, dan tata penghormatan dalam acara resmi maupun semi resmi (keprotokolan), penjadwalan agenda kerja harian pimpinan, serta fasilitasi penyusunan naskah sambutan atau pidato pimpinan.\r\n\r\nSelain itu, Bagian Prokopim Setda juga menyelenggarakan peliputan, dokumentasi audio-visual, dan penyusunan rilis berita terkait kegiatan pimpinan untuk dipublikasikan kepada media massa maupun kanal resmi pemerintah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan Dinas Komunikasi dan Informatika (Kominfo), seluruh perangkat daerah, instansi vertikal, unsur Forkopimda, serta rekan media guna memastikan keterbukaan informasi, keselarasan publikasi, dan tata kelola acara pimpinan yang tertib, representatif, dan akuntabel.	2026-06-16 03:18:11.760916	active	organization	approved	2026-06-16-031811.745405LambangKotaKendari.webp	t	{}
ad9deaca-7d85-4439-bafe-10a64cb86a18	bagian-kesejahteraan-rakyat-setda	Bagian Kesejahteraan Rakyat Setda	Bagian Kesejahteraan Rakyat (Kesra) Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Pemerintahan dan Kesejahteraan Rakyat dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang keagamaan, kesejahteraan sosial, dan masyarakat sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengoordinasian program, serta fasilitasi pelayanan di bidang keagamaan, pembinaan mental spiritual, dan kesejahteraan sosial. Ruang lingkup tugasnya meliputi fasilitasi sarana peribadahan, penyelenggaraan kegiatan hari besar keagamaan, koordinasi urusan haji, serta pembinaan toleransi antarumat beragama. Di bidang kesejahteraan sosial, bagian ini bertanggung jawab dalam fasilitasi jaminan sosial, pengentasan kemiskinan, pemberdayaan masyarakat, serta pengoordinasian bantuan sosial bagi masyarakat yang membutuhkan atau terdampak bencana.\r\n\r\nSelain itu, Bagian Kesra Setda juga menyelenggarakan fasilitasi dan pembinaan terhadap lembaga kemasyarakatan, organisasi keagamaan, serta lembaga sosial non-pemerintah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan perangkat daerah teknis (seperti Dinas Sosial, Dinas Kesehatan, dan Dinas Pendidikan), Kementerian Agama, tokoh masyarakat, serta pemangku kepentingan terkait guna mendorong terciptanya kualitas hidup masyarakat yang sejahtera, religius, berbudaya, dan harmonis.	2026-06-16 03:14:46.824256	active	organization	approved	2026-06-16-031446.810094LambangKotaKendari.webp	t	{}
c0d0b525-30a4-407d-9b43-66ec11c0ace4	bagian-sumber-daya-alam-setda	Bagian Sumber Daya Alam Setda	Bagian Sumber Daya Alam (SDA) Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Perekonomian dan Pembangunan dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang optimalisasi, pemanfaatan, dan pelestarian sumber daya alam daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan dalam perumusan kebijakan teknis, pengoordinasian program, serta pemantauan terhadap pengelolaan kekayaan alam yang meliputi sektor pertanian, kehutanan, kelautan dan perikanan, serta energi dan sumber daya mineral (ESDM). Ruang lingkup tugasnya mencakup fasilitasi koordinasi kebijakan ketahanan pangan, konservasi lingkungan hidup, pemanfaatan potensi energi terbarukan, hingga pengawasan terhadap dampak lingkungan dari aktivitas pengelolaan sumber daya alam di wilayah daerah.\r\n\r\nSelain itu, Bagian SDA Setda juga menyelenggarakan pengelolaan data dan informasi potensi sumber daya alam daerah, fasilitasi penyelesaian konflik pemanfaatan ruang/lahan, serta pemantauan pemenuhan regulasi lingkungan oleh pelaku usaha. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan perangkat daerah teknis (seperti Dinas Pertanian, Dinas Lingkungan Hidup, Dinas Perikanan), instansi vertikal (Kementerian LHK, Kementerian ESDM), serta pemangku kepentingan terkait guna mendorong pengelolaan potensi alam yang berdaya guna, lestari, dan berwawasan lingkungan secara berkelanjutan.	2026-06-16 03:19:55.369123	active	organization	approved	2026-06-16-031955.353536LambangKotaKendari.webp	t	{}
6fb0939e-75f9-4f3f-8d04-3b986c864bea	bagian-umum-setda	Bagian Umum Setda	Bagian Umum Sekretariat Daerah (Setda) merupakan unit kerja yang mempunyai tugas membantu Asisten Administrasi Umum dalam menyusun kebijakan, mengoordinasikan, membina, dan mengendalikan pelaksanaan urusan pemerintahan di bidang pelayanan administrasi umum, perlengkapan, rumah tangga, dan kepersonaliaan lingkup sekretariat daerah sesuai dengan ketentuan peraturan perundang-undangan.\r\n\r\nBagian ini berperan sebagai urat nadi operasional internal internal sekretariat, yang bertanggung jawab atas kelancaran fasilitas kerja dan pelayanan domestik. Ruang lingkup tugasnya meliputi pengelolaan urusan rumah tangga (pemeliharaan gedung kantor, kebersihan, keamanan, dan penyediaan konsumsi), manajemen aset dan perlengkapan (perencanaan kebutuhan, pengadaan, pendistribusian, hingga inventarisasi barang milik daerah), serta pengelolaan kendaraan dinas operasional pimpinan dan sekretariat. Di bidang administrasi, bagian ini mengelola persuratan (tata usaha, ekspedisi, dan kearsipan) serta fasilitasi administrasi kepegawaian internal Setda.\r\n\r\nSelain itu, Bagian Umum Setda juga menyelenggarakan pengelolaan keuangan internal bagian, fasilitasi rapat-rapat koordinasi internal, serta koordinasi penerimaan kunjungan kerja tamu daerah. Dalam menjalankan tugas dan fungsinya, bagian ini menjalin kerja sama lintas sektor dengan seluruh bagian di lingkungan Setda, Badan Pengelola Keuangan dan Aset Daerah (BPKAD), Badan Kepegawaian dan Pengembangan SDM (BKPSDM), serta pihak ketiga penyedia jasa guna memastikan terciptanya lingkungan kerja yang aman, bersih, representatif, serta pelayanan administrasi internal yang cepat dan akuntabel.	2026-06-16 03:20:25.404238	active	organization	approved	2026-06-16-032025.389686LambangKotaKendari.webp	t	{}
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.member (id, group_id, table_id, state, table_name, capacity) FROM stdin;
12e7d0d5-9e27-4acc-aaa4-7ab7ac4f1702	5b7462b1-e8fb-4c95-bcde-7af2cca6e9dc	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
8914fb11-e0bf-4efa-b204-c109e2c33264	71ba2e16-6c79-4313-86e5-731b209fff31	f45d3f4c-fed7-4931-ae77-ad0dabc91162	deleted	user	admin
2f650b98-cf0d-446b-ada0-2729e8536de3	5b7462b1-e8fb-4c95-bcde-7af2cca6e9dc	94ac333d-b70b-4a73-803d-20ddd1b14873	active	user	editor
24c2d4d0-d8d7-4c4c-beb2-e76bd5b88b00	71ba2e16-6c79-4313-86e5-731b209fff31	b68d0318-8694-4411-a4ae-d9aa9bcdd5d2	active	user	editor
65fb43e1-daa6-49cd-8ccd-2009564b674b	f16105b8-7bd2-42e8-9274-c10b7daf3d16	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
46b4c04a-6f6d-4b5c-ab0e-08b2ece4e43a	71ba2e16-6c79-4313-86e5-731b209fff31	ae8481ec-9efd-44e2-8819-a649fb141ef2	active	user	editor
b87726b7-7203-41bf-a3c1-54ec9fb34711	f16105b8-7bd2-42e8-9274-c10b7daf3d16	975cd397-3b9f-444b-b605-e5ae65703085	active	user	editor
074b38a3-7dac-4c2e-964f-b9c9f89b3159	318d1db3-6db7-4045-8e7f-f33c6d439b8a	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
1eb0e0b5-a572-4b1a-9f07-943b495c3668	2fec2312-cfb4-479f-a652-611f99239352	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
20527b1f-6583-4f44-b50f-7da8dc13e032	c0d0b525-30a4-407d-9b43-66ec11c0ace4	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
2acfbeb1-d383-4794-b272-e0a5c14efabc	ad9deaca-7d85-4439-bafe-10a64cb86a18	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
333681a8-9c7f-4699-b98a-250257d4037d	ff4546ef-4428-4a60-9daa-f6582f8c1b07	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
3c894ac1-1805-4244-ab71-df99a24217aa	1f54d9d5-a146-4213-9f67-649db9f3029f	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
3e76f596-2699-486a-9051-e78cb60ddc52	9e5ac50f-b372-495d-84ee-24ab09898742	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
423f96e8-062d-4959-adf4-3d1c1dd432a3	b8f22f98-21bf-4ff3-be0c-82aebb6bf9c6	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
44233eac-dc6e-425d-a9ba-2d975a8acc4d	18807f8c-eb71-4588-a2f8-fc569c46fb39	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
48280c91-0a03-4945-9376-fdd8e5458586	625c0767-2822-425a-9895-c1fe1dad575f	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
4fb101c3-12f4-4383-b8f2-22e940746efd	c8f2a74f-5b7f-4f9a-ae8d-41f111ffb6ce	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
59d0f74c-7532-439f-b9ab-c87594b40e51	351749bf-9847-4991-8012-6c820f7d083f	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
7700c31e-3d81-4d2d-af5e-8376ef9450dd	5abe93fc-1e2a-4058-9a6e-d4fdc66ca76d	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
842bbed0-9c11-405f-8622-c2b35b87a289	bfe491dc-19e1-4877-b34e-baa35463ff23	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
8efa4a66-1b8b-4584-8333-15bd61886203	5fcbba9f-43a5-4da1-a8c6-220c74d34b76	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
95c0ab47-46d0-46fd-8cd9-e274abff51c1	5d7b5adb-2c1d-4e6d-ae6b-2635e1ca03b4	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
9698f58f-6afa-4c61-aa99-db1a0bb1afee	85598710-3fa3-4f86-8db9-f812b5925a2a	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
97af8449-6732-480d-8fe4-d452dff87762	02286cfe-d99d-4eec-be22-0cfad931ef0b	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
98168c9a-7bdf-4193-b841-596dc5c6aa5f	816b2c2f-2628-4623-89ed-d5129fb26772	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
9e522374-33c1-491b-9fb8-83fa6132e49b	060a358b-3f82-4602-8420-ab50ca35bf99	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
a00b00cd-ddba-4edc-96f4-e21ec8b4537c	383c2230-9f10-4d12-a2c2-54ad9d9ccf24	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
aae82289-1b4a-4735-9f04-d92fad0abb20	9204456e-3ec2-4264-bd02-156c703423bd	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
ac982d28-612b-4f83-90b9-65783298a1a6	893840e4-47ab-4d33-8f18-b973184e4ff7	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
b0469686-f3ea-4d4e-b862-d4b341cdd5db	38ccfafb-fd19-496d-9834-a8556f46f67b	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
b652f208-15bc-4cf1-9fdd-d24b44283c63	a472e665-935d-4c9a-96ef-a280700a3d0b	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
b6619bc9-e1aa-4073-adec-34870124b4da	8fd34d1b-f4ad-49bb-8f8c-77fc62ad9b5c	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
d99a57d4-976e-4931-b2d5-0838bec8e21d	fdbc68bf-00db-4644-8889-0d7b614c64d0	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
dd6f8a61-6af6-473c-8caf-c322cb25960b	64ea4800-881b-4464-8b50-4a934a755391	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
df592d9f-640a-4efe-9749-b5930fcc9172	a613f382-2484-41d1-9ba4-1f1e0ad54d2b	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
e008a63d-6026-4750-8f60-544fd436ea73	6fb0939e-75f9-4f3f-8d04-3b986c864bea	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
e2ba085f-c4a5-466b-a974-691d1750cf4e	dba1556d-5013-4863-bbd6-62dd6f3ec845	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
e6ba5078-d8a8-4bb3-8037-018ce15ade59	da4f8861-b8dc-486b-bac6-d1b7d8597132	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
f0eb6e8c-4090-4052-baa5-6deb41ad6a8a	26cd21d1-36aa-4c2f-ba25-29a14abadf5c	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
f295cd5a-baeb-4783-a123-82c223141d65	3ed47057-c11e-4762-8e7e-cf6da022d47d	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
f2b5580c-5b64-47f6-8ac4-868ea799c177	71f36199-1137-4540-8939-9f9ea35fe879	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
f5ad7559-801c-4fc2-a7d4-f175abf501f5	3e41a3f7-44c5-4cc0-a1b9-36de9b0af6d9	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
fd3e63b5-da81-463d-9a85-7ea8ef5ed279	c00b536e-bb7e-4fa1-8eb9-d3dbd9607410	1ecba460-a929-4fd0-918d-da926ace8d0f	deleted	user	admin
700b12a6-ea58-41f0-8198-daca0850a1ae	71f36199-1137-4540-8939-9f9ea35fe879	7ca8f8cf-22dc-4459-b9fe-2586753c2bff	active	user	editor
25e3ebc3-83d3-4136-9251-f614f1a3398e	64ea4800-881b-4464-8b50-4a934a755391	5c2e4bf3-0f24-4a9f-8d73-e7ae93099ddc	deleted	user	editor
2e97231d-0192-4f11-9f46-34ff23cc30b2	64ea4800-881b-4464-8b50-4a934a755391	dea08c51-9c0a-44eb-8ffb-16a05d3f360b	active	user	editor
d53f0874-1e42-4246-ab9b-b26e8c0b52cf	dba1556d-5013-4863-bbd6-62dd6f3ec845	018826dd-ca2e-4c93-8dfc-0c684b8d8a3b	active	user	editor
e24fb0f9-c797-43e6-ba72-092d1c5f9952	ff4546ef-4428-4a60-9daa-f6582f8c1b07	0a85ba18-93fe-478e-af42-12305431e5c9	active	user	editor
a0ac4b16-f15a-4e23-9f61-73155b3b5310	351749bf-9847-4991-8012-6c820f7d083f	f797cbf0-2614-49c8-bc1a-0c3532ff9303	active	user	editor
1bcdde01-5354-46d0-9671-c3cfeb7516e8	5abe93fc-1e2a-4058-9a6e-d4fdc66ca76d	4aaa69c1-0168-440c-a449-fa2c2961ef09	active	user	editor
c2f4a97c-8eb6-428a-a76d-9209fc9ca98e	b8f22f98-21bf-4ff3-be0c-82aebb6bf9c6	1bec422e-50d7-4949-8eec-087c2fd8593b	active	user	editor
b9d7ed97-a24a-45a5-9150-3b6519af2225	ad9deaca-7d85-4439-bafe-10a64cb86a18	75381928-6189-47e9-a2fc-8926fdc637d7	active	user	editor
a35eafcb-bc65-46d9-acc4-e9b0e3d5f5d0	893840e4-47ab-4d33-8f18-b973184e4ff7	a2c23ac6-921f-4cf3-ba59-db57f61b185e	active	user	editor
90faf6b4-4abc-4c01-b0e0-6d1813175e63	318d1db3-6db7-4045-8e7f-f33c6d439b8a	7451ce91-9d76-45d5-b9c4-76adf416ce64	active	user	editor
780be75f-f5d1-4c9e-a0d7-1f21615c8de0	a472e665-935d-4c9a-96ef-a280700a3d0b	c720aa59-4c14-4647-bfdd-202a69078b4f	active	user	editor
3eec9562-3cd0-4ff6-842a-d2ab561fc447	1f54d9d5-a146-4213-9f67-649db9f3029f	f2938c54-fbef-4aaf-b107-91ac38017394	active	user	editor
eb32e768-23e6-4344-ab06-80cb96f465e1	625c0767-2822-425a-9895-c1fe1dad575f	02610c00-315f-4e62-9003-f87e6fe9f16a	active	user	editor
9a270ea3-953f-4db7-93cc-619b973199c1	c0d0b525-30a4-407d-9b43-66ec11c0ace4	a5c70df3-209e-45f8-88e5-ff1ecef1fce4	active	user	editor
86218137-25ef-4397-b7d1-b052841ac0b6	6fb0939e-75f9-4f3f-8d04-3b986c864bea	2eda759d-9be0-4b8c-90e8-0d77e86eaef9	active	user	editor
90a7cf53-f372-45f0-aee6-9b190afa73c3	9e5ac50f-b372-495d-84ee-24ab09898742	b7327420-c2a1-4719-8061-22d1ebca7d3d	active	user	editor
58aabae7-4436-4008-a154-f81bced3ab1b	a613f382-2484-41d1-9ba4-1f1e0ad54d2b	c2e9c708-538b-42a4-b08c-d034f7b337a4	active	user	editor
1a8ff6c2-9d1d-4662-a5d9-7aec1c974869	3ed47057-c11e-4762-8e7e-cf6da022d47d	78e40015-1e4c-4367-99cb-b4cf78bc8c40	active	user	editor
812a9c57-1a81-42a0-89aa-82d507171ce4	c8f2a74f-5b7f-4f9a-ae8d-41f111ffb6ce	70ce8cd0-a15f-459e-9707-0ff7deec71ad	active	user	editor
eed47429-165e-4bd1-bb4a-d10bd9316112	18807f8c-eb71-4588-a2f8-fc569c46fb39	9ab7f247-3171-48a0-acb3-206bec24196a	active	user	editor
9f783f88-e9f6-45fb-99b6-a0f1bd3e36d0	9204456e-3ec2-4264-bd02-156c703423bd	3c5b8747-6349-452c-9aaa-c98e19c314b8	active	user	editor
bc551938-6fd2-4d66-8d06-06bc83e62559	8fd34d1b-f4ad-49bb-8f8c-77fc62ad9b5c	43dc1949-3059-456e-9a48-28be33cd1138	active	user	editor
f2dbfe30-385e-42b6-b306-15d7bb437a8e	816b2c2f-2628-4623-89ed-d5129fb26772	268d7f9c-81a0-4f26-bb02-2a3eaa520386	active	user	editor
1f473220-9bd1-4fd6-96c2-9c9fb63877ac	fdbc68bf-00db-4644-8889-0d7b614c64d0	5637f386-24bd-4fe2-b369-33ad666b66d9	active	user	editor
94c698d2-01fb-43cd-ae2a-14bbd3aac848	da4f8861-b8dc-486b-bac6-d1b7d8597132	56f6a936-9632-4958-955b-fee71c1354a4	active	user	editor
c1c3a31f-f028-4344-aedb-ccd39ba5d870	26cd21d1-36aa-4c2f-ba25-29a14abadf5c	934c8103-6c93-44e8-9bb4-18bed33b43ce	active	user	editor
321c1bae-9fa4-41ac-8eba-23768c181f78	85598710-3fa3-4f86-8db9-f812b5925a2a	a6d80551-94ff-45fa-a962-45f7e6ac9b5e	active	user	editor
826a8a42-0a84-48a8-9668-dee892ab441c	5fcbba9f-43a5-4da1-a8c6-220c74d34b76	b81e9f9a-b86b-41ce-b3e3-a5eb2f7cfe14	active	user	editor
bf61e949-f76f-49b1-a536-473eeaf9112d	02286cfe-d99d-4eec-be22-0cfad931ef0b	1850ca4d-4896-4b60-81ce-5d14b63249f8	active	user	editor
37e2782f-f293-46f4-8a96-3c34f3822ec6	060a358b-3f82-4602-8420-ab50ca35bf99	cd5886d0-db01-45b0-b40e-a041e3a91ade	active	user	editor
7b1f16bf-2063-41ae-8a21-7438daf45296	5d7b5adb-2c1d-4e6d-ae6b-2635e1ca03b4	b9f93bb1-fe46-41f6-84e3-c192e4edcfa6	active	user	editor
a230d1ed-94ee-4977-ae8c-0493412f418b	38ccfafb-fd19-496d-9834-a8556f46f67b	903e974e-e87b-429c-be07-fa30ecf451ec	active	user	editor
9e3a0132-1db0-4d40-87c7-856cf50317cb	3e41a3f7-44c5-4cc0-a1b9-36de9b0af6d9	48835434-f85e-4d1d-9432-505392deee4f	active	user	editor
c8d1bd1e-01b6-41b8-ae4d-9a880e0c4b38	2fec2312-cfb4-479f-a652-611f99239352	f5e5b358-3b9e-4546-8146-3963034e9ca6	active	user	editor
fc757f69-5e4c-4e95-878a-67a797dd5e65	c00b536e-bb7e-4fa1-8eb9-d3dbd9607410	78c9a180-dc15-409f-b6d2-e1cf8c285298	active	user	editor
658dd30d-4312-4561-b346-f34e87f34b55	bfe491dc-19e1-4877-b34e-baa35463ff23	3d8a85b7-48b4-4980-95a2-d9bc3bbfbfa9	active	user	editor
4e0c36cf-d093-456d-bd31-ce439f58809c	383c2230-9f10-4d12-a2c2-54ad9d9ccf24	2c5c2e38-31f5-43fd-bfe5-67bb1154a544	active	user	editor
\.


--
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.package (id, name, title, version, url, notes, author, author_email, maintainer, maintainer_email, state, license_id, type, owner_org, private, metadata_modified, creator_user_id, metadata_created, plugin_data, extras) FROM stdin;
\.


--
-- Data for Name: package_member; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.package_member (package_id, user_id, capacity, modified) FROM stdin;
\.


--
-- Data for Name: package_relationship; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.package_relationship (id, subject_package_id, object_package_id, type, comment, state) FROM stdin;
\.


--
-- Data for Name: package_tag; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.package_tag (id, state, package_id, tag_id) FROM stdin;
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.resource (id, url, format, description, "position", hash, state, extras, name, resource_type, mimetype, mimetype_inner, size, last_modified, cache_url, cache_last_updated, created, url_type, package_id, metadata_modified) FROM stdin;
\.


--
-- Data for Name: resource_view; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.resource_view (id, resource_id, title, description, view_type, "order", config) FROM stdin;
\.


--
-- Data for Name: system_info; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.system_info (id, key, value, state) FROM stdin;
2	ckan.site_custom_css		active
7	ckan.theme	css/main	active
5	ckan.site_logo	2026-06-13-101641.516688LambangKotaKendari.webp	active
6	ckan.site_title	Satudata Kendari	active
3	ckan.site_description	Portal Data Terbuka	active
4	ckan.site_intro_text	Akses ribuan dataset dari instansi pemerintah, layanan publik, dan organisasi daerah Kota Kendari untuk mendorong riset, inovasi, dan transparansi.	active
8	ckan.config_update	1781422884.3171432	active
1	ckan.site_about	# Tentang Portal Satu Data Pemerintah Kota Kendari\r\n\r\nPortal Satu Data Pemerintah Kota Kendari merupakan gerbang resmi dan terintegrasi untuk mengakses data publik yang dihasilkan dan dikelola oleh seluruh Organisasi Perangkat Daerah (OPD) di lingkungan Pemerintah Kota Kendari. Portal ini dibangun untuk mendukung prinsip pemerintahan terbuka (open government) dan tata kelola data yang profesional, akuntabel, dan berstandar nasional.\r\n\r\nSebagai bagian dari implementasi kebijakan Satu Data Indonesia, portal ini dirancang untuk menyediakan data yang akurat, mutakhir, terpadu, dan mudah diakses oleh masyarakat umum, pelaku usaha, akademisi, peneliti, media, dan pemangku kepentingan lainnya. Melalui platform ini, kami berupaya memfasilitasi transparansi informasi, partisipasi publik, serta pengambilan keputusan yang berbasis bukti (data-driven) dalam perencanaan dan pembangunan daerah.\r\n\r\nPlatform ini menjalankan sistem manajemen data menggunakan CKAN (Comprehensive Knowledge Archive Network) — sebuah perangkat lunak sumber terbuka yang banyak digunakan sebagai standar portal data di berbagai tingkat pemerintahan dan organisasi di seluruh dunia karena kapabilitasnya dalam publikasi, pencarian, dan pemanfaatan data secara terbuka. proxyapps.data.go.id\r\n\r\nFitur utama portal ini meliputi:\r\n\r\n1. Akses langsung ke kumpulan dataset resmi dari berbagai sektor pemerintahan.\r\n\r\n2. Pencarian dan filter data yang memudahkan pengguna menemukan informasi yang relevan.\r\n\r\n3. Metadata yang baku dan terstandarisasi sesuai pedoman Satu Data Indonesia.\r\n\r\n4.  Kemudahan unduhan data untuk analisis, penelitian, dan inovasi publik.\r\n\r\nKami berkomitmen untuk terus meningkatkan kualitas, kuantitas, dan keterpaduan data yang tersedia di portal ini, serta mengoptimalkan layanan bagi seluruh pengguna demi mendukung pembangunan yang lebih efektif, efisien, dan transparan di Kota Kendari.	active
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.tag (id, name, vocabulary_id) FROM stdin;
d1639a80-e891-4668-b8ef-20be5e21b1c9	Dolor ex quia pariat	\N
56e8073a-a8c1-455e-a64e-f226cd774d48	Totam laborum ipsum	\N
10150254-e9e3-4d07-92f6-083d667d421b	Incidunt nostrum vo	\N
cb162de2-3be7-4b23-8f5e-9f464c139648	Call Center	\N
76cf0bf2-4c18-4b80-ac18-f86d88a5d7b8	112	\N
81f52d8f-487a-4c6e-9525-687300b1d717	Public Service	\N
58494be1-862f-4278-b535-f2dfbf5b77e0	pendidikan	\N
5ceb142b-4da5-4ca2-b217-6cb90b9271e5	sekolah	\N
126254ae-5480-404c-a38c-08189ef7e060	asdfa	\N
8ef889df-21e1-40cc-992e-a636056a8e92	penduduk	\N
b98e80ea-5aa7-4bbf-a63f-4cccdc0387e1	sipil	\N
48a8ea6c-bdb8-464d-ba77-04ef3e7edda6	warga	\N
5290232f-30d4-4f23-a6f7-033f2310fdea	gaji	\N
dc6dffe7-5338-49c1-9ab2-f24a48a5b93c	tenaga	\N
e4090e4d-aa2d-4d0c-b743-09a4c16fe724	pekerjaan	\N
\.


--
-- Data for Name: task_status; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.task_status (id, entity_id, entity_type, task_type, key, value, state, error, last_updated) FROM stdin;
585b88fa-fae5-4bc4-a6d2-38635490d34b	47cbadaa-8af6-453f-9414-3886d3e41c1b	resource	datapusher	datapusher	{"job_id": "8a6e3011-d8a0-4182-886f-ac1b1fa5c6f8", "job_key": "e665d233-88c8-44c9-9ea0-ae70fa225de6"}	complete	{}	2026-06-12 22:55:40.587931
23e20368-8c1f-4552-ae6e-7be3955ba880	b8a8393f-619e-4d8d-b507-7f2269abb845	resource	datapusher	datapusher	{"job_id": "d492eea3-fba4-48aa-ab90-c645102b3587", "job_key": "f25b9c90-0254-485a-8a13-9b59311732f5"}	complete	{}	2026-06-12 22:13:27.849018
e2de30e5-6c2e-4893-b5ed-46d7a0645af3	a964d05a-e43a-427f-b61a-14b761ff74c8	resource	datapusher	datapusher	{"job_id": "8c5fcafa-c9b2-41f8-bc7c-02d4d3c445f7", "job_key": "e7c31d25-cdaa-4c25-b1eb-4f067ecbeadd"}	pending	{}	2026-06-12 22:25:03.423266
9987fcd4-c03c-4ef6-bf03-d3e36a9e8d79	3d5e71d1-5af9-4743-aa05-218225b6a61e	resource	datapusher	datapusher	{"job_id": "ee716bee-f359-46fd-b432-7522a2dc4829", "job_key": "6f2fc5e1-a1c1-4e9e-a034-b70503b45569"}	pending	{}	2026-06-12 22:26:13.850013
2ad0c6a7-1d8e-4e70-9947-1e12415df1b5	8438746e-4ee9-4260-8a70-99aada1cf849	resource	datapusher	datapusher	{"job_id": "336bc1cd-06fc-471a-8faf-2b41719d2c60", "job_key": "b4dd31bf-b941-487e-bd5a-356883ab488a"}	complete	{}	2026-06-12 22:33:35.02157
c7053f31-2977-4672-b28b-70b67ac483b9	87984e66-7831-4236-b3b0-e1a97e226c69	resource	datapusher	datapusher	{"job_id": "6dbed58c-80cd-46e9-b975-8ddaaf1987aa", "job_key": "b59842b9-0f95-4d9d-b944-a64d76be1e63"}	pending	{}	2026-06-12 08:55:00.840374
57f5d329-1ba2-4806-9222-117be1a25603	fa8012e4-7236-420c-887a-09ffd85c48d3	resource	datapusher	datapusher	{"job_id": "98b49831-21d7-469e-a6cc-e667cec17b5c", "job_key": "dc006954-4c94-4cd9-b8ac-08a133d78f28"}	complete	{}	2026-06-12 08:55:52.940595
e3ce49d8-1798-403d-837c-b928422da263	66e3c094-1d16-40df-a7af-18822c7be27b	resource	datapusher	datapusher	{"job_id": "4d46d944-f039-48b3-919e-a1894aea4b89", "job_key": "16ac6c17-d7a1-4051-8ffb-ef185a72c714"}	complete	{}	2026-06-12 22:55:53.629994
811dadc7-4dfb-41b2-83db-25d5accd9199	6e9c9a76-d96f-42dc-9ef6-eefcc8dc5792	resource	datapusher	datapusher	{"job_id": "28dbc738-8d6d-445a-b407-437bae0a720a", "job_key": "caef15fa-cc39-4f15-9756-8f312bf906af"}	complete	{}	2026-06-12 22:36:17.520099
2fe2f1f6-18c7-4f9c-a73f-2426eb003f9a	d87aad42-532e-426d-aba5-2dc5271a04c7	resource	datapusher	datapusher	{"job_id": "662a397b-6b3e-45e1-997b-014fa7881b89", "job_key": "9b482867-270a-4b26-a5ff-fb5d22e81694"}	complete	{}	2026-06-12 08:56:31.578778
65edb776-d7ad-46bd-9f21-64c923048503	c41d1310-39cd-4325-b3ce-8d8cbdf4f13d	resource	datapusher	datapusher	{"job_id": "9f17cd32-8a3e-4211-b57a-7c409f301295", "job_key": "92bd2db8-6a6a-4792-a623-7dcd3fee0ffb"}	pending	{}	2026-06-12 22:36:38.259941
2d6f4b9c-1f49-482b-ac4c-37d3caa3ea37	2c33a27d-3ab2-4e5d-a8e6-5fffff1f29b1	resource	datapusher	datapusher	{"job_id": "8da5788f-3c56-477c-b238-715d55a08196", "job_key": "46d172a4-9b11-4f1e-852e-ebfe430d2fab"}	complete	{}	2026-06-12 09:00:25.69182
d7d6c4e7-0570-4036-a00d-98a34792340b	c31f5850-c1b3-49ad-9f75-2335ff374ed7	resource	datapusher	datapusher	{"job_id": "c7010975-1ba9-4b9c-9af4-942462e647d0", "job_key": "92f40e08-ac80-4cf4-bd92-b1176e0682a8"}	pending	{}	2026-06-12 22:38:08.561461
28165047-fdfe-4483-986a-2d81c8d9ce19	54604c6b-3cf1-4b3b-b363-f7df73bba670	resource	datapusher	datapusher	{"job_id": "d5e47c35-3aff-4caa-8946-6157df893e56", "job_key": "cc1ade5b-6d69-4c51-8d1c-4a3a01d43ed1"}	pending	{}	2026-06-12 23:19:26.558017
c4090ebe-978f-4414-b442-15bbfeea4794	816cc929-c37c-492d-8f48-54fb96edc81e	resource	datapusher	datapusher	{"job_id": "0b056ae0-9009-4b46-aaa6-68c4393f61f7", "job_key": "b5c00251-c0c9-4c96-8674-c924582aec82"}	complete	{}	2026-06-12 22:40:07.622305
4fbc2bd2-db0d-4ac4-9309-380c47b8c560	315a7621-f91c-416d-a749-93c18b24901e	resource	datapusher	datapusher	{"job_id": "6ded57c5-546e-4e1b-ba06-f5177c2ba348", "job_key": "1dabf631-5b8c-431e-aa59-fa6e35d62e03"}	pending	{}	2026-06-12 22:40:48.12464
5c4aff03-cb24-4d5f-a840-78ed444fbab2	2a301b75-5715-4186-be2f-8dd1b69e15ca	resource	datapusher	datapusher	{"job_id": "1a877a2e-4e1e-4524-847f-6c51ca07d81c", "job_key": "5783e596-6b85-49d1-aa54-13ddb3e8ee9e"}	pending	{}	2026-06-12 22:54:25.647113
5d93d75a-9f11-43eb-804d-2530897809a0	616cb099-e0e6-4910-9a7d-4bcc34e8f789	resource	datapusher	datapusher	{"job_id": "f534ea82-2f01-4c75-b4ea-24bf88d7acc8", "job_key": "7b50ee1a-47f2-43e6-aea9-04fa106b27a2"}	pending	{}	2026-06-12 22:55:15.987942
a23aa203-6614-4f96-9708-4e132857029a	86df1b2b-a462-4a60-ace6-ad5741722cc4	resource	datapusher	datapusher	{"job_id": "ef89e335-e486-4226-bb10-5881367ee773", "job_key": "fa528c2a-0d75-4c49-b649-3b26e9bfa104"}	pending	{}	2026-06-13 00:03:16.245845
60606ec9-10d2-4d8c-9258-9fa3cb8b3a81	ea97711f-f007-4a22-b0f6-c0feba07c0bd	resource	datapusher	datapusher	{"job_id": "005754fb-38ba-46cf-a479-558ae2f8e9fb", "job_key": "b6f5f362-ecc4-4c72-95e5-85e77094acf7"}	complete	{}	2026-06-13 00:10:48.333008
fb4417f7-de82-44ed-9aa1-893ea80a82cb	aae1a59b-0bbb-4e0c-bc09-8f8769969af0	resource	datapusher	datapusher	{"job_id": "55b53e26-687e-4f1a-87d9-0fd4e085a885", "job_key": "24a8e29f-a7bd-4e73-b679-cd3306611670"}	complete	{}	2026-06-13 00:28:44.366497
f946db97-d08a-4df2-8431-979d227a9079	f7b7a5aa-23e8-4f2d-8b5a-e80e214cc93c	resource	datapusher	datapusher	{"job_id": "e140c36c-3f42-4e6a-9701-56d8e912c41b", "job_key": "ad9870ec-56e6-4e58-b4bc-4f6099d7039f"}	pending	{}	2026-06-13 02:45:47.696542
2e0ce2d3-1865-4756-9793-721c45dd0402	65d17533-0013-41fe-b928-aa08e64cf786	resource	datapusher	datapusher	{"job_id": "e8ae80d7-b581-489c-b73a-1d4141c1d253", "job_key": "6191e370-8d73-4669-a5be-dd13bbd749fb"}	error	{}	2026-06-13 00:20:40.947853
2e9e3007-3c14-4e90-9a7f-5c44f0e83657	36dab7cb-47d0-4738-8d32-82628842feb6	resource	datapusher	datapusher	{"job_id": "6c953488-087e-4d30-8d86-d4d51bd9af67", "job_key": "9bba6751-e17e-4727-98cb-76c4cabb039e"}	error	{}	2026-06-13 00:09:46.893672
dcca55ae-0e4e-45cb-a54c-81730bb4bb3b	04bf53f5-7daa-4e20-b588-34fe2c8cb29b	resource	datapusher	datapusher	{"job_id": "a6aa1bfa-cd42-4608-a385-874bb8b6d48f", "job_key": "4cad2f41-0a5e-41fc-8b3d-a0dafde68e8a"}	pending	{}	2026-06-13 02:10:47.651365
88969ff4-c648-43c3-9a0e-a1a2d97ea8b9	d17cae0e-21ed-4b48-b244-c075ed5f1af6	resource	datapusher	datapusher	{"job_id": "b367c962-0fe1-462a-a6a0-ee40e1b51814", "job_key": "622b6d28-326b-4621-ab1a-58a8fbb21ae8"}	pending	{}	2026-06-13 02:37:11.020043
eb86f539-f6ce-4d6e-a7d0-df8dc80e3082	c69de9de-3343-4ed6-ab6d-d55211e5886e	resource	datapusher	datapusher	{"job_id": "e75782bc-ae1b-4d61-9c63-82c1d3422a57", "job_key": "a22dbaa8-80e4-423c-ad27-4b04b489ec2d"}	complete	{}	2026-06-13 02:53:52.923055
91893a5a-44ed-465a-95bd-63031d2b1543	de60ce41-e157-4fd4-b2c3-406b02752ff9	resource	datapusher	datapusher	{"job_id": "96fc47c7-ccf1-40b4-96da-b427f658c27d", "job_key": "e58e12a5-f66c-44a0-8b82-c1f265707925"}	error	{}	2026-06-13 03:13:51.589812
1348e513-0760-4acd-8dfd-ea56da2acab0	514d60c6-c167-4969-9089-668339d987d1	resource	datapusher	datapusher	{"job_id": "ac2b3052-e99e-4364-8214-6877904069ad", "job_key": "c7084ea3-1a6c-422a-b5c4-c24bc49e6cd7"}	error	{}	2026-06-13 03:15:17.493479
533cfc80-27a2-43ad-87de-8d049896b535	b101ae21-37ef-4503-a4e9-a40c29c802d4	resource	datapusher	datapusher	{"job_id": "01b29965-4709-450b-b9a3-2a90de8dce37", "job_key": "36fcfa8f-8c3f-44fd-9a7c-17d9e04c8a41"}	complete	{}	2026-06-14 15:28:20.194044
283704b3-dc4b-45d7-be49-49a9806e52bf	f99a9230-e57f-410a-afe1-1f9b6a436dee	resource	datapusher	datapusher	{"job_id": "ce22439d-ed13-462a-9b54-91562f72b63a", "job_key": "ec25155d-8d87-470b-8aa0-b30234e56786"}	error	{}	2026-06-13 03:39:41.333689
2566c935-3daa-48a6-a136-8be256f50247	111c8587-88e9-477c-b046-b9c9671dfdc9	resource	datapusher	datapusher	{"job_id": "fbb0b11c-b032-4c4e-b218-63cea64082dd", "job_key": "29ba1940-062f-4d42-84cd-3297e714e800"}	complete	{}	2026-06-14 15:33:48.925405
1153fe7d-9b27-43e8-86ff-f250a8d44574	b699c5dd-2523-41c6-8cbb-af110c631c90	resource	datapusher	datapusher	{"job_id": "2c8538f9-0c02-4300-9a9a-53f2ce319411", "job_key": "6b6730e9-10aa-4723-abc1-e02ac4965962"}	complete	{}	2026-06-13 03:18:30.941971
1a0a5e89-0061-4ebe-807c-8595181794d1	75857bfe-c530-4e8f-bbdd-6244f7a985c9	resource	datapusher	datapusher	{"job_id": "0f9c6e89-e7d7-45f4-8cd8-a7fe0a5d1ee8", "job_key": "c316013a-a74c-496d-afc3-f2a491927eab"}	error	{}	2026-06-13 03:43:44.302448
2c86eb94-95a2-4289-b8e9-a1b501ffc3c5	ffc8c7e7-ea7b-4375-afeb-97f73a68a6c9	resource	datapusher	datapusher	{"job_id": "ee7a4de5-5483-47c0-b436-2fcf8e0652df", "job_key": "c304f441-c363-4d84-ad98-d40873f31ba6"}	complete	{}	2026-06-15 22:55:54.548765
6e7f041e-c2ec-45c0-8cad-38c533bc36e9	48024d44-6e72-4ec9-8bd9-492ff47e1817	resource	datapusher	datapusher	{"job_id": "fbfb54aa-fa11-4f9d-a831-ac2cb7e1782e", "job_key": "89c60ad3-aa06-4853-af95-2c01f73de91a"}	error	{}	2026-06-13 03:24:03.994867
411e64d2-3e32-4845-9e6b-8ccfc5382fde	6617200c-6c9c-4285-966e-5a6de2658827	resource	datapusher	datapusher	{"job_id": "28a8e2dd-effe-4b66-aabf-3ee84b8dc3fa", "job_key": "23d3a3eb-cc6a-46bd-97f0-fc061d312ddb"}	complete	{}	2026-06-13 06:55:33.128159
45719a62-e868-44af-a008-95a97ecf2682	ddb24b70-f61b-4cae-b066-3132b0a338a4	resource	datapusher	datapusher	{"job_id": "d3bd020f-9949-4e2b-ba27-4077a4555dfa", "job_key": "78f3f912-ba2e-4fa8-a303-3b038311a69e"}	complete	{}	2026-06-13 08:11:56.009752
\.


--
-- Data for Name: term_translation; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.term_translation (term, term_translation, lang_code) FROM stdin;
\.


--
-- Data for Name: tracking_raw; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.tracking_raw (user_key, url, tracking_type, access_timestamp) FROM stdin;
\.


--
-- Data for Name: tracking_summary; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.tracking_summary (url, package_id, tracking_type, count, running_total, recent_views, tracking_date) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public."user" (id, name, apikey, created, about, password, fullname, email, reset_key, sysadmin, activity_streams_email_notifications, state, plugin_extras, image_url, last_active) FROM stdin;
7451ce91-9d76-45d5-b9c4-76adf416ce64	admin_bagorganisasi	\N	2026-06-16 05:05:39.358909	\N	$pbkdf2-sha512$25000$KMUYQwhBCIHwXktpbe39Pw$BTPxzQ8L0mSfhzJMElnW2Lq3tOpX2DQStCMDNl9vfRVrcGl7gOIROmqM1yxilzqeuG2VtIFl.FJQpX2Cg/w9NA	Admin Bagian Organisasi Setda	bagorganisasi@gmail.com	\N	f	f	active	\N		\N
7ca8f8cf-22dc-4459-b9fe-2586753c2bff	admin_bkad	\N	2026-06-16 04:52:50.002371	\N	$pbkdf2-sha512$25000$0DrHeK81ppQSojQG4FxrzQ$ldSiZyM2yrYJBt8vikTCoZS/gqO0TRhFuDWxPhcc7Hloz716O9sx4G/erVLCL.tdjRFIxPTiw363DCaj/NFfKg	Admin BKAD	bkad@gmail.com	\N	f	f	active	\N		\N
c720aa59-4c14-4647-bfdd-202a69078b4f	admin_bagbarangjasa	\N	2026-06-16 05:06:34.215655	\N	$pbkdf2-sha512$25000$hlDKuTcmhPB.7x3j3JuzFg$IiCf7QFDkyHBAwRWO8WsQvky2gCVM3Jps9DJRZpGr3sg3FpW79FDMwy1i653SvYRt.a4QZK3uDCq3aiaXrh3Cw	Admin Bagian Pengadaan Barang & Jasa Setda	bagbarangjasa@gmail.com	\N	f	f	active	\N		\N
f45d3f4c-fed7-4931-ae77-ad0dabc91162	default	4261852f-0747-4227-b1c3-93ba3719f752	2026-06-07 14:22:58.545441	\N	$pbkdf2-sha512$25000$krIWIiSk9F4L4fyfE.J8Lw$99MRdwTA4pIOoD2Sozp0/t5/bRX88zDy0YU8zVjws3gB7fnUj/sR/NyA0Ri6U5XbCp/vEkSrRGl56YjXerHJXw	\N	\N	\N	t	f	deleted	\N	\N	2026-06-07 16:25:21.193011
5c2e4bf3-0f24-4a9f-8d73-e7ae93099ddc	bpbd-7146	\N	2026-06-16 04:54:32.085646	\N	\N	\N	bpbd@gmail.com	66661fe445c42c739dae9953c270665f	f	f	deleted	\N	\N	\N
dea08c51-9c0a-44eb-8ffb-16a05d3f360b	admin_bpbd	\N	2026-06-16 04:55:00.451099	\N	$pbkdf2-sha512$25000$pxRijPH.v7eW8h4DYEzp3Q$lKXOdq.f.OxXelG490M.FVro79TFYmLlX/ch6iOPnWiVP2jJdn52eyHhBhW8uXa.9ZON0paJXz3bjSLaA3MsVA	Admin BPBD	bpbd@gmail.com	\N	f	f	active	\N		\N
018826dd-ca2e-4c93-8dfc-0c684b8d8a3b	admin_bapenda	\N	2026-06-16 04:57:39.172485	\N	$pbkdf2-sha512$25000$MUaIcS6F8H6PkVJKCYFwjg$3.cLCq1RecZSDI2e1hu3q3eG5KeB4xgVa7ct4TdC20L9z0F5TiVu.XXmafMKom4w/xC/XQ6Y8iWRBoix0qIVoQ	Admin Bapenda	bapenda@gmail.com	\N	f	f	active	\N		\N
0a85ba18-93fe-478e-af42-12305431e5c9	admin_bappeda	\N	2026-06-16 04:58:31.23337	\N	$pbkdf2-sha512$25000$REgJIaQUQuh9b41xbi2FMA$3N1HcOECrmdkghICkQlVmqnpL/AmShRBwYjAZUMlpA36AuUh1Qo0rmNPEJB9preZ39lkhHHFhUEgHGVmw/Yv3w	Admin Bappeda	bappeda@gmail.com	\N	f	f	active	\N		\N
f2938c54-fbef-4aaf-b107-91ac38017394	admin_bagperekonomian	\N	2026-06-16 05:08:09.872179	\N	$pbkdf2-sha512$25000$sVbKOYeQsvb.P2cMwdgbYw$5o.tCP2biOqOQOlqHqcG7C0R5bLDB7.BMPAyHf0lUUtviFze44ew.j37SaetjvIH4Ja.LPwEgRU8Oq619Yx2tg	Admin Bagian Perekonomian Setda	bagperekonomian@gmail.com	\N	f	f	active	\N		\N
f797cbf0-2614-49c8-bc1a-0c3532ff9303	admin_bagpembangunan	\N	2026-06-16 05:01:02.714187	\N	$pbkdf2-sha512$25000$IcQ4h5CSMiaEEKI0pnRuDQ$jyyhN.9xt9eJM4x16eje6Oj73xQAgGtYXADmXw4YBSdXuQ.8G4hFw8eAaF6/z225x/kAvtgjVF6eryLZFalGnQ	Admin Bagian Administrasi Pembangunan Setda	bagpembangunan@gmail.com	\N	f	f	active	\N		\N
02610c00-315f-4e62-9003-f87e6fe9f16a	admin_prokopim	\N	2026-06-16 05:09:01.615924	\N	$pbkdf2-sha512$25000$qdV6r1Wq9V4r5Zwz5ryXkg$cwcZrovs7AAx2i/g4NHV1ndclg8MR7XxP0sk6VS.I0fAZRh2.N4HSud1OD8UAbPV5ylrDfc5UEUOmUcYCBNM.w	Admin Bagian Protokol dan Komunikasi Pimpinan Setda	prokopim@gmail.com	\N	f	f	active	\N		\N
94ac333d-b70b-4a73-803d-20ddd1b14873	admin_bkpsdm	\N	2026-06-16 04:41:53.388017	\N	$pbkdf2-sha512$25000$cO5dixHinJNSqjUmBKC0Ng$G6td.eIQUy7.Dy1YHRpD0Ay305MQE4UDV7iSSJ.rJzZ3ex1p.VegncfxFfkkXRpVhhUPEpM.zbUmVstxaNrC1A	Admin BKPSDM	bkpsdm@gmail.com	\N	f	f	active	\N		\N
ae8481ec-9efd-44e2-8819-a649fb141ef2	admin_infokom	\N	2026-06-15 23:24:20.62381	\N	$pbkdf2-sha512$25000$MEYIIYSwdi4F4Fyrde4d4w$6j2LiR5PT6/8ve6fHU7L7.1iXxAfFiaUQx1lwJNpabH7XttJXwBkzVUFB2gDaTF9Cfqri6XMdv/q8C3P2eslAg	Admin Infokom	infokom@gmail.com	\N	f	f	active	\N		2026-06-15 23:28:00.336102
975cd397-3b9f-444b-b605-e5ae65703085	admin_bakesbangpol	\N	2026-06-16 04:44:41.592394	\N	$pbkdf2-sha512$25000$lpJy7h3D.N9bK.UcozTmXA$x.x/9w/WvoUlHeqny.29gLZxr5DjNaUEwJPy3S70ZKBCGWo4A7TznLtWB8oBnurLj72TP.448OFFv99eio6pVQ	Admin Bakesbangpol	bakesbangpol@gmail.com	\N	f	f	active	\N		\N
0fa4cc7f-c2c5-41a9-a932-cb46fa5fcafc	_tmpverify	\N	2026-06-15 23:38:16.957525	\N	$pbkdf2-sha512$25000$lRJCCMG4d651DoGQ8r5XCg$aKPk3BgGbLYngIEXUC8gKlTRRGhyg7t/Shdvls/rHMHbvV9C8HNEw2ca/QovCP3vvldY2YWQ2sGzyVZQ56VZgw	\N	tmp@x.id	\N	f	f	deleted	\N	\N	2026-06-15 23:38:18.757601
a5c70df3-209e-45f8-88e5-ff1ecef1fce4	admin_bagsda	\N	2026-06-16 05:10:21.474814	\N	$pbkdf2-sha512$25000$W8sZAwAgpJQSopTyXgsBwA$qPmlhBzIQ8JnUQuw3CN0hXCxKkjssp9YSsiCOsCliy8jRoJZ6b/OBgO4p03vUmShF0RenJ5EwXBKx/MWoJmNig	Admin Bagian Sumber Daya Alam Setda	bagsda@gmail.com	\N	f	f	active	\N		\N
2eda759d-9be0-4b8c-90e8-0d77e86eaef9	admin_bagumum	\N	2026-06-16 05:10:56.224395	\N	$pbkdf2-sha512$25000$8V4L4fw/57x3DqFUSkkJoQ$ltfOj/JBJzhXAjwixdHyQSnmBxBWuqVu9hbImIdKTGv4CrqVqsTPBtZyAaZMUbVmHsShLJMtMKtGZaFcEPnC/g	Admin Bagian Umum Setda	bagumum@gmail.com	\N	f	f	active	\N		\N
b68d0318-8694-4411-a4ae-d9aa9bcdd5d2	admin_kominfo	\N	2026-06-15 22:46:17.731501	\N	$pbkdf2-sha512$25000$HgOgNIaQ0tqbM6aUUqq1lg$BfZiTdvnjkj2vXAypfO0pEz1AYyeET4buVmyP.t8fBxwLE7Q5WviFgHYZQZAS2vgoIW.h4XoqG1oJRFjlYEkXg	Admin Kominfo	kominfo@gmail.com	\N	f	f	active	\N		2026-06-15 23:52:55.683207
c2e9c708-538b-42a4-b08c-d034f7b337a4	admin_dukcapil	\N	2026-06-16 05:12:23.533057	\N	$pbkdf2-sha512$25000$pBSiNKYUwpizVmoNIQSgtA$qh.XrUmKCNF1LK5GjWm8NynkeuSsYX2Ccftt6ne6IO2zJcZmWBr/LDfzXxVIwGeqElGcCAhSYAU9O6EHQixyxw	Admin Dinas Kependudukan & Catatan Sipil	dukcapil@gmail.com	\N	f	f	active	\N		\N
4aaa69c1-0168-440c-a449-fa2c2961ef09	admin_baghukumham	\N	2026-06-16 05:02:24.333808	\N	$pbkdf2-sha512$25000$cU6p9Z7zPudcy/k/h7AWQg$W1pAtFf50l68B/b3V4kwVWmzBntWDUqF59IOfT0Y3eWmFaOdFsivoAvd71nhzQfHXzV.JPQGaKfuhhu4wnV6Ng	Admin Bagian Hukum & HAM Setda	baghukumham@gmail.com	\N	f	f	active	\N		\N
1bec422e-50d7-4949-8eec-087c2fd8593b	admin_bagkerjasama	\N	2026-06-16 05:03:17.672564	\N	$pbkdf2-sha512$25000$u5cyBkDIWSvF.H8PoVQqBQ$ylWh2aSXdBCU6ryVj0xh0HP4n/Q6Cnirq8IT1Rys5eCoyioGfVSnzRqcqgJdU8RJnqWErViKOP2gcN9YCyJ7Ig	Admin Bagian Kerjasama Setda	bagkerjasama@gmail.com	\N	f	f	active	\N		\N
75381928-6189-47e9-a2fc-8926fdc637d7	admin_bagkesra	\N	2026-06-16 05:04:10.582235	\N	$pbkdf2-sha512$25000$HiOE8H6P8b5XKmVMKWUshQ$7leesO34aCdpJWaq9RerkSbmGkPLjB19gThJyxSNeekeEV7CTDh9ba0U/jeangi1byxVGlKvU4SjtP5zQsuZqg	Admin Bagian Kesejahteraan Rakyat Setda	bagkesra@gmail.com	\N	f	f	active	\N		\N
a2c23ac6-921f-4cf3-ba59-db57f61b185e	admin_bagkeuangan	\N	2026-06-16 05:04:53.828212	\N	$pbkdf2-sha512$25000$6L13jjHmvBeiNAYg5Nxb6w$TWMxnp2LLZiNu6Fn47ykhJMzj7AYl.ATStuBi040fT3jOw7JkZq0bR2MDoNcYMZUE1Jt1aJJckA4XLlL8pewvg	Admin Bagian Keuangan Setda	bagkeuangan@gmail.com	\N	f	f	active	\N		\N
b7327420-c2a1-4719-8061-22d1ebca7d3d	admin_damkar	\N	2026-06-16 05:11:39.646917	\N	$pbkdf2-sha512$25000$plRKaU3JGeP8H6O0lpJSCg$Gk/N6PM2fDH7gxlUuKpN8h28uouchmkgEFHdIAtSx/tJO1lNMlXLNJ9LAhdKISjJ918fwxyh11cs/Qj38ezHeA	Admin Dinas Damkar dan Penyelamatan	damkar@gmail.com	\N	f	f	active	\N		\N
78e40015-1e4c-4367-99cb-b4cf78bc8c40	admin_dinkes	\N	2026-06-16 05:12:58.017274	\N	$pbkdf2-sha512$25000$C2EsBSCkdK6VkvLeO0cI4Q$2PfSR5VsMmkVnTbp7PAwhGwEs2C0asQtoIcfAQitvJD7S1vMSMpBfzJb5SXel2eL3HQEC84zhWoc/AnaUhcLDA	Admin Dinas Kesehatan	dinkes@gmail.com	\N	f	f	active	\N		\N
70ce8cd0-a15f-459e-9707-0ff7deec71ad	admin_dkp	\N	2026-06-16 05:13:39.54504	\N	$pbkdf2-sha512$25000$ZyzFGOMcIwSAkJJy7l2LEQ$AbejEFJY1lVFrLKIkAdeRD63P4g.gP6FM/4TffpVidk8.QYMs7XCSpPUEgMCCFcMe1q6blnfYFHBLPJxuh811Q	Admin Dinas Ketahanan Pangan	dkp@gmail.com	\N	f	f	active	\N		\N
9ab7f247-3171-48a0-acb3-206bec24196a	admin_dlhk	\N	2026-06-16 05:14:47.317017	\N	$pbkdf2-sha512$25000$uxei9P5fq5Xy3lsrRUjJuQ$.7KJPGJxSzYRCnMyMj9te0dKIxr6jSo3APe1McUtAcebPPazvMVB9E/kucHh1TVHrO.2ZEunCKDoefEUAJlfgA	Admin Dinas Lingkungan Hidup	dlhk@gmail.com	\N	f	f	active	\N		\N
3c5b8747-6349-452c-9aaa-c98e19c314b8	admin_disparekraf	\N	2026-06-16 05:15:53.97234		$pbkdf2-sha512$25000$GENIiTEmxLjX.l8LgfD.nw$xihxGWIdMjEHtfLs.AXHCzdZZUPwdbSlD/NWkH5KZpQl6o/ArPNAKt0ytBa9zvCusjRLupf48y4sTHZR0KYPng	Admin Dinas Pariwisata dan Ekonomi Kreatif	disparekraf@gmail.com	\N	f	f	active	\N		2026-06-16 05:16:41.796196
43dc1949-3059-456e-9a48-28be33cd1138	admin_pupr	\N	2026-06-16 05:17:57.677633	\N	$pbkdf2-sha512$25000$y3lvrfXe./.fs1ZKCcEYAw$Qr193XqTBE.EKBIYlVjresnT1jizajqTrztMpaf5FUZnN8k5m.fWzFzDc7I44W7j87t.VcH.J9r2ZEJmHCoDYQ	Admin Dinas Pekerjaan Umum & Penataan Ruang	pupr@gmail.com	\N	f	f	active	\N		\N
268d7f9c-81a0-4f26-bb02-2a3eaa520386	admin_pppa	\N	2026-06-16 05:18:42.92471	\N	$pbkdf2-sha512$25000$IKQUwniPce79XwshBECoNQ$S2cqVB2/0c2eXq2VPuLyAil439aTZldnL5yx5LFSwYZx3cErl4xz8SVx7KQcsod9TnY.Bg7sdc6AHGpZxlB82A	Admin Dinas Pemberdayaan Perempuan & Perlindungan Anak	pppa@gmail.com	\N	f	f	active	\N		\N
5637f386-24bd-4fe2-b369-33ad666b66d9	admin_dispora	\N	2026-06-16 05:19:36.275693	\N	$pbkdf2-sha512$25000$BYCwdq5VSmkNwVirtZZy7g$AUsiMUGn9qP/s4Z8xL0DtpULHe.Nz/QnKQuoNDQtatOlvY3TNcNXRQ7NSYZxZk39DJH0f8jXbYbidB1GGjwo4w	Admin Dinas Pemuda & Olahraga	dispora@gmail.com	\N	f	f	active	\N		\N
56f6a936-9632-4958-955b-fee71c1354a4	admin_ptsp	\N	2026-06-16 05:20:43.267601	\N	$pbkdf2-sha512$25000$ZYxRSsk5p1QqpbT2PkcopQ$9caurHIGGi0BTvd5lz1jL0st5aR8SSPRf1V4aNScMi76btdJTGksNKNk6m.Pyzk5GcHLS.V8gPV5E7TZXjoOfA	Admin Dinas Penanaman Modal & Pelayanan Terpadu Satu Pintu	ptsp@gmail.com	\N	f	f	active	\N		\N
934c8103-6c93-44e8-9bb4-18bed33b43ce	admin_dikbud	\N	2026-06-16 05:21:51.958411	\N	$pbkdf2-sha512$25000$m5MypnRujTEmZOwdI6RUag$VxDlNVRp68lYYuaUy1vqOrLY/cS5YRoGrzepGe3F8GdI1D8ssR1hloznVmINpg4opIeDo10MuvZNMTJ4n0BJ6g	Admin Dinas Pendidikan & Kebudayaan	dikbud@gmail.com	\N	f	f	active	\N		\N
b81e9f9a-b86b-41ce-b3e3-a5eb2f7cfe14	admin_disdagkop	\N	2026-06-16 05:24:00.753711	\N	$pbkdf2-sha512$25000$jHEuxTiH0JqTco6R0rr3Pg$uFWnv7knrALAm/gIBvM/HBrlJEweMMprPJJcGHGRcVWLo/qHAuW4lOXDfaFxq13MoiD7cCROkd3K53kas1yQ.w	Admin Dinas Perdagangan, Koperasi & UKM	disdagkop@gmail.com	\N	f	f	active	\N		\N
a6d80551-94ff-45fa-a962-45f7e6ac9b5e	admin_dppkb	\N	2026-06-16 05:22:51.676878		$pbkdf2-sha512$25000$0vq/V0qJESIkpDRmLAUgpA$SkhVYq7UNYbmjY.IdTl04oNKB864vMpSWEW7FULe61sH9rK1dz5LOluJHf3au0vSn8yim6bTd5YHwU9AelL4uA	Admin Dinas Pengendalian Penduduk & Keluarga Berencana	dppkb@gmail.com	\N	f	f	active	\N		\N
1850ca4d-4896-4b60-81ce-5d14b63249f8	admin_dishub	\N	2026-06-16 05:25:53.336114	\N	$pbkdf2-sha512$25000$7H0PwXivlVJqrRXCOIdQSg$ycd31F8A4qSUbzlGPKEAg63GjHMVATvhV5T0N5G2yiLm63PoAYqzMnxEN7PJSAfTzaE/yWKGFD09kEHn9uCO/Q	Admin Dinas Perhubungan	dishub@gmail.com	\N	f	f	active	\N		\N
cd5886d0-db01-45b0-b40e-a041e3a91ade	admin_diskan	\N	2026-06-16 05:26:30.314495	\N	$pbkdf2-sha512$25000$KuW8F4IQwtgbQ6g1JkTI2Q$KVYfqJQ6oXGi4crNyQWgvMGY5NV/f5MGQpD7FszGR8OscYmxOODmUNLRsrKyLyz1EzkYnFT/fNTkUGOTjv23/A	Admin Dinas Perikanan	diskan@gmail.com	\N	f	f	active	\N		\N
b9f93bb1-fe46-41f6-84e3-c192e4edcfa6	admin_dispersip	\N	2026-06-16 05:27:44.424841	\N	$pbkdf2-sha512$25000$BYAwJmQMoXTuXUsJgZCS8g$TQeYMouH3wYf.xhT9Phba1m07AqFFL8aVai5mxQ4Lf0fRqkWqiJlfLf6gxuLrGzhVMDCnyU6.qiZ/ZdZnCb3qQ	Admin Dinas Perpustakaan & Kearsipan	dispersip@gmail.com	\N	f	f	active	\N		\N
903e974e-e87b-429c-be07-fa30ecf451ec	admin_dispertan	\N	2026-06-16 05:28:31.04091	\N	$pbkdf2-sha512$25000$0Rqj1Lp3Tkmpde4d45zzXg$0l.6k6hJCySGstrvCNpnz7SWHa.ylv0QMq9r5v7lZWRA8gw1.i6GbY6WZbMdzmzKyjNX0WAE6y2ht7pSiVycig	Admin Dinas Pertanian	dispertan@gmail.com	\N	f	f	active	\N		\N
48835434-f85e-4d1d-9432-505392deee4f	admin_disperkim	\N	2026-06-16 05:29:44.173507	\N	$pbkdf2-sha512$25000$HSNk7P1f6927txZiLMV4rw$I6YENWO14lafdrpriTVvtdXRFf2SeIaeFLuE0o341005./DURhP6F1y1BPgz8Zw14RMRDoTrZ5z/14nFDSRHPg	Admin Dinas Perumahan, Kawasan Permukiman & Pertanahan	disperkim@gmail.com	\N	f	f	active	\N		\N
f5e5b358-3b9e-4546-8146-3963034e9ca6	admin_dinsos	\N	2026-06-16 05:30:22.425002	\N	$pbkdf2-sha512$25000$D2HMGaOUkjJGCKF0TokR4g$oTrT0/qNnTOyAg28tuNpYlwybLXN8lI47mnjLaODcb5PrMiOEYveUOdchsib.ZRLRpw2zTlA55fPh4fmB2o0lA	Admin Dinas Sosial	dinsos@gmail.com	\N	f	f	active	\N		\N
78c9a180-dc15-409f-b6d2-e1cf8c285298	admin_disperinaker	\N	2026-06-16 05:31:05.943292	\N	$pbkdf2-sha512$25000$/r/XWovx/v.fs1aKce793w$G5465Q5KrOJCnaW8iswzd06zDSf7kVQ2jNFuql4cyUwiNKSBfkKUnbZQf4W7yZ.U8fmztIFC9YDoyUmw8n0lqw	Admin Dinas Tenaga Kerja & Perindustrian	disperinaker@gmail.com	\N	f	f	active	\N		\N
3d8a85b7-48b4-4980-95a2-d9bc3bbfbfa9	admin_inspektorat	\N	2026-06-16 05:31:42.980784	\N	$pbkdf2-sha512$25000$DQFAaO19bw2BkPJ.TwnBuA$XvVZZ5aw4MbJbqfbEfqetIWmPjXyZz.gX32RWD7KMWapLiwbLC7MloxUXSoPDWi40Z9Kr7LZhhb7fM5oujcSRw	Admin Inspektorat	inspektorat@gmail.com	\N	f	f	active	\N		\N
1ecba460-a929-4fd0-918d-da926ace8d0f	ckan_admin	\N	2026-06-07 15:34:52.070761	Akun Superadmin CKAN Satudata Kota Kendari	$pbkdf2-sha512$25000$.7/3/p8TQmiNkbL23ts7pw$1v8Okyj6uGoPLKAqD8ARLRvW9VlERBIE0cLZlLtdb2ciS/EmM1jn7rTpwQ.hgfoF4MqBxBDoiwYkXWLQPN0BJg	Administrator	ilmifaizan1112@gmail.com	130e6d08e25142ebdba41629b804a2b9	t	f	active	\N	2026-06-08-053303.105869admin.png	2026-06-16 05:31:53.028164
2c5c2e38-31f5-43fd-bfe5-67bb1154a544	admin_satpolpp	\N	2026-06-16 05:32:47.082852	\N	$pbkdf2-sha512$25000$JoTQmpNy7j3HWKs15vw/hw$OL4jCcKrkYubyg8n0ktuKyvfkPEw1Ry76MNG3Nh8Von4kLzbZkX2BNxXSJ5D0.q9ToiG..Al1EpuP6224C1HFw	Admin Satuan Polisi Pamong Praja	satpolpp@gmail.com	\N	f	f	active	\N		\N
\.


--
-- Data for Name: user_following_dataset; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.user_following_dataset (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: user_following_group; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.user_following_group (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: user_following_user; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.user_following_user (follower_id, object_id, datetime) FROM stdin;
\.


--
-- Data for Name: vocabulary; Type: TABLE DATA; Schema: public; Owner: ckan_default
--

COPY public.vocabulary (id, name) FROM stdin;
\.


--
-- Name: system_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ckan_default
--

SELECT pg_catalog.setval('public.system_info_id_seq', 8, true);


--
-- Name: activity_detail activity_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.activity_detail
    ADD CONSTRAINT activity_detail_pkey PRIMARY KEY (id);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: api_token api_token_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.api_token
    ADD CONSTRAINT api_token_pkey PRIMARY KEY (id);


--
-- Name: dashboard dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.dashboard
    ADD CONSTRAINT dashboard_pkey PRIMARY KEY (user_id);


--
-- Name: file_owner file_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.file_owner
    ADD CONSTRAINT file_owner_pkey PRIMARY KEY (file_id);


--
-- Name: file_owner_transfer_history file_owner_transfer_history_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.file_owner_transfer_history
    ADD CONSTRAINT file_owner_transfer_history_pkey PRIMARY KEY (id);


--
-- Name: file file_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);


--
-- Name: group group_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_name_key UNIQUE (name);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: package_member package_member_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_member
    ADD CONSTRAINT package_member_pkey PRIMARY KEY (package_id, user_id);


--
-- Name: package package_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package
    ADD CONSTRAINT package_name_key UNIQUE (name);


--
-- Name: package package_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package
    ADD CONSTRAINT package_pkey PRIMARY KEY (id);


--
-- Name: package_relationship package_relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_relationship
    ADD CONSTRAINT package_relationship_pkey PRIMARY KEY (id);


--
-- Name: package_tag package_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_tag
    ADD CONSTRAINT package_tag_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_view resource_view_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.resource_view
    ADD CONSTRAINT resource_view_pkey PRIMARY KEY (id);


--
-- Name: system_info system_info_key_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.system_info
    ADD CONSTRAINT system_info_key_key UNIQUE (key);


--
-- Name: system_info system_info_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.system_info
    ADD CONSTRAINT system_info_pkey PRIMARY KEY (id);


--
-- Name: tag tag_name_vocabulary_id_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_name_vocabulary_id_key UNIQUE (name, vocabulary_id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: task_status task_status_entity_id_task_type_key_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.task_status
    ADD CONSTRAINT task_status_entity_id_task_type_key_key UNIQUE (entity_id, task_type, key);


--
-- Name: task_status task_status_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.task_status
    ADD CONSTRAINT task_status_pkey PRIMARY KEY (id);


--
-- Name: user_following_dataset user_following_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_dataset
    ADD CONSTRAINT user_following_dataset_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user_following_group user_following_group_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_group
    ADD CONSTRAINT user_following_group_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user_following_user user_following_user_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_user
    ADD CONSTRAINT user_following_user_pkey PRIMARY KEY (follower_id, object_id);


--
-- Name: user user_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_name_key UNIQUE (name);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: vocabulary vocabulary_name_key; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.vocabulary
    ADD CONSTRAINT vocabulary_name_key UNIQUE (name);


--
-- Name: vocabulary vocabulary_pkey; Type: CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.vocabulary
    ADD CONSTRAINT vocabulary_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_detail_activity_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_activity_detail_activity_id ON public.activity_detail USING btree (activity_id);


--
-- Name: idx_activity_object_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_activity_object_id ON public.activity USING btree (object_id, "timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_activity_user_id ON public.activity USING btree (user_id, "timestamp");


--
-- Name: idx_extra_grp_id_pkg_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_extra_grp_id_pkg_id ON public.member USING btree (group_id, table_id);


--
-- Name: idx_file_location_in_storage; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE UNIQUE INDEX idx_file_location_in_storage ON public.file USING btree (storage, location);


--
-- Name: idx_group_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_group_id ON public."group" USING btree (id);


--
-- Name: idx_group_name; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_group_name ON public."group" USING btree (name);


--
-- Name: idx_group_pkg_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_group_pkg_id ON public.member USING btree (table_id);


--
-- Name: idx_only_one_active_email_no_case; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE UNIQUE INDEX idx_only_one_active_email_no_case ON public."user" USING btree (lower(email)) WHERE (state = 'active'::text);


--
-- Name: idx_owner_owner; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_owner_owner ON public.file_owner USING btree (owner_type, owner_id);


--
-- Name: idx_package_creator_user_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_creator_user_id ON public.package USING btree (creator_user_id);


--
-- Name: idx_package_group_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_group_id ON public.member USING btree (id);


--
-- Name: idx_package_resource_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_resource_id ON public.resource USING btree (id);


--
-- Name: idx_package_resource_package_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_resource_package_id ON public.resource USING btree (package_id);


--
-- Name: idx_package_resource_url; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_resource_url ON public.resource USING btree (url);


--
-- Name: idx_package_tag_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_tag_id ON public.package_tag USING btree (id);


--
-- Name: idx_package_tag_pkg_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_tag_pkg_id ON public.package_tag USING btree (package_id);


--
-- Name: idx_package_tag_pkg_id_tag_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_package_tag_pkg_id_tag_id ON public.package_tag USING btree (tag_id, package_id);


--
-- Name: idx_pkg_lname; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_lname ON public.package USING btree (lower((name)::text));


--
-- Name: idx_pkg_sid; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_sid ON public.package USING btree (id, state);


--
-- Name: idx_pkg_slname; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_slname ON public.package USING btree (lower((name)::text), state);


--
-- Name: idx_pkg_sname; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_sname ON public.package USING btree (name, state);


--
-- Name: idx_pkg_stitle; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_stitle ON public.package USING btree (title, state);


--
-- Name: idx_pkg_suname; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_suname ON public.package USING btree (upper((name)::text), state);


--
-- Name: idx_pkg_uname; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_pkg_uname ON public.package USING btree (upper((name)::text));


--
-- Name: idx_tag_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_tag_id ON public.tag USING btree (id);


--
-- Name: idx_tag_name; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_tag_name ON public.tag USING btree (name);


--
-- Name: idx_user_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_user_id ON public."user" USING btree (id);


--
-- Name: idx_user_name; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_user_name ON public."user" USING btree (name);


--
-- Name: idx_user_name_index; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_user_name_index ON public."user" USING btree ((
CASE
    WHEN ((fullname IS NULL) OR (fullname = ''::text)) THEN name
    ELSE fullname
END));


--
-- Name: idx_view_resource_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX idx_view_resource_id ON public.resource_view USING btree (resource_id);


--
-- Name: term_lang; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX term_lang ON public.term_translation USING btree (term, lang_code);


--
-- Name: tracking_raw_access_timestamp; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_raw_access_timestamp ON public.tracking_raw USING btree (access_timestamp);


--
-- Name: tracking_raw_url; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_raw_url ON public.tracking_raw USING btree (url);


--
-- Name: tracking_raw_user_key; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_raw_user_key ON public.tracking_raw USING btree (user_key);


--
-- Name: tracking_summary_date; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_summary_date ON public.tracking_summary USING btree (tracking_date);


--
-- Name: tracking_summary_package_id; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_summary_package_id ON public.tracking_summary USING btree (package_id);


--
-- Name: tracking_summary_url; Type: INDEX; Schema: public; Owner: ckan_default
--

CREATE INDEX tracking_summary_url ON public.tracking_summary USING btree (url);


--
-- Name: activity_detail activity_detail_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.activity_detail
    ADD CONSTRAINT activity_detail_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activity(id);


--
-- Name: api_token api_token_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.api_token
    ADD CONSTRAINT api_token_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: dashboard dashboard_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.dashboard
    ADD CONSTRAINT dashboard_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: file_owner file_owner_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.file_owner
    ADD CONSTRAINT file_owner_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file(id) ON DELETE CASCADE;


--
-- Name: member member_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_group_id_fkey FOREIGN KEY (group_id) REFERENCES public."group"(id);


--
-- Name: file_owner_transfer_history owner_transfer_history_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.file_owner_transfer_history
    ADD CONSTRAINT owner_transfer_history_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file_owner(file_id) ON DELETE CASCADE;


--
-- Name: package_member package_member_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_member
    ADD CONSTRAINT package_member_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.package(id);


--
-- Name: package_member package_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_member
    ADD CONSTRAINT package_member_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: package_relationship package_relationship_object_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_relationship
    ADD CONSTRAINT package_relationship_object_package_id_fkey FOREIGN KEY (object_package_id) REFERENCES public.package(id);


--
-- Name: package_relationship package_relationship_subject_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_relationship
    ADD CONSTRAINT package_relationship_subject_package_id_fkey FOREIGN KEY (subject_package_id) REFERENCES public.package(id);


--
-- Name: package_tag package_tag_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_tag
    ADD CONSTRAINT package_tag_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.package(id);


--
-- Name: package_tag package_tag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.package_tag
    ADD CONSTRAINT package_tag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id);


--
-- Name: resource resource_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.package(id);


--
-- Name: resource_view resource_view_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.resource_view
    ADD CONSTRAINT resource_view_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tag tag_vocabulary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_vocabulary_id_fkey FOREIGN KEY (vocabulary_id) REFERENCES public.vocabulary(id);


--
-- Name: user_following_dataset user_following_dataset_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_dataset
    ADD CONSTRAINT user_following_dataset_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_dataset user_following_dataset_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_dataset
    ADD CONSTRAINT user_following_dataset_object_id_fkey FOREIGN KEY (object_id) REFERENCES public.package(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_group user_following_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_group
    ADD CONSTRAINT user_following_group_group_id_fkey FOREIGN KEY (object_id) REFERENCES public."group"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_group user_following_group_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_group
    ADD CONSTRAINT user_following_group_user_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_user user_following_user_follower_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_user
    ADD CONSTRAINT user_following_user_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_following_user user_following_user_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ckan_default
--

ALTER TABLE ONLY public.user_following_user
    ADD CONSTRAINT user_following_user_object_id_fkey FOREIGN KEY (object_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict iwKjTABby3HbMpfQhw9bA6BevoFg5TANy4eQnONfpUJHDczndGcgn2PFVABuxJH

