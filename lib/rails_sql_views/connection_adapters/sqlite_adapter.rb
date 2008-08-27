module ActiveRecord
  module ConnectionAdapters
    class SQLiteAdapter
      def supports_views?
        true
      end
      
      def tables(name = nil) #:nodoc:
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE (type = 'table' OR type = 'view') AND NOT name = 'sqlite_sequence'
        SQL

        execute(sql, name).map do |row|
          row[0]
        end
      end

      def nonview_tables(name = nil)
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE (type = 'table') AND NOT name = 'sqlite_sequence'
        SQL

        execute(sql, name).map do |row|
          row[0]
        end        
      end
      
      def views(name = nil)
        sql = <<-SQL
          SELECT name
          FROM sqlite_master
          WHERE type = 'view' AND NOT name = 'sqlite_sequence'
        SQL

        execute(sql, name).map do |row|
          row[0]
        end
      end
      
      # Get the view select statement for the specified table.
      def view_select_statement(view, name = nil)
        sql = <<-SQL
          SELECT sql
          FROM sqlite_master
          WHERE name = '#{view}' AND NOT name = 'sqlite_sequence'
        SQL
        
        select_value(sql, name) or raise "No view called #{view} found"
      end
      
      def supports_view_columns_definition?
        false
      end
      
    end
  end
end