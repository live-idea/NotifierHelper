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

ActiveRecord::Schema.define(:version => 20101226093851) do

  create_table "contacts", :force => true do |t|
    t.integer "user_id"
    t.string  "firstname"
    t.string  "lastname"
    t.string  "email"
    t.string  "phonenumber"
    t.string  "fb_id"
    t.string  "comment"
    t.boolean "send_email"
    t.boolean "send_sms"
    t.boolean "only_free_sms"
    t.string  "vk_id"
  end

  create_table "contacts_groups", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "group_id"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "groups", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.string  "description"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.string   "subject"
    t.text     "body"
    t.text     "sms_body"
    t.string   "frequency"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status"
    t.datetime "send_on"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipients", :force => true do |t|
    t.integer "notification_id"
    t.integer "contact_id"
    t.string  "status"
  end

  create_table "transporters", :force => true do |t|
    t.integer  "user_id"
    t.string   "login"
    t.string   "password"
    t.string   "smtp_server"
    t.string   "smtp_port"
    t.integer  "count_per_day"
    t.integer  "count_left"
    t.datetime "need_reset_date"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin"
    t.boolean  "is_confirmed"
  end

end
