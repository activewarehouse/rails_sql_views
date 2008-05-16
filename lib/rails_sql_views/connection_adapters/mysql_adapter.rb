module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      def nonview_tables(name = nil) #:nodoc:
        tables = []
        execute("SHOW FULL TABLES WHERE TABLE_TYPE='BASE TABLE'").each{|row| tables << row[0]}
        tables
      end
      
      def views(name = nil) #:nodoc:
        views = []
        execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'").each{|row| views << row[0]}
        views
      end
      
      def structure_dump
        structure = ""
        nonview_tables.each do |table|
          structure += select_one("SHOW CREATE TABLE #{quote_table_name(table)}")["Create Table"] + ";\n\n"
        end

        views.each do |view|
          structure += select_one("SHOW CREATE VIEW #{quote_table_name(view)}")["Create View"] + ";\n\n"
        end

        return structure
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
