print "Using native PostgreSQL\n"

#require 'logger'
#ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'rails_sql_views_unittest' => {
    :adapter  => :postgresql,
    :username => 'rails',
    :password => 'rails',
    :host     => 'localhost',
    :database => 'rails_sql_views_unittest',
    :encoding => 'utf8',
    :schema_file => 'schema.sql',
  }
}

ActiveRecord::Base.establish_connection 'rails_sql_views_unittest'

puts "Resetting database"
conn = ActiveRecord::Base.connection
#conn.recreate_database(conn.current_database)
conn.reconnect!
lines = open(File.join(File.dirname(__FILE__), ActiveRecord::Base.configurations['rails_sql_views_unittest'][:schema_file])).readlines
lines.join.split(';').each { |line| conn.execute(line) }
conn.reconnect!