module RailsSqlViews
  module ConnectionAdapters # :nodoc:
    module SchemaStatements
      # Create a view.
      # The +options+ hash can include the following keys:
      # [<tt>:check_option</tt>]
      #   Specify restrictions for inserts or updates in updatable views. ANSI SQL 92 defines two check option
      #   values: CASCADED and LOCAL. See your database documentation for allowed values.
      def create_view(name, select_query, options={})
        if supports_views?
          view_definition = ViewDefinition.new(self, select_query)

          yield view_definition

          if options[:force]
            drop_view(name) rescue nil
          end

          create_sql = "CREATE VIEW "
          create_sql << "#{name} ("
          create_sql << view_definition.to_sql
          create_sql << ") AS #{view_definition.select_query}"
          create_sql << " WITH #{options[:check_option]} CHECK OPTION" if options[:check_option]
          execute create_sql
        end
      end

      # Also creates a view, with the specific purpose of remapping column names
      # to make non-ActiveRecord tables friendly with the naming
      # conventions, while maintaining legacy app compatibility.
      def create_mapping_view(old_name, new_name, options = {})
        return unless supports_views?
        
        col_names = columns(old_name).collect { |col| col.name.to_sym }
        mapper = MappingDefinition.new(col_names)
        
        yield mapper
        
        if options[:force]
          drop_view(new_name) rescue nil
        end

        view_sql = "CREATE VIEW #{new_name} (#{mapper.view_cols.join(', ')}) "
        view_sql << "AS SELECT #{mapper.select_cols.join(', ')} FROM #{old_name}"
        execute view_sql
      end
      
      # Drop a view.
      # The +options+ hash can include the following keys:
      # [<tt>:drop_behavior</tt>]
      #   Specify the drop behavior. ANSI SQL 92 defines two drop behaviors, CASCADE and RESTRICT. See your
      #   database documentation to determine what drop behaviors are available.
      def drop_view(name, options={})
        if supports_views?
          drop_sql = "DROP VIEW #{name}"
          drop_sql << " #{options[:drop_behavior]}" if options[:drop_behavior]
          execute drop_sql
        end
      end
    end
  end
end