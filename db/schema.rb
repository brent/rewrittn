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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140731020109) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.string   "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "followed_type"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["followed_type"], name: "index_relationships_on_followed_type"
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "rewrites", force: true do |t|
    t.string   "title"
    t.string   "content_before_snippet"
    t.integer  "user_id"
    t.integer  "snippet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_after_snippet"
  end

  add_index "rewrites", ["user_id", "snippet_id", "created_at"], name: "index_rewrites_on_user_id_and_snippet_id_and_created_at"

  create_table "snippets", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snippets", ["user_id", "created_at"], name: "index_snippets_on_user_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
