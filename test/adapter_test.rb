require "#{File.dirname(__FILE__)}/test_helper"

class AdapterTest < Test::Unit::TestCase
  def test_current_database
    if ActiveRecord::Base.connection.respond_to?(:current_database)
      assert_equal 'rails_sql_views_unittest', ActiveRecord::Base.connection.current_database
    end
  end
  def test_tables
    create_view
    found = ActiveRecord::Base.connection.tables.sort
    found.delete(ActiveRecord::Migrator.schema_migrations_table_name)
    assert_equal ["items", "items_people", "people", "people2", "places", "v_people"], found
  end
  def test_base_tables
    create_view
    found = ActiveRecord::Base.connection.base_tables.sort
    found.delete(ActiveRecord::Migrator.schema_migrations_table_name)
    assert_equal ["items", "items_people", "people", "people2", "places"], found
  end
  def test_views
    create_view
    assert_equal ['v_people'], ActiveRecord::Base.connection.views
  end
  def test_columns
    create_view
    assert_equal ["f_name", "l_name", "social_security"], ActiveRecord::Base.connection.columns('v_people').collect { |c| c.name }
  end
  def test_supports_views
    assert ActiveRecord::Base.connection.supports_views?
  end
  
  def test_mapped_views
    create_mapping
    assert_equal ['v_people'], ActiveRecord::Base.connection.views
  end
  def test_mapped_columns
    create_mapping
    assert_equal ["f_name", "l_name", "address_id"], ActiveRecord::Base.connection.columns('v_people').collect { |c| c.name }
  end
  
  def test_view_select_statement
    case ActiveRecord::Base.connection.adapter_name
    when "MySQL"
      assert_equal "select `people`.`first_name` AS `f_name`,`people`.`last_name` AS `l_name`,`people`.`ssn` AS `social_security` from `people`", ActiveRecord::Base.connection.view_select_statement('v_people')
    when "PostgreSQL"
      assert_equal "SELECT people.first_name AS f_name, people.last_name AS l_name, people.ssn AS social_security FROM people;", ActiveRecord::Base.connection.view_select_statement('v_people')
    end
  end
  
  def test_old_name_not_found_error_during_mapping
    assert_raise ActiveRecord::ActiveRecordError do
      ActiveRecord::Base.connection.create_mapping_view(:people, :v_people, :force => true) do |v|
        v.map_column :foo, :bar
      end
    end
  end
 
### TODO
#  def test_only_base_table_triggers_are_dropped_for_disabled_ref_integrity
#    ActiveRecord::Base.connection.disable_referential_integrity do
#    end
#  end
  
  private
  def create_view
    ActiveRecord::Base.connection.create_view(:v_people, 'select first_name, last_name, ssn from people', :force => true) do |v|
      v.column :f_name
      v.column :l_name
      v.column :social_security
    end
  end
  
  def create_mapping
    ActiveRecord::Base.connection.create_mapping_view(:people, :v_people, :force => true) do |v|
      v.map_column :id, nil
      v.map_column :first_name, :f_name
      v.map_column :last_name, :l_name
      v.map_column :ssn, nil
    end
  end
end
