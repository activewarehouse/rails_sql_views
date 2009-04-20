
# A base class for database views.
# It is primarily useful for views that are centered around a single table/model.
module ActiveRecord # :nodoc:
  class View < Base
    self.abstract_class = true
    
    def readonly?
      true
    end
    
    class << self
      # Clones all applicable associations from +model+ to this view
      # and provides an instance method
      # <tt>to_<em>model</em></tt>
      # that casts a view object to an object of the kind view is
      # based on. This latter object may be missing attributes; to fill
      # them in, call #reload.
      def based_on(model)
        define_method("to_#{model.name.demodulize.underscore}") do
          becomes(model)
        end
        
        model.reflect_on_all_associations.each do |assoc|
          clone_association(model, assoc)
        end
      end
      
      # Clone one or more associations from +model+ to this view class.
      #
      # NOTE: Currently only <tt>belongs_to</tt>, <tt>has_many</tt> (withouth
      # <tt>:through</tt>), and <tt>has_and_belongs_to_many</tt> associations
      # are supported.
      def clone_association(model, *associations)
        associations.each do |association|
          r = case association
              when String, Symbol
                model.reflect_on_association(association.to_sym)
              when ActiveRecord::Reflection::AssociationReflection
                association
              else
                raise ArgumentError, "Unrecognized association #{association.inspect}; must be a Symbol, String, or AssociationReflection."
              end
          case r.macro
          when :belongs_to
            if self.column_names.include?(r.primary_key_name.to_s)
              if !r.options[:foreign_type] || self.column_names.include?(r.options[:foreign_type])
                options = r.options.merge(
                  :class_name => r.class_name,
                  :foreign_key => r.primary_key_name
                )
                belongs_to r.name, options
              end
            end
          when :has_many
            ### TODO :through assocications
            options = r.options.merge(
              :class_name => r.class_name,
              :foreign_key => r.primary_key_name
            )
            has_many r.name, options
          when :has_and_belongs_to_many
            options = r.options.merge(
              :class_name => r.class_name,
              :foreign_key => r.primary_key_name,
              :association_foreign_key => r.association_foreign_key
            )
            has_and_belongs_to_many r.name, options
          when :has_one
            ### TODO
          end
        end
      end
    end
  end
end
