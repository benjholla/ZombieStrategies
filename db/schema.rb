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

ActiveRecord::Schema.define(:version => 20091224215842) do

  create_table "accounts", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "confirm_password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "twitter"
    t.decimal  "lat",              :precision => 15, :scale => 10
    t.decimal  "lng",              :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_store_memberships", :force => true do |t|
    t.integer  "store_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "item"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "store"
    t.decimal  "lat",        :precision => 15, :scale => 10
    t.decimal  "lng",        :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_computations", :force => true do |t|
    t.integer  "twitter_trend_id"
    t.float    "rate"
    t.integer  "population"
    t.integer  "threat"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_trends", :force => true do |t|
    t.string   "name"
    t.string   "search"
    t.float    "threshold"
    t.integer  "resolution"
    t.datetime "scheduled_update"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100,                                 :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "first_name",                :limit => 40
    t.string   "last_name",                 :limit => 40
    t.string   "phone",                     :limit => 40
    t.string   "twitter",                   :limit => 40
    t.decimal  "lat",                                      :precision => 15, :scale => 10
    t.decimal  "lng",                                      :precision => 15, :scale => 10
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
