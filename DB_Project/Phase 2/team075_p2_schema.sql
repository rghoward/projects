-- ---------------------------------------
-- Phase 2
-- Team 075 Spring 2019 
-- The SQL Below will create the databse and tables for SEDW
-- 
-- ---------------------------------------

/* 
 changelog=
      0.0.1 Initial version 
      0.0.2 Removed the PURCHASE_DAY Relation 
      0.0.3 Revised the active_manager/inactive_manager subtype and merged both into manager. 
            Added a enum for employment status on the manager entity and removed active/inactive entity due to duplicate values being tracked.
            When a manager becomes inactive we simply have to update the employment_status attribute on the manager entity.
      0.0.4 Adding state abbreviation enum
  Quick Ref: 
  To run the SQL:   psql -U postgres -W -d se_tech -f team075_p2_schema.sql #Password is team075
                    psql -U team075 -d se_tech -f team075_p2_schema.sql
  To connect to DB: psql -U team075 -d se_tech
*/

-- Cleans up database in order to run DDL SQL below
-- We are using CASCADE, this will drop all tables in sedw schema
-- DROP TABLE IF EXISTS MANUFACTURER; 
-- we can drop everything in schema and recreate
DROP SCHEMA IF EXISTS sedw CASCADE ;
-- DROP DATABASE IF EXISTS se_tech;
-- DROP ROLE IF EXISTS team075;
-- DROP SEQUENCE IF EXISTS city_id_seq;

-- create the user for sedw
-- CREATE ROLE team075 PASSWORD 'team075' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;

-- Create the database for SE Technology
-- CREATE DATABASE se_tech OWNER team075;

-- create the schema
CREATE SCHEMA sedw ;

-- Set the default search path for user upon logon
ALTER ROLE team075 SET search_path TO sedw;


-- Create the tables for datbase
-- Run this as team075 user

CREATE TYPE sedw.state_abbreviation AS ENUM ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV','WI', 'WY');
CREATE TABLE sedw.state (state_name varchar(50) NOT NULL PRIMARY KEY, abbrev sedw.state_abbreviation);

CREATE TABLE sedw.city (id integer not null primary key, state_name varchar(50) NOT NULL, city_name varchar(50) NOT NULL, population integer NOT NULL, FOREIGN KEY(state_name) REFERENCES sedw.state, UNIQUE(state_name, city_name));

CREATE SEQUENCE sedw.city_id_seq as integer start with 1 increment by 1 no minvalue no maxvalue cache 1;

ALTER SEQUENCE sedw.city_id_seq owned by sedw.city.id;

CREATE TABLE sedw.store (store_number integer NOT NULL PRIMARY KEY, phone_number varchar(50) NOT NULL, street_number varchar(50) NOT NULL, street_name varchar(50) NOT NULL, city_id integer, FOREIGN KEY(city_id) REFERENCES sedw.city (id));

CREATE TYPE sedw.employment_status AS ENUM ('active', 'inactive'); 
CREATE TABLE sedw.manager (email_address varchar(50) NOT NULL PRIMARY KEY, first_name varchar(50) NOT NULL, last_name varchar(50) NOT NULL, status sedw.employment_status not null default 'active');

CREATE TABLE sedw.managed_by (store_number integer NOT NULL, email_address varchar(50) NOT null, FOREIGN KEY(store_number) REFERENCES sedw.store, FOREIGN KEY(email_address) REFERENCES sedw.manager);

CREATE TABLE sedw.category (name varchar(255) NOT NULL PRIMARY KEY);

CREATE TABLE sedw.manufacturer (id integer primary key , name varchar(255) NOT NULL UNIQUE, maximum_discount FLOAT NOT NULL);

CREATE SEQUENCE sedw.manufacturer_id_seq as integer start with 1 increment by 1 no minvalue no maxvalue cache 1;

ALTER SEQUENCE sedw.manufacturer_id_seq owned by sedw.manufacturer.id;

CREATE TABLE sedw.product(pid integer NOT NULL PRIMARY KEY, retail_price FLOAT NOT NULL, name varchar(50) NOT NULL, manufacturer_id integer, FOREIGN KEY(manufacturer_id) REFERENCES sedw.manufacturer(id));

CREATE TABLE sedw.sells (store_number integer NOT NULL, pid integer NOT NULL, PRIMARY KEY(store_number, pid), FOREIGN KEY(store_number) REFERENCES sedw.store, FOREIGN KEY(pid) REFERENCES sedw.product (pid));

CREATE TABLE sedw.belongs_to (pid integer NOT NULL, name varchar(255) NOT NULL, PRIMARY KEY(pid, name), FOREIGN KEY(pid) REFERENCES sedw.product, FOREIGN KEY(name) REFERENCES sedw.category);

CREATE TABLE sedw.sale(sale_id integer NOT NULL, pid integer NOT NULL, sale_price FLOAT NOT NULL, FOREIGN KEY(pid) REFERENCES sedw.product, PRIMARY KEY(sale_id));

CREATE TABLE sedw.sale_sale_date(sale_id integer NOT NULL, sale_date date NOT NULL, PRIMARY KEY(sale_id, sale_date), FOREIGN KEY(sale_id) REFERENCES sedw.sale);

CREATE TABLE sedw.tracks_sold(store_number integer NOT NULL, pid integer NOT NULL, date date NOT NULL, quantity integer NOT NULL, PRIMARY KEY(store_number, pid, date), FOREIGN KEY(store_number) REFERENCES sedw.store, FOREIGN KEY(pid) REFERENCES sedw.product (pid));

CREATE TABLE sedw.holiday (id integer not null primary key, date date not null, name varchar(255) not null);
CREATE SEQUENCE sedw.holiday_id_seq as integer start with 1 increment by 1 no minvalue no maxvalue cache 1;
ALTER SEQUENCE sedw.holiday_id_seq owned by sedw.holiday.id;

-- Common view used by reports for store revenue
CREATE OR REPLACE VIEW sedw.store_revenue AS
 SELECT 
    s.store_number,
    s.street_number,
    s.street_name,
    c.city_name,
    date_part('year'::text, ts.date)::integer AS year,
    p.pid,
    p.name,
    ts.date,
    ts.quantity,
    round((COALESCE(sale.sale_price, p.retail_price) * ts.quantity::double precision)::numeric, 2) AS revenue
   FROM store s
     JOIN city c ON c.id = s.city_id AND c.state_name::text = 'New York'::text
     JOIN tracks_sold ts ON ts.store_number = s.store_number
     JOIN product p ON p.pid = ts.pid
     LEFT JOIN sale ON sale.pid = p.pid
     LEFT JOIN sale_sale_date sd ON sd.sale_id = sale.sale_id;


-- add perms to team075 user 
-- grant select on all tables in schema sedw to team075;
-- grant usage on schema sedw to team075;
-- grant connect on database se_tech to team075;
-- ALTER TABLE sedw.manufacturer owner to team075;
-- alter user team075 nosuperuser;

