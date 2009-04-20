module RailsSqlViews
  module ConnectionAdapters
    module AbstractAdapter
      def self.included(base)
        base.alias_method_chain :disable_referential_integrity, :views_excluded
      end

      # Subclasses should override and return true if they support views.
      def supports_views?
        return false
      end
      
      def disable_referential_integrity_with_views_excluded(&block)
        self.class.send(:alias_method, :tables, :base_tables)
        disable_referential_integrity_without_views_excluded(&block)
      ensure
        self.class.send(:alias_method, :tables, :tables_with_views_included)
      end
      
      def supports_view_columns_definition?
        true
      end
      
      # Get a list of all views for the current database
      def views(name = nil)
        raise NotImplementedError, "views is an abstract method"
      end
      
      # Get the select statement for the specified view
      def view_select_statement(view, name=nil)
        raise NotImplementedError, "view_select_statement is an abstract method"
      end
    end
  end
end
