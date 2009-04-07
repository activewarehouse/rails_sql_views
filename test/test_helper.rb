$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'pp'
require 'flexmock/test_unit'

require 'active_record'
$connection = (ENV['DB'] || 'native_mysql')
require "connection/#{$connection}/connection"
require 'rails_sql_views'

require 'models/person'
require 'models/person2'
require 'models/v_person'

class Test::Unit::TestCase
  def create_people_view
    ActiveRecord::Base.connection.create_view(:v_people,
        'select first_name, last_name, ssn from people', :force => true) do |v|
      v.column :f_name
      v.column :l_name
      v.column :social_security
    end
  end
end
