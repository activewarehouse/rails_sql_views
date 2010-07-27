BEGIN
  dropTable('PEOPLE');
  EXECUTE IMMEDIATE 'create table people (
    id integer primary key,
    first_name varchar2(255),
    last_name varchar2(255),
    ssn varchar2(64),
    address_id integer
  )';
  
  dropTable('PEOPLE2');
  EXECUTE IMMEDIATE 'create table people2 (
    id integer primary key,
    first_name varchar2(255),
    last_name varchar2(255),
    ssn varchar2(64)
  )';
  
  dropTable('PLACES');
  EXECUTE IMMEDIATE 'create table places (
    id integer primary key,
    address varchar2(2000),
    city varchar2(255),
    cstate varchar2(255),
    country char(2)
  )';
  
  dropTable('ITEMS');
  EXECUTE IMMEDIATE 'create table items (
    id integer primary key,
    person_id integer
  )';
  
  dropTable('ITEMS_PEOPLE');
  EXECUTE IMMEDIATE 'create table items_people (
    person_id integer,
    item_id integer
  )';
END;
