module RailsSqlViews
  module ConnectionAdapters
    module Mysql2Adapter
      def self.included(base)
        if base.private_method_defined?(:supports_views?)
          base.send(:public, :supports_views?)
        end
      end

      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      def base_tables(name = nil, database = nil, like = nil) #:nodoc:
        sql = "SHOW FULL TABLES "
        sql << "IN #{quote_table_name(database)} " if database
        
        if database && like
          sql << "WHERE TABLE_TYPE='BASE TABLE' "
          c = "TABLES_IN_#{database.upcase}"
          sql << "AND #{quote_table_name(c)} LIKE #{quote(like)}"
        elsif like
          sql << "LIKE #{quote(like)}"
        else
          sql << "WHERE TABLE_TYPE='BASE TABLE' "
        end

        execute_and_free(sql, 'SCHEMA') do |result|
          result = result.select {|field| field.last == 'BASE TABLE' } unless database
          result.collect { |field| field.first }
        end
      end
      alias nonview_tables base_tables
      
      def views(name = nil) #:nodoc:
        views = []
        execute("SHOW FULL TABLES WHERE TABLE_TYPE='VIEW'").each{|row| views << row[0]}
        views
      end

      def tables_with_views_included(name = nil)
        nonview_tables(name) + views(name)
      end
      
      def structure_dump
        structure = ""
        base_tables.each do |table|
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
