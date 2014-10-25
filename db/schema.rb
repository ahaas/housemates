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

ActiveRecord::Schema.define(version: 20141024222952) do

  create_table "balances", force: true do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.decimal  "amount",     default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balances", ["user1_id"], name: "index_balances_on_user1_id"
  add_index "balances", ["user2_id"], name: "index_balances_on_user2_id"

  create_table "households", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.integer  "household_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["household_id"], name: "index_invites_on_household_id"

  create_table "transaction_groups", force: true do |t|
    t.string   "name"
    t.decimal  "total_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "payer_id"
    t.integer  "payee_id"
    t.integer  "household_id"
    t.integer  "transaction_group_id"
    t.boolean  "is_payback"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["household_id"], name: "index_transactions_on_household_id"
  add_index "transactions", ["payee_id"], name: "index_transactions_on_payee_id"
  add_index "transactions", ["payer_id"], name: "index_transactions_on_payer_id"
  add_index "transactions", ["transaction_group_id"], name: "index_transactions_on_transaction_group_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.integer  "household_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["household_id"], name: "index_users_on_household_id"

end
