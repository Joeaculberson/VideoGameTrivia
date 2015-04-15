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

ActiveRecord::Schema.define(version: 20150415012235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges_sashes", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "user_email"
    t.string   "opponent_user_email"
    t.string   "user_pieces"
    t.string   "opponent_pieces"
    t.integer  "round"
    t.string   "user_turn_email"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_meter"
    t.integer  "opponent_meter"
    t.integer  "user_steal_correct"
    t.integer  "opponent_steal_correct"
    t.string   "steal_question_ids"
    t.boolean  "is_second_steal_turn"
    t.string   "bet_piece"
    t.string   "wanted_piece"
    t.boolean  "is_game_over"
  end

  create_table "merit_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.text     "target_data"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "card_id"
    t.string   "ip"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text     "question_text"
    t.text     "correct_answer"
    t.text     "incorrect_answer_1"
    t.text     "incorrect_answer_2"
    t.text     "incorrect_answer_3"
    t.string   "category"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_authorized"
    t.string   "submitter"
    t.integer  "difficulty",         default: 25
  end

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics", force: :cascade do |t|
    t.string   "email"
    t.integer  "action_correct"
    t.integer  "action_total"
    t.integer  "adventure_correct"
    t.integer  "adventure_total"
    t.integer  "arcade_correct"
    t.integer  "arcade_total"
    t.integer  "fps_correct"
    t.integer  "fps_total"
    t.integer  "racing_correct"
    t.integer  "racing_total"
    t.integer  "role_playing_correct"
    t.integer  "role_playing_total"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "wins"
    t.integer  "loses"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username"
    t.string   "image"
    t.string   "role"
    t.integer  "experience",               default: 0
    t.integer  "coins",                    default: 0
    t.integer  "sash_id"
    t.integer  "level",                    default: 0
    t.integer  "correct_answers_in_a_row"
    t.boolean  "hide_picture",             default: false
    t.boolean  "hide_email",               default: false
    t.string   "location"
    t.boolean  "hide_location"
    t.boolean  "hide_store"
    t.string   "security_question"
    t.string   "security_answer"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
