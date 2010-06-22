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
      
      # Sort views by independence.
      #
      # A view X depends on a view Y if Y's quoted name appears in X's view select statement.
      def sorted_views
        # Views can depend on many views, and be depended on by many other views.
        # However, they won't form dependency cycles.  Therefore we're holding a DAG
        # So, do a topological sort:
        
        # The sql creating each view.
        sql = Hash[views.collect { |view| [view, view_select_statement(view).dump.downcase] }]
        
        # Build the needed hash of views -> lists of requirements
        requirements = THash.new
        
        views.each do |view|
          requirements[view] = views.select do |requirement|
            sql[view].include? quote_table_name(requirement.downcase)
          end
        end
        
        requirements.tsort
      end
    end
  end
end
