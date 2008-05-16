require "#{File.dirname(__FILE__)}/test_helper"
require 'active_record/schema_dumper'

class SchemaDumperTest < Test::Unit::TestCase
  def test_view
    create_person_view
    stream = StringIO.new
    dumper = ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.rewind
    assert_equal File.open(File.dirname(__FILE__) + "/schema.#{$connection}.out.rb", 'r').readlines, stream.readlines
  end
  def test_dump_and_load
    create_person_view
    assert_dump_and_load_succeed
  end
  def test_union
    Person.create(:first_name => 'Joe', :last_name => 'User', :ssn => '123456789')
    Person2.create(:first_name => 'Jane', :last_name => 'Doe', :ssn => '222334444')
    ActiveRecord::Base.connection.create_view(:v_profile, "(select * from people) UNION (select * from people2)", :force => true) do |v|
      v.column :first_name
      v.column :last_name
      v.column :ssn
    end
    assert_dump_and_load_succeed
  end
  def test_symbol_ignore
    ActiveRecord::SchemaDumper.ignore_views << :v_person
    create_person_view
    assert_dump_and_load_succeed
    ActiveRecord::SchemaDumper.ignore_views.pop
  end
  def test_regex_ignore
    ActiveRecord::SchemaDumper.ignore_views << Regexp.new(/v_person/)
    create_person_view
    assert_dump_and_load_succeed
    ActiveRecord::SchemaDumper.ignore_views.pop
  end
  def test_non_allowed_object_raises_error
    ActiveRecord::SchemaDumper.ignore_views << 0
    begin
      schema_file = File.dirname(__FILE__) + "/schema.#{$connection}.out.rb"
      File.open(schema_file, "w") do |file|
        assert_raise(StandardError) do
          ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
        end
      end
    ensure
      ActiveRecord::SchemaDumper.ignore_views.pop
    end
  end
  
  def test_logging_error
    ActiveRecord::SchemaDumper.ignore_views << 0
    old_logger = ActiveRecord::Base.logger
    
    begin
      mock_logger = flexmock('logger', :error => nil)
      mock_logger.should_receive(:error)
      ActiveRecord::Base.logger = mock_logger
      schema_file = File.dirname(__FILE__) + "/schema.#{$connection}.out.rb"
      File.open(schema_file, "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    ensure
      ActiveRecord::SchemaDumper.ignore_views.pop
      ActiveRecord::Base.logger = old_logger
    end
  end
  
  def assert_dump_and_load_succeed
    schema_file = File.dirname(__FILE__) + "/schema.#{$connection}.out.rb"
    assert_nothing_raised do
      File.open(schema_file, "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
    
    assert_nothing_raised do
      load(schema_file)
    end
  end
end