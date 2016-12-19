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

ActiveRecord::Schema.define(version: 20161218155258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string   "fbid",                             null: false
    t.string   "name"
    t.string   "email"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "admin",            default: false
    t.boolean  "approved",         default: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["fbid"], name: "index_users_on_fbid", unique: true, using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "yt_id",                              null: false
    t.string   "title"
    t.text     "description"
    t.text     "snippet"
    t.boolean  "auto_transcribed",   default: false
    t.boolean  "transcribed",        default: false
    t.text     "auto_transcription"
    t.text     "transcription"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.datetime "assigned_at"
    t.index ["auto_transcribed"], name: "index_videos_on_auto_transcribed", using: :btree
    t.index ["transcribed"], name: "index_videos_on_transcribed", using: :btree
    t.index ["user_id"], name: "index_videos_on_user_id", using: :btree
    t.index ["yt_id"], name: "index_videos_on_yt_id", unique: true, using: :btree
  end

end
