print "Using native PostgreSQL\n"

adapter_name = 'postgresql'
config = YAML.load_file(File.join(File.dirname(__FILE__), '/../../connection.yml'))[adapter_name]

#require 'logger'
#ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.configurations = {
  'rails_sql_views_unittest' => {
    :adapter  => adapter_name,
    :username => config['username'],
    :password => config['password'],
    :host     => config['host'],
    :database => config['database'],
    :encoding => config['encoding'],
    :schema_file => config['schema_file'],
  }
}

ActiveRecord::Base.establish_connection config['database']

puts "Resetting database"
conn = ActiveRecord::Base.connection
#conn.recreate_database(conn.current_database)
conn.reconnect!
lines = open(File.join(File.dirname(__FILE__), ActiveRecord::Base.configurations[config['database']][:schema_file])).readlines
lines.join.split(';').each { |line| conn.execute(line) }
conn.reconnect!
