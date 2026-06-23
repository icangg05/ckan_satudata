-- User & database utama CKAN
CREATE ROLE ckan NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'supersecurepassword123';
CREATE DATABASE ckan OWNER ckan ENCODING 'utf-8';

-- User read-only datastore + database datastore (owner = user write "ckan").
-- Grant SELECT untuk datastore_ro diterapkan oleh "ckan datastore set-permissions"
-- yang dijalankan di entrypoint.sh.
CREATE ROLE datastore_ro NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'supersecurepassword123';
CREATE DATABASE datastore OWNER ckan ENCODING 'utf-8';
