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

ActiveRecord::Schema.define(version: 20141109134250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hangman_games", force: true do |t|
    t.integer  "user_id"
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hangman_moves", force: true do |t|
    t.string   "letter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "hangman_game_id"
  end

  create_table "invites", force: true do |t|
    t.text     "message",      default: "Want to play a game of tic tac toe with me?"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "accepted",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ttt_games", force: true do |t|
    t.integer  "player_1_id"
    t.integer  "player_2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invite_id"
    t.integer  "current_player_id"
  end

  create_table "ttt_moves", force: true do |t|
    t.integer  "player_id"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "email"
    t.string   "username"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
