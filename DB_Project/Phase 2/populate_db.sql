-- How to run loading of data
-- Be sure to provide the datadir variable with psql command; we can then change to this directory and load the CSVs from the repo
-- psql -vdatadir="$HOME/6400Spring19Team075/Phase 2/data" -f populate_db.sql
--  *note this is required for the command to work  -vdatadir="$HOME/6400Spring19Team075/Phase 2/data"


-- change to directory where the CSVs are
\cd :datadir
\COPY state FROM 'states.csv' DELIMITER ',' CSV;

\COPY city FROM 'city.csv' DELIMITER ',' CSV;
select setval('sedw.city_id_seq'  , max(id)) from sedw.city;

\COPY manager FROM 'manager.csv' DELIMITER ',' CSV;

\COPY holiday FROM 'holiday.csv' DELIMITER ',' CSV;
select setval('sedw.holiday_id_seq'  , max(id)) from sedw.holiday;


-- remove rows from sells
truncate sells;
-- all stores sell all items; take product of both tables
insert  into sells select store_number, pid from store, product;

