# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140918212048) do

  create_table "_apps_old_20140918", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "menu_order"
    t.integer  "user_id"
  end

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "menu_order"
    t.integer  "owner_id"
  end

  create_table "build_uploads", :force => true do |t|
    t.integer  "build_id"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "builds", :force => true do |t|
    t.string   "version"
    t.string   "build_number"
    t.text     "release_notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "app_id"
  end

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "UDID"
    t.string   "model"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "challenge_token"
  end

  create_table "dist_lists", :force => true do |t|
    t.integer  "app_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "dist_lists_users", :id => false, :force => true do |t|
    t.integer "dist_list_id"
    t.integer "user_id"
  end

  add_index "dist_lists_users", ["dist_list_id", "user_id"], :name => "index_dist_lists_users_on_dist_list_id_and_user_id"
  add_index "dist_lists_users", ["user_id"], :name => "index_dist_lists_users_on_user_id"

  create_table "seed_migration_data_migrations", :force => true do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "user_roles", :force => true do |t|
    t.integer "user_id"
    t.integer "app_id"
    t.string  "role"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
