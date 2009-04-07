class Item < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :people
end
