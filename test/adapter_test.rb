require "#{File.dirname(__FILE__)}/test_helper"

class AdapterTest < Test::Unit::TestCase
  def test_current_database
    if ActiveRecord::Base.connection.respond_to?(:current_database)
      assert_equal 'rails_sql_views_unittest', ActiveRecord::Base.connection.current_database
    end
  end
  def test_tables
    create_view
    assert_equal ["people", "people2", "places","v_person"], ActiveRecord::Base.connection.tables
  end
  def test_nonview_tables
    create_view
    assert_equal ["people", "people2", "places"], ActiveRecord::Base.connection.nonview_tables
  end
  def test_views
    create_view
    assert_equal ['v_person'], ActiveRecord::Base.connection.views
  end
  def test_columns
    create_view
    assert_equal ["f_name", "l_name", "social_security"], ActiveRecord::Base.connection.columns('v_person').collect { |c| c.name }
  end
  def test_supports_views
    assert ActiveRecord::Base.connection.supports_views?
  end
  
  def test_mapped_views
    create_mapping
    assert_equal ['v_person'], ActiveRecord::Base.connection.views
  end
  def test_mapped_columns
    create_mapping
    assert_equal ["f_name", "l_name"], ActiveRecord::Base.connection.columns('v_person').collect { |c| c.name }
  end
  
  def test_view_select_statement
    case ActiveRecord::Base.connection.adapter_name
    when "MySQL":
      assert_equal "select `people`.`first_name` AS `f_name`,`people`.`last_name` AS `l_name`,`people`.`ssn` AS `social_security` from `people`", ActiveRecord::Base.connection.view_select_statement('v_person')
    when "PostgreSQL":
      assert_equal "SELECT people.first_name AS f_name, people.last_name AS l_name, people.ssn AS social_security FROM people;", ActiveRecord::Base.connection.view_select_statement('v_person')
    end
  end
  
  def test_old_name_not_found_error_during_mapping
    assert_raise ActiveRecord::ActiveRecordError do
      ActiveRecord::Base.connection.create_mapping_view(:people, :v_person, :force => true) do |v|
        v.map_column :foo, :bar
      end
    end
  end
  
  private
  def create_view
    ActiveRecord::Base.connection.create_view(:v_person, 'select * from people', :force => true) do |v|
      v.column :f_name
      v.column :l_name
      v.column :social_security
    end
  end
  
  def create_mapping
    ActiveRecord::Base.connection.create_mapping_view(:people, :v_person, :force => true) do |v|
      v.map_column :first_name, :f_name
      v.map_column :last_name, :l_name
      v.map_column :ssn, nil
    end
  end
end
