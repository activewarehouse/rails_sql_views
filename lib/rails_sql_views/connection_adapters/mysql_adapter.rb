module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      def tables(name = nil) #:nodoc:
        tables = []
        execute("SHOW TABLE STATUS", name).each { |row| tables << row[0] if row[17] != 'VIEW' }
        tables
      end
      
      def views(name = nil) #:nodoc:
        views = []
        execute("SHOW TABLE STATUS", name).each { |row| views << row[0] if row[17] == 'VIEW' }
        views
      end
      
      # Get the view select statement for the specified table.
      def view_select_statement(view, name=nil)
        begin
          row = execute("SHOW CREATE VIEW #{view}", name).each do |row|
            return convert_statement(row[1]) if row[0] == view
          end
        rescue ActiveRecord::StatementInvalid => e
          raise "No view called #{view} found"
        end
      end
      
      private
      def convert_statement(s)
        s.gsub!(/.* AS (select .*)/, '\1')
      end
    end
  end
end