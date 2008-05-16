module ActiveRecord
 module ConnectionAdapters
   class OciAdapter
     # Returns true as this adapter supports views.
     def supports_views?
       true
     end

     def tables(name = nil) #:nodoc:
       tables = []
       execute("SELECT TABLE_NAME FROM USER_TABLES", name).each { |row| tables << row[0]  }
       tables
     end

     def views(name = nil) #:nodoc:
       views = []
       execute("SELECT VIEW_NAME FROM USER_VIEWS", name).each { |row| views << row[0] }
       views
     end

     # Get the view select statement for the specified table.
     def view_select_statement(view, name=nil)
       row = execute("SELECT TEXT FROM USER_VIEWS WHERE VIEW_NAME = '#{view}'", name).each do |row|
         return row[0]
       end
       raise "No view called #{view} found"
     end


   end
 end
end