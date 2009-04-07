drop table if exists people CASCADE;
create table people (
  id serial primary key,
  first_name char(255),
  last_name char(255),
  ssn char(64),
  address_id integer
);
drop table if exists people2 CASCADE;
create table people2 (
  id serial primary key,
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
drop table if exists places CASCADE;
create table places (
  id serial primary key,
  address text,
  city char(255),
  cstate char(255),
  country char(2)
);
drop table if exists items CASCADE;
create table items (
  id serial primary key,
  person_id integer
);
drop table if exists items_people CASCADE;
create table items_people (
  person_id integer,
  item_id integer
);
