class Person < ActiveRecord::Base
  belongs_to :address, :class_name => 'Place', :foreign_key => :address_id
  has_many :owned_items, :class_name => 'Item'
  has_and_belongs_to_many :shared_items, :class_name => 'Item'
end
