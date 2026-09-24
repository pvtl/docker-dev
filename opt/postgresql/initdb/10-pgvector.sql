-- POSTGRES_DB is template1 so the extension is installed before app databases exist.
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create the default application database from template1 so it inherits both extensions.
CREATE DATABASE root TEMPLATE template1;
