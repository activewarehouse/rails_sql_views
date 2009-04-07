drop table if exists people CASCADE;
create table people (
  id serial primary key,
  first_name char(255),
  last_name char(255),
  ssn char(64)
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
