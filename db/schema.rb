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

ActiveRecord::Schema.define(version: 20170714213920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "processed_transactions", primary_key: "trade_id", force: :cascade do |t|
    t.integer  "currency_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["currency_id"], name: "index_processed_transactions_on_currency_id", using: :btree
  end

  create_table "trades", force: :cascade do |t|
    t.datetime "start_date",                           null: false
    t.datetime "end_date"
    t.decimal  "start_rate",  precision: 30, scale: 8, null: false
    t.decimal  "end_rate",    precision: 30, scale: 8
    t.decimal  "amount",      precision: 30, scale: 8, null: false
    t.decimal  "start_total", precision: 30, scale: 8, null: false
    t.decimal  "end_total",   precision: 30, scale: 8
    t.integer  "status",                               null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "currency_id"
    t.index ["currency_id"], name: "index_trades_on_currency_id", using: :btree
  end

end
