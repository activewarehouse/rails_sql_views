drop table if exists people;
create table people (
  id int(11) DEFAULT NULL auto_increment PRIMARY KEY,
  first_name char(255),
  last_name char(255),
  ssn char(64),
  address_id integer
);
drop table if exists people2;
create table people2 (
  id int(11) DEFAULT NULL auto_increment PRIMARY KEY,
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
drop table if exists places;
create table places (
  id int(11) DEFAULT NULL auto_increment PRIMARY KEY,
  address text,
  city char(255),
  cstate char(255),
  country char(2)
);
drop table if exists items;
create table items (
  id int(11) DEFAULT NULL auto_increment PRIMARY KEY,
  person_id int(11)
);
drop table if exists items_people;
create table items_people (
  person_id int(11),
  item_id int(11)
);