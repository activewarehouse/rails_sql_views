
module ActiveRecord
  class View < Base
    self.abstract_class = true
    
    def readonly?
      true
    end
    
    class << self
      def based_on(model)
        define_method("to_#{model.name.demodulize.underscore}") do
          ### TODO reload?
          becomes(model)
        end
        
        model.reflect_on_all_associations.each do |assoc|
          steal_association(model, assoc)
        end
      end
      
      def steal_association(model, *associations)
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
            ### ensure that the fk column exists
          when :has_many
            ### TODO add options for :through assocs
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
          end
        end
      end
    end
  end
end
