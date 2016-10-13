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

ActiveRecord::Schema.define(version: 20160204023325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "contacts", ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", using: :btree

  create_table "dealerships", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "province_id"
    t.string   "phone"
    t.integer  "status",      default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "payment_max_cents",     default: 0
    t.integer  "payment_min_cents",     default: 0
    t.integer  "tax",                   default: 0
    t.boolean  "used",                  default: false
    t.string   "province_id"
    t.string   "payment_frequency_max"
    t.string   "payment_frequency_min"
    t.boolean  "status_indian"
    t.integer  "scenario",              default: 1
    t.integer  "state"
  end

  add_index "deals", ["user_id"], name: "index_deals_on_user_id", using: :btree

  create_table "insurance_policies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "residual"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "category"
    t.integer  "product_list_id"
    t.integer  "loan_type"
  end

  create_table "insurance_rates", force: :cascade do |t|
    t.integer "term"
    t.float   "value",               default: 0.0
    t.integer "insurance_policy_id"
  end

  create_table "insurance_terms", force: :cascade do |t|
    t.integer "option_id"
    t.integer "term"
    t.integer "category"
    t.integer "insurance_policy_id"
    t.integer "premium_cents",       default: 0
    t.boolean "overridden",          default: false
  end

  create_table "interest_rates", force: :cascade do |t|
    t.float    "value"
    t.integer  "lender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lenders", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "bank"
    t.integer  "msrp_cents",             default: 0
    t.integer  "cash_price_cents",       default: 0
    t.integer  "trade_in_cents",         default: 0
    t.integer  "lien_cents",             default: 0
    t.integer  "cash_down_cents",        default: 0
    t.integer  "rebate_cents",           default: 0
    t.integer  "dci_cents",              default: 0
    t.integer  "term"
    t.integer  "amortization"
    t.integer  "residual_cents",         default: 0
    t.integer  "approved_maximum_cents", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "notes"
    t.integer  "bank_reg_fee_cents",     default: 0
    t.integer  "loan_type"
    t.integer  "position"
    t.integer  "residual_value",         default: 0
    t.integer  "residual_unit",          default: 0
  end

  add_index "lenders", ["deal_id"], name: "index_lenders_on_deal_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.integer "lender_id"
    t.integer "index"
    t.integer "term"
    t.integer "buydown_tier"
    t.integer "loan_type"
    t.float   "interest_rate"
    t.integer "payment_frequency"
    t.integer "amortization"
    t.integer "residual_cents",    default: 0
    t.integer "residual_value",    default: 0
    t.integer "residual_unit",     default: 0
  end

  create_table "options_products", id: false, force: :cascade do |t|
    t.integer "option_id"
    t.integer "product_id"
  end

  create_table "product_lists", force: :cascade do |t|
    t.integer  "listable_id"
    t.string   "listable_type"
    t.integer  "insurance_profit"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "car_profit_cents",    default: 0
    t.integer  "family_profit_cents", default: 0
  end

  add_index "product_lists", ["listable_type", "listable_id"], name: "index_product_lists_on_listable_type_and_listable_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "retail_price_cents", default: 0
    t.integer  "dealer_cost_cents",  default: 0
    t.integer  "tax",                default: 0
    t.integer  "product_list_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "category"
  end

  add_index "products", ["product_list_id"], name: "index_products_on_product_list_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dealership_id"
    t.boolean  "admin",                  default: false, null: false
    t.string   "name"
  end

  add_index "users", ["dealership_id"], name: "index_users_on_dealership_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "deals", "users"
  add_foreign_key "lenders", "deals"
  add_foreign_key "products", "product_lists"
  add_foreign_key "users", "dealerships"
end
