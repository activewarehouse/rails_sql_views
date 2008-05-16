drop table people CASCADE;
create table people (
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
drop table people2 CASCADE;
create table people2 (
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
drop table places CASCADE;
create table places (
	address text,
	city char(255),
	state char(255),
	country char(2)
);
