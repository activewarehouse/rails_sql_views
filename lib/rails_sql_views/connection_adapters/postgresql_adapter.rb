module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      def views(name = nil) #:nodoc:
        q = <<-SQL
        SELECT table_name, table_type
          FROM information_schema.tables
         WHERE table_schema IN (#{schemas})
           AND table_type = 'VIEW'
        SQL
        
        query(q, name).map { |row| row[0] }
      end

      def view_select_statement(view, name = nil)
        q = <<-SQL
        SELECT view_definition
          FROM information_schema.views 
         WHERE table_catalog = (SELECT catalog_name FROM information_schema.information_schema_catalog_name)
           AND table_schema IN (#{schemas})
           AND table_name = '#{view}'
        SQL
        
        select_value(q, name) or raise "No view called #{view} found"
      end

      private
        
      def schemas
        schema_search_path.split(/,/).map { |p| quote(p) }.join(',')
      end
    end
  end
end
