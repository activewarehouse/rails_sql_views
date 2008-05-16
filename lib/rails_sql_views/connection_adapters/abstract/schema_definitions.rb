module RailsSqlViews
  module ConnectionAdapters #:nodoc:
    # Abstract definition of a View
    class ViewDefinition
      attr_accessor :columns, :select_query
      
      def initialize(base, select_query)
        @columns = []
        @base = base
        @select_query = select_query
      end
      
      def column(name)
        column = name.to_s
        @columns << column unless @columns.include? column
        self
      end
      
      def to_sql
        @columns * ', '
      end
      
    end
    
    class MappingDefinition
      
      # Generates a hash of the form :old_column => :new_column
      # Initially, it'll map column names to themselves.
      # use map_column to modify the list.
      def initialize(columns)
        @columns = columns
        @map = Hash.new()
        columns.each do |c|
          @map[c] = c
        end
        
      end
      
      # Create a mapping from an old column name to a new one.
      # If the new name is nil, specify that the old column shouldn't
      # appear in this new view.
      def map_column(old_name, new_name)
        unless @map.include?(old_name)
          raise ActiveRecord::ActiveRecordError, "column #{old_name} not found, can't be mapped"
        end
        if new_name.nil?
          @map.delete old_name
          @columns.delete old_name
        else
          @map[old_name] = new_name
        end
      end
      
      def select_cols
        @columns
      end
      
      def view_cols
        @columns.map { |c| @map[c] }
      end
    end
  end
end