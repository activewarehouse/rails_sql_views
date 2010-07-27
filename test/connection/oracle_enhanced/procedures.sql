create or replace
procedure dropTable (tab_name varchar2) as
  this_tab_name user_tables.table_name%type;
    cursor table_cur is
      select table_name
      from user_tables
      where table_name = tab_name;
begin
  open table_cur;
  loop
    fetch table_cur into this_tab_name;
    exit when table_cur%notfound;
    execute immediate 'drop table "' || this_tab_name || '"';
  end loop;
end;
