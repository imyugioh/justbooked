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

ActiveRecord::Schema.define(version: 20190419130721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "stripe_account"
    t.string   "stripe_secret"
    t.string   "stripe_publishable"
    t.boolean  "stripe_validated",                 default: false
    t.datetime "created_at",         precision: 6,                 null: false
    t.datetime "updated_at",         precision: 6,                 null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",                 null: false
    t.string   "resource_type",               null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at",    precision: 6
    t.datetime "updated_at",    precision: 6
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addons", force: :cascade do |t|
    t.integer  "menu_id"
    t.string   "name"
    t.string   "desc"
    t.decimal  "price",      precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: 6,           null: false
    t.datetime "updated_at", precision: 6,           null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "address_type"
    t.integer  "order_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "comment"
    t.string   "contact_phone"
    t.datetime "created_at",    precision: 6, null: false
    t.datetime "updated_at",    precision: 6, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                                default: "", null: false
    t.string   "encrypted_password",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at",    precision: 6
    t.integer  "sign_in_count",                        default: 0,  null: false
    t.datetime "current_sign_in_at",     precision: 6
    t.datetime "last_sign_in_at",        precision: 6
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",             precision: 6,              null: false
    t.datetime "updated_at",             precision: 6,              null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "app_settings", force: :cascade do |t|
    t.string   "slider_venue_ids"
    t.datetime "created_at",           precision: 6,                        null: false
    t.datetime "updated_at",           precision: 6,                        null: false
    t.string   "default_booking_type",               default: "Dining Out"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "published_at",  precision: 6
    t.integer  "admin_user_id"
    t.datetime "created_at",    precision: 6, null: false
    t.datetime "updated_at",    precision: 6, null: false
    t.string   "slug"
  end

  add_index "articles", ["admin_user_id"], name: "index_articles_on_admin_user_id", using: :btree
  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.datetime "created_at",         precision: 6,                 null: false
    t.datetime "updated_at",         precision: 6,                 null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at",   precision: 6
    t.string   "token"
    t.string   "asset_detail"
    t.boolean  "reprocessed",                      default: false
  end

  create_table "campaign_users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cards", force: :cascade do |t|
    t.json     "stripe_card"
    t.integer  "user_id"
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
  end

  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "menu_id"
    t.integer  "quantity"
    t.integer  "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string   "session_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "booking_id"
    t.money    "amount",                        scale: 2
    t.money    "service_fee",                   scale: 2
    t.date     "charge_at"
    t.boolean  "captured",                                default: false
    t.integer  "charge_attempts",                         default: 0
    t.json     "stripe_response"
    t.datetime "created_at",      precision: 6,                           null: false
    t.datetime "updated_at",      precision: 6,                           null: false
  end

  add_index "charges", ["booking_id"], name: "index_charges_on_booking_id", using: :btree

  create_table "chefs", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.integer  "street_number"
    t.string   "street_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "neighborhood"
    t.string   "state"
    t.string   "state_code"
    t.string   "zip"
    t.string   "country"
    t.string   "country_code"
    t.string   "website"
    t.string   "slug"
    t.string   "social_links"
    t.string   "email"
    t.string   "phone"
    t.datetime "dob",                            precision: 6
    t.text     "about"
    t.integer  "max_delivery_distance"
    t.integer  "profile_asset_id"
    t.integer  "header_asset_id"
    t.decimal  "latitude",                       precision: 9, scale: 6
    t.decimal  "longitude",                      precision: 9, scale: 6
    t.jsonb    "geocode_result"
    t.integer  "asset_count"
    t.integer  "position"
    t.datetime "created_at",                     precision: 6,                           null: false
    t.datetime "updated_at",                     precision: 6,                           null: false
    t.boolean  "geo_code_success",                                       default: false
    t.integer  "geo_code_retry_cnt",                                     default: 0
    t.boolean  "certified",                                              default: false
    t.integer  "pre_order_notice_hour",                                  default: 24
    t.decimal  "pre_order_min_order_amount",     precision: 8, scale: 2
    t.decimal  "delivery_fee",                   precision: 8, scale: 2
    t.decimal  "free_delivery_min_order_amount", precision: 8, scale: 2
    t.decimal  "min_fee_for_onsite_cooking",     precision: 8, scale: 2
    t.boolean  "onsite_cooking_available",                               default: false
    t.boolean  "pickup_available",                                       default: true
    t.integer  "transaction_fee",                                        default: 20
    t.boolean  "listed",                                                 default: true
    t.string   "email_sec"
    t.string   "phone_sec"
    t.integer  "menus_count",                                            default: 0
    t.boolean  "shareables",                                             default: false, null: false
    t.boolean  "individually_packaged",                                  default: false, null: false
    t.integer  "price_category",                                         default: 0,     null: false
    t.string   "event_types"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,               default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                                      default: "comments"
    t.datetime "created_at",                  precision: 6
    t.datetime "updated_at",                  precision: 6
    t.datetime "published_at",                precision: 6
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chef_id"
    t.string   "name"
    t.string   "email"
    t.boolean  "invitation_sent",               default: false
    t.datetime "created_at",      precision: 6,                 null: false
    t.datetime "updated_at",      precision: 6,                 null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "name"
    t.string   "card_token"
    t.string   "customer_id"
    t.decimal  "discount"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "expired",                   default: false
    t.integer  "limit",                     default: 1
    t.datetime "created_at",  precision: 6,                 null: false
    t.datetime "updated_at",  precision: 6,                 null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at",   precision: 6
    t.string   "token"
    t.string   "document_detail"
    t.boolean  "reprocessed",                         default: false
    t.datetime "created_at",            precision: 6,                 null: false
    t.datetime "updated_at",            precision: 6,                 null: false
  end

  create_table "errors", force: :cascade do |t|
    t.string   "usable_type"
    t.integer  "usable_id"
    t.text     "class_name"
    t.text     "message"
    t.text     "trace"
    t.text     "target_url"
    t.text     "referer_url"
    t.text     "params"
    t.text     "user_agent"
    t.datetime "created_at",  precision: 6
    t.datetime "updated_at",  precision: 6
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                                    null: false
    t.integer  "sluggable_id",                            null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at",                precision: 6
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          precision: 6
    t.datetime "updated_at",          precision: 6
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "inquiry_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "venue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_index "inquiry_items", ["user_id"], name: "index_inquiry_items_on_user_id", using: :btree
  add_index "inquiry_items", ["venue_id"], name: "index_inquiry_items_on_venue_id", using: :btree

  create_table "mail_lists", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menu_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "chef_id"
    t.datetime "created_at",       precision: 6, null: false
    t.datetime "updated_at",       precision: 6, null: false
    t.integer  "display_priority"
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer  "menu_id",                            null: false
    t.string   "name",                               null: false
    t.string   "desc"
    t.decimal  "price",      precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: 6,           null: false
    t.datetime "updated_at", precision: 6,           null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "chef_id"
    t.decimal  "price",                   precision: 8, scale: 2
    t.string   "slug"
    t.integer  "asset_count"
    t.integer  "position"
    t.datetime "created_at",              precision: 6,                               null: false
    t.datetime "updated_at",              precision: 6,                               null: false
    t.boolean  "auto_accept",                                     default: false
    t.boolean  "listed",                                          default: true
    t.integer  "cached_votes_total",                              default: 0
    t.integer  "cached_votes_score",                              default: 0
    t.integer  "cached_votes_up",                                 default: 0
    t.integer  "cached_votes_down",                               default: 0
    t.integer  "cached_weighted_score",                           default: 0
    t.integer  "cached_weighted_total",                           default: 0
    t.float    "cached_weighted_average",                         default: 0.0
    t.string   "token"
    t.decimal  "latitude",                precision: 9, scale: 6
    t.decimal  "longitude",               precision: 9, scale: 6
    t.string   "per",                                             default: "platter"
    t.integer  "menu_category_id"
    t.integer  "min_order_amount",                                default: 1
    t.string   "menu_type",                                       default: "single"
  end

  add_index "menus", ["cached_votes_down"], name: "index_menus_on_cached_votes_down", using: :btree
  add_index "menus", ["cached_votes_score"], name: "index_menus_on_cached_votes_score", using: :btree
  add_index "menus", ["cached_votes_total"], name: "index_menus_on_cached_votes_total", using: :btree
  add_index "menus", ["cached_votes_up"], name: "index_menus_on_cached_votes_up", using: :btree
  add_index "menus", ["cached_weighted_average"], name: "index_menus_on_cached_weighted_average", using: :btree
  add_index "menus", ["cached_weighted_score"], name: "index_menus_on_cached_weighted_score", using: :btree
  add_index "menus", ["cached_weighted_total"], name: "index_menus_on_cached_weighted_total", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string   "city"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.string   "message_key"
    t.boolean  "read",                        default: false
    t.integer  "user_id"
    t.datetime "created_at",    precision: 6,                 null: false
    t.datetime "updated_at",    precision: 6,                 null: false
  end

  add_index "notifications", ["noteable_type", "noteable_id"], name: "index_notifications_on_noteable_type_and_noteable_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "menu_id",                   null: false
    t.integer  "order_id",                  null: false
    t.integer  "user_id"
    t.decimal  "unit_price",                null: false
    t.integer  "quantity",                  null: false
    t.decimal  "total_price",               null: false
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
  end

  add_index "order_items", ["menu_id"], name: "index_order_items_on_menu_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["quantity"], name: "index_order_items_on_quantity", using: :btree
  add_index "order_items", ["total_price"], name: "index_order_items_on_total_price", using: :btree
  add_index "order_items", ["user_id"], name: "index_order_items_on_user_id", using: :btree

  create_table "order_statuses", force: :cascade do |t|
    t.integer  "order_id",                 null: false
    t.integer  "user_id"
    t.string   "status",                   null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_index "order_statuses", ["order_id"], name: "index_order_statuses_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cart_id"
    t.integer  "delivery_address_id"
    t.string   "delivery_type"
    t.string   "order_type"
    t.string   "email"
    t.string   "more_detail"
    t.string   "currency",                                     default: "CAD",  null: false
    t.integer  "customer_id",                                                   null: false
    t.string   "card",                                                          null: false
    t.decimal  "sales_tax",           precision: 10, scale: 2,                  null: false
    t.decimal  "delivery_fee",        precision: 10, scale: 2,                  null: false
    t.decimal  "total_price",         precision: 10, scale: 2,                  null: false
    t.datetime "created_at",          precision: 6,                             null: false
    t.datetime "updated_at",          precision: 6,                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phonenumber"
    t.date     "deliver_date"
    t.string   "deliver_time",                                 default: "ASAP"
    t.string   "promo_code"
  end

  add_index "orders", ["cart_id"], name: "index_orders_on_cart_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chef_id"
    t.string   "account_number"
    t.string   "currency"
    t.string   "routing_number"
    t.string   "business_type"
    t.string   "business_name"
    t.string   "business_tax_id"
    t.datetime "created_at",         precision: 6,                 null: false
    t.datetime "updated_at",         precision: 6,                 null: false
    t.string   "stripe_account"
    t.string   "stripe_secret"
    t.string   "stripe_publishable"
    t.boolean  "stripe_validated",                 default: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "dob_day"
    t.integer  "dob_month"
    t.integer  "dob_year"
    t.boolean  "stripe_accepted",                  default: false
    t.jsonb    "stripe_response"
  end

  add_index "payment_accounts", ["stripe_account"], name: "index_payment_accounts_on_stripe_account", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "published_at", precision: 6
    t.datetime "created_at",   precision: 6, null: false
    t.datetime "updated_at",   precision: 6, null: false
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "purchase_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "purchase_id"
    t.integer  "model_id"
    t.float    "item_price"
    t.integer  "amount"
    t.float    "sub_total"
    t.datetime "created_at",  precision: 6,                null: false
    t.datetime "updated_at",  precision: 6,                null: false
    t.text     "detail",                    default: "{}"
    t.string   "model_type"
    t.integer  "parent_id"
  end

  add_index "purchase_items", ["purchase_id"], name: "index_purchase_items_on_purchase_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "cart_id"
    t.integer  "chef_id"
    t.string   "phone_number"
    t.date     "order_date"
    t.string   "order_time"
    t.string   "order_type",                       default: "delivery"
    t.string   "delivery_address"
    t.string   "more_detail"
    t.string   "promo_code"
    t.string   "purchased_with",                   default: "credit_cart"
    t.string   "stripe_token"
    t.integer  "amount"
    t.string   "description"
    t.string   "currency",                         default: "cad"
    t.string   "stripe_customer_id"
    t.integer  "items_total"
    t.integer  "sales_tax"
    t.integer  "delivery_fee"
    t.integer  "total_price"
    t.boolean  "captured",                         default: false
    t.integer  "charge_attempts",                  default: 0
    t.integer  "service_fee",                      default: 0
    t.jsonb    "stripe_response"
    t.datetime "created_at",         precision: 6,                         null: false
    t.datetime "updated_at",         precision: 6,                         null: false
    t.integer  "delivery_distance",                default: 0
    t.string   "request_status",                   default: "New"
    t.string   "payment_status"
    t.string   "token"
    t.integer  "chef_amount"
    t.string   "brand"
    t.string   "last4"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chef_id"
    t.integer  "menu_id"
    t.integer  "rating"
    t.text     "feedback"
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
    t.integer  "purchase_id"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at",                precision: 6
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "tag_type"
    t.integer  "taggings_count",               default: 0
    t.datetime "created_at",     precision: 6
    t.datetime "updated_at",     precision: 6
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "used_coupons", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.boolean  "confirmed",                           default: false
    t.boolean  "coupon_refund",                       default: false
    t.json     "coupon_refund_details"
    t.datetime "created_at",            precision: 6,                 null: false
    t.datetime "updated_at",            precision: 6,                 null: false
  end

  add_index "used_coupons", ["booking_id"], name: "index_used_coupons_on_booking_id", using: :btree
  add_index "used_coupons", ["coupon_id"], name: "index_used_coupons_on_coupon_id", using: :btree
  add_index "used_coupons", ["user_id"], name: "index_used_coupons_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                default: "",       null: false
    t.string   "encrypted_password",                   default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at",    precision: 6
    t.integer  "sign_in_count",                        default: 0,        null: false
    t.datetime "current_sign_in_at",     precision: 6
    t.datetime "last_sign_in_at",        precision: 6
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at",           precision: 6
    t.datetime "confirmation_sent_at",   precision: 6
    t.string   "unconfirmed_email"
    t.datetime "created_at",             precision: 6,                    null: false
    t.datetime "updated_at",             precision: 6,                    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "newsletter",                           default: true
    t.string   "token"
    t.string   "stripe_customer_id"
    t.string   "phone"
    t.string   "streetnumber"
    t.string   "street_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "neighborhood"
    t.string   "state"
    t.string   "state_code"
    t.string   "zip"
    t.string   "country",                              default: "Canada"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street_address"
    t.string   "street_number"
    t.string   "street_name"
    t.string   "city"
    t.string   "state"
    t.string   "state_code"
    t.string   "state_name"
    t.string   "zip"
    t.string   "country_code"
    t.string   "provider"
    t.string   "neighborhood"
    t.string   "district"
    t.string   "country"
    t.string   "accuracy"
    t.string   "website"
    t.money    "price",                                 scale: 2
    t.integer  "capacity"
    t.datetime "created_at",              precision: 6,                                                                                                    null: false
    t.datetime "updated_at",              precision: 6,                                                                                                    null: false
    t.string   "slug"
    t.json     "social_links",                                    default: {"facebook"=>"", "google"=>"", "twitter"=>"", "pinterest"=>"", "linkedin"=>""}
    t.integer  "cached_votes_total",                              default: 0
    t.integer  "cached_votes_score",                              default: 0
    t.integer  "cached_votes_up",                                 default: 0
    t.integer  "cached_votes_down",                               default: 0
    t.integer  "cached_weighted_score",                           default: 0
    t.integer  "cached_weighted_total",                           default: 0
    t.float    "cached_weighted_average",                         default: 0.0
    t.integer  "assets_count"
    t.boolean  "listed",                                          default: false
    t.string   "email"
    t.boolean  "redeemed",                                        default: true
    t.string   "token"
    t.integer  "capacity_min"
    t.integer  "capacity_max"
    t.integer  "packages_count"
    t.integer  "position"
    t.boolean  "premium"
    t.boolean  "popular"
  end

  add_index "venues", ["cached_votes_down"], name: "index_venues_on_cached_votes_down", using: :btree
  add_index "venues", ["cached_votes_score"], name: "index_venues_on_cached_votes_score", using: :btree
  add_index "venues", ["cached_votes_total"], name: "index_venues_on_cached_votes_total", using: :btree
  add_index "venues", ["cached_votes_up"], name: "index_venues_on_cached_votes_up", using: :btree
  add_index "venues", ["cached_weighted_average"], name: "index_venues_on_cached_weighted_average", using: :btree
  add_index "venues", ["cached_weighted_score"], name: "index_venues_on_cached_weighted_score", using: :btree
  add_index "venues", ["cached_weighted_total"], name: "index_venues_on_cached_weighted_total", using: :btree
  add_index "venues", ["slug"], name: "index_venues_on_slug", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at",   precision: 6
    t.datetime "updated_at",   precision: 6
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "articles", "admin_users"
  add_foreign_key "cards", "users"
  add_foreign_key "inquiry_items", "users"
  add_foreign_key "inquiry_items", "venues"
  add_foreign_key "posts", "users"
  add_foreign_key "used_coupons", "coupons"
  add_foreign_key "used_coupons", "users"
end
