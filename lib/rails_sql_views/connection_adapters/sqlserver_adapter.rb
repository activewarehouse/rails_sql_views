module RailsSqlViews
  module ConnectionAdapters
    module SQLServerAdapter
      # Returns true as this adapter supports views.
      def supports_views?
        true
      end
      
      # Get all of the non-view tables from the currently connected schema
      def base_tables(name = nil)
        # this is untested
        select_values("SELECT table_name FROM information_schema.tables", name)
      end
      alias nonview_tables base_tables
      
      # Returns all the view names from the currently connected schema.
      def views(name = nil)
        select_values("SELECT table_name FROM information_schema.views", name)
      end
      
      # Get the view select statement for the specified view.
      def view_select_statement(view, name=nil)
        q =<<-ENDSQL
          SELECT view_definition FROM information_schema.views
          WHERE table_name = '#{view}'
        ENDSQL
        
        view_def = select_value(q, name)
        
        if view_def
          return convert_statement(view_def)
        else
          raise "No view called #{view} found"
        end
      end
      
      private
      def convert_statement(s)
        s.gsub(/\n/, ' ').sub(/.*CREATE VIEW.* AS.* (SELECT .*)/i, '\1')
      end
    end
  end
end
