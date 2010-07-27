# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "items", :force => true do |t|
    t.integer "person_id", :precision => 38, :scale => 0
  end

  create_table "items_people", :id => false, :force => true do |t|
    t.integer "person_id", :precision => 38, :scale => 0
    t.integer "item_id",   :precision => 38, :scale => 0
  end

  create_table "people", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "ssn",        :limit => 64
    t.integer "address_id",               :precision => 38, :scale => 0
  end

  create_table "people2", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "ssn",        :limit => 64
  end

  create_table "places", :force => true do |t|
    t.string "address", :limit => 2000
    t.string "city"
    t.string "cstate"
    t.string "country", :limit => 2
  end

  create_view "v_people", "select id, first_name, last_name, ssn, address_id from people", :force => true do |v|
    v.column :id
    v.column :f_name
    v.column :l_name
    v.column :social_security
    v.column :address_id
  end

end
