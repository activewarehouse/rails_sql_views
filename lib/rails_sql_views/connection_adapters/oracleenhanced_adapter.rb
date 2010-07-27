module RailsSqlViews
  module ConnectionAdapters
    module OracleEnhancedAdapter
      def self.included(base)
        base.alias_method_chain :tables, :views_included
      end
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      def tables_with_views_included(name = nil)
        tables = []
        sql = " SELECT TABLE_NAME FROM USER_TABLES
                UNION
                SELECT VIEW_NAME AS TABLE_NAME FROM USER_VIEWS"
        cursor = execute(sql, name)
        while row = cursor.fetch
          tables << row[0].downcase
        end
        tables
      end
      
      def base_tables(name = nil) #:nodoc:
        tables = []
        cursor = execute("SELECT TABLE_NAME FROM USER_TABLES", name)
        while row = cursor.fetch
          tables << row[0].downcase
        end
        tables
      end
      alias nonview_tables base_tables
      
      def views(name = nil) #:nodoc:
        views = []
        cursor = execute("SELECT VIEW_NAME FROM USER_VIEWS", name)
        while row = cursor.fetch
          views << row[0].downcase
        end
        views
      end
      
      # Get the view select statement for the specified table.
      def view_select_statement(view, name=nil)
        view.upcase!
        cursor = execute("SELECT TEXT FROM USER_VIEWS WHERE VIEW_NAME = '#{view}'", name)
        if row = cursor.fetch
          return row[0]
        else
          raise "No view called #{view} found"
        end
      end
    end
  end
end
