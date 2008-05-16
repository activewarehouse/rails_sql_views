require "#{File.dirname(__FILE__)}/test_helper"

class ViewTest < Test::Unit::TestCase
  def test_create_view
    Person.create(:first_name => 'John', :last_name => 'Doe', :ssn => '123456789')
    assert_nothing_raised do
      ActiveRecord::Base.connection.create_view(:v_person, 'select * from people', :force => true) do |v|
        v.column :f_name
        v.column :l_name
        v.column :social_security
      end
    end
    p = Person.find(:first)
    vp = VPerson.find(:first)
    assert_equal p.first_name, vp.f_name
  end
  def test_drop_view
    assert_nothing_raised do
      ActiveRecord::Base.connection.create_view(:v_place, 'select * from places', :force => true) do |v|
        v.column :v_address
        v.column :v_city
        v.column :v_state
        v.column :v_country
      end
      ActiveRecord::Base.connection.drop_view(:v_place)
    end
    assert_raises(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute "SELECT * FROM v_place"
    end
  end
  def test_no_view_raises_error
    assert_raises(RuntimeError) { ActiveRecord::Base.connection.view_select_statement('foo') }
  end
end