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

ActiveRecord::Schema.define(version: 20161205231445) do

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
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", using: :btree
  end

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
    t.integer  "max_payment_cents",     default: 0
    t.integer  "min_payment_cents",     default: 0
    t.integer  "tax",                   default: 0
    t.boolean  "used",                  default: false
    t.string   "province_id"
    t.string   "payment_frequency_max"
    t.string   "payment_frequency_min"
    t.boolean  "status_indian"
    t.integer  "state"
    t.integer  "min_frequency"
    t.integer  "max_frequency"
    t.index ["user_id"], name: "index_deals_on_user_id", using: :btree
  end

  create_table "insurance_policies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "residual"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "category"
    t.integer  "product_list_id"
    t.integer  "loan"
  end

  create_table "insurance_rates", force: :cascade do |t|
    t.integer "term"
    t.float   "value",               default: 0.0
    t.integer "insurance_policy_id"
    t.integer "loan"
    t.boolean "residual",            default: false
  end

  create_table "insurance_terms", force: :cascade do |t|
    t.integer "option_id"
    t.integer "insurance_policy_id"
    t.integer "term"
    t.integer "category"
    t.integer "premium_cents",       default: 0
    t.boolean "overridden",          default: false
    t.integer "lender_id"
    t.boolean "residual",            default: false
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
    t.integer  "msrp_cents",         default: 0
    t.integer  "cash_price_cents",   default: 0
    t.integer  "trade_in_cents",     default: 0
    t.integer  "lien_cents",         default: 0
    t.integer  "cash_down_cents",    default: 0
    t.integer  "rebate_cents",       default: 0
    t.integer  "dci_cents",          default: 0
    t.integer  "term"
    t.integer  "amortization"
    t.integer  "residual_cents",     default: 0
    t.integer  "max_amount_cents",   default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "notes"
    t.integer  "bank_reg_fee_cents", default: 0
    t.integer  "loan"
    t.integer  "position"
    t.integer  "residual_value",     default: 0
    t.integer  "residual_unit",      default: 0
    t.boolean  "kickback",           default: false
    t.boolean  "rounding",           default: false
    t.integer  "frequency"
    t.integer  "tier"
    t.integer  "interest_rate_id"
    t.index ["deal_id"], name: "index_lenders_on_deal_id", using: :btree
    t.index ["interest_rate_id"], name: "index_lenders_on_interest_rate_id", using: :btree
  end

  create_table "lenders_products", id: false, force: :cascade do |t|
    t.integer "lender_id"
    t.integer "product_id"
  end

  create_table "options", force: :cascade do |t|
    t.integer "lender_id"
    t.integer "index"
    t.integer "term"
    t.integer "buydown_tier"
    t.float   "pocketbook_loan_rate"
    t.float   "car_loan_rate"
    t.float   "family_loan_rate"
    t.integer "loan"
    t.float   "interest_rate"
    t.integer "payment_frequency"
    t.integer "amortization"
    t.integer "residual_cents",       default: 0
    t.integer "residual_value",       default: 0
    t.integer "residual_unit",        default: 0
  end

  create_table "options_products", id: false, force: :cascade do |t|
    t.integer "option_id"
    t.integer "product_id"
  end

  create_table "product_lists", force: :cascade do |t|
    t.integer  "listable_id"
    t.string   "listable_type"
    t.float    "insurance_profit_rate"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "car_reserved_profit_cents",    default: 0
    t.integer  "family_reserved_profit_cents", default: 0
    t.index ["listable_type", "listable_id"], name: "index_product_lists_on_listable_type_and_listable_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "retail_price_cents", default: 0
    t.integer  "dealer_cost_cents",  default: 0
    t.integer  "tax",                default: 0
    t.integer  "product_list_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "category"
    t.boolean  "visible",            default: true
    t.index ["product_list_id"], name: "index_products_on_product_list_id", using: :btree
  end

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
    t.index ["dealership_id"], name: "index_users_on_dealership_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "deals", "users"
  add_foreign_key "lenders", "deals"
  add_foreign_key "products", "product_lists"
  add_foreign_key "users", "dealerships"
end
