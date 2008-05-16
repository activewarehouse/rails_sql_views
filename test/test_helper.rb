$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'test/unit'
require 'pp'
require 'rails_sql_views'
require 'flexmock/test_unit'

$connection = (ENV['DB'] || 'native_mysql')
require "connection/#{$connection}/connection"

require 'models/person'
require 'models/person2'
require 'models/v_person'

class Test::Unit::TestCase
  def create_person_view
    ActiveRecord::Base.connection.create_view(:v_person, 'select * from people', :force => true) do |v|
      v.column :f_name
      v.column :l_name
      v.column :social_security
    end
  end
end