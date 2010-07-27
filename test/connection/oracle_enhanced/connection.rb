print "Using Oracle Enhanced\n"

#require 'logger'
#ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'rails_sql_views_unittest' => {
    :adapter  => :oracle_enhanced,
    :username => 'rails_sql_views_unittest',
    :password => 'rails',
    :host     => 'localhost',
    :database => 'mydev',
    :encoding => 'utf8',
    :procedures_file  => 'procedures.sql',
    :schema_file      => 'schema.sql',
  }
}

ActiveRecord::Base.establish_connection 'rails_sql_views_unittest'

puts "Resetting database"
conn = ActiveRecord::Base.connection
#conn.recreate_database(conn.current_database)
conn.reconnect!
[:procedures_file, :schema_file].each do |file|
  lines = open(File.join(File.dirname(__FILE__), ActiveRecord::Base.configurations['rails_sql_views_unittest'][file])).readlines
  conn.execute(lines.to_s)
end
conn.reconnect!