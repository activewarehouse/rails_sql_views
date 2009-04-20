require "#{File.dirname(__FILE__)}/test_helper"

require 'models/item'
require 'models/place'

class ViewModelTest < Test::Unit::TestCase
  
  def setup
    create_people_view
    VPerson.send(:based_on, Person)
    
    @address = Place.create!
    @person = Person.create!(:first_name => 'Primus', :address => @address)
    @items = [ @person.owned_items.create!, @person.owned_items.create! ]
    @sharable_items = [ Item.create!, Item.create!, Item.create! ]
    @person.shared_items << @sharable_items[0]
    @person.shared_items << @sharable_items[2]

    @vperson = VPerson.find(@person.id)
  end
  
  def cleanup
    Item.delete_all
    Person.delete_all
    Place.delete_all
  end
  
  def test_same_person
    assert_equal @person.id, @vperson.id
  end
  
  def test_cloned_belongs_to_association_exists
    reflection = VPerson.reflect_on_association(:address)
    assert_not_nil reflection
  end
  
  def test_access_cloned_belongs_to_association
    assert_equal @address, @vperson.address
  end

  def test_cloned_has_many_association_exists
    reflection = VPerson.reflect_on_association(:owned_items)
    assert_not_nil reflection
  end

  def test_access_cloned_has_many_association
    items = @vperson.owned_items
    assert_equal 2, items.size
    assert_equal @items.sort_by(&:id), items.sort_by(&:id)
  end

  def test_cloned_habtm_association_exists
    reflection = VPerson.reflect_on_association(:shared_items)
    assert_not_nil reflection
  end

  def test_access_cloned_habtm_association
    items = @vperson.shared_items
    assert_equal 2, items.size
    expected_items = [ @sharable_items[0], @sharable_items[2] ]
    assert_equal expected_items.sort_by(&:id), items.sort_by(&:id)
  end
end
