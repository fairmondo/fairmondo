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

ActiveRecord::Schema.define(version: 20180802092305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "company_name"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "zip"
    t.string "city"
    t.string "country"
    t.integer "user_id"
    t.boolean "stashed", default: false
    t.index ["user_id"], name: "addresses_user_id_index"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "condition"
    t.bigint "price_cents", default: 100
    t.string "currency"
    t.boolean "fair", default: false
    t.string "fair_kind"
    t.string "fair_seal"
    t.boolean "ecologic", default: false
    t.string "ecologic_seal"
    t.boolean "small_and_precious", default: false
    t.text "small_and_precious_reason"
    t.boolean "small_and_precious_handmade", default: false
    t.integer "quantity", default: 1
    t.text "transport_details"
    t.text "payment_details"
    t.integer "friendly_percent", default: 0
    t.bigint "calculated_fair_cents", default: 0, null: false
    t.bigint "calculated_friendly_cents", default: 0, null: false
    t.bigint "calculated_fee_cents", default: 0, null: false
    t.string "condition_extra"
    t.boolean "small_and_precious_eu_small_enterprise"
    t.string "ecologic_kind"
    t.text "upcycling_reason"
    t.string "slug"
    t.boolean "transport_pickup"
    t.boolean "transport_type1"
    t.boolean "transport_type2"
    t.string "transport_type1_provider"
    t.string "transport_type2_provider"
    t.integer "transport_type1_price_cents", default: 0, null: false
    t.integer "transport_type2_price_cents", default: 0, null: false
    t.boolean "payment_bank_transfer"
    t.boolean "payment_cash"
    t.boolean "payment_paypal"
    t.boolean "payment_cash_on_delivery"
    t.boolean "payment_invoice"
    t.integer "payment_cash_on_delivery_price_cents", default: 0, null: false
    t.integer "basic_price_cents", default: 0
    t.string "basic_price_amount"
    t.string "state"
    t.integer "vat", default: 0
    t.string "custom_seller_identifier"
    t.string "gtin"
    t.integer "transport_type1_number", default: 1
    t.integer "transport_type2_number", default: 1
    t.integer "discount_id"
    t.bigint "friendly_percent_organisation_id"
    t.string "article_template_name"
    t.string "transport_time"
    t.integer "quantity_available"
    t.boolean "unified_transport"
    t.boolean "swappable", default: false
    t.boolean "borrowable", default: false
    t.integer "comments_count", default: 0
    t.bigint "original_id"
    t.boolean "transport_bike_courier", default: false
    t.integer "transport_bike_courier_number", default: 1
    t.boolean "payment_voucher", default: false
    t.boolean "payment_debit", default: false
    t.boolean "subscription", default: false
    t.index ["created_at"], name: "index_articles_on_created_at"
    t.index ["custom_seller_identifier", "user_id"], name: "index_articles_on_custom_seller_identifier_and_user_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["state"], name: "index_articles_on_state"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "articles_categories", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.bigint "article_id"
    t.index ["article_id", "category_id"], name: "articles_category_index"
    t.index ["article_id"], name: "index_articles_categories_on_article_id"
    t.index ["category_id"], name: "index_articles_categories_on_category_id"
  end

  create_table "business_transactions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "selected_transport"
    t.string "selected_payment"
    t.string "state"
    t.text "message"
    t.integer "quantity_bought"
    t.bigint "parent_id"
    t.bigint "article_id"
    t.datetime "sold_at"
    t.boolean "purchase_emails_sent", default: false
    t.integer "discount_id"
    t.integer "discount_value_cents"
    t.boolean "billed_for_fair", default: false
    t.boolean "billed_for_fee", default: false
    t.boolean "billed_for_discount", default: false
    t.bigint "line_item_group_id"
    t.boolean "refunded_fair", default: false
    t.boolean "refunded_fee", default: false
    t.boolean "tos_bike_courier_accepted", default: false
    t.text "bike_courier_message"
    t.string "bike_courier_time"
    t.boolean "courier_emails_sent", default: false
    t.datetime "courier_emails_sent_at"
    t.index ["article_id"], name: "index_business_transactions_on_article_id"
    t.index ["discount_id"], name: "index_business_transactions_on_discount_id"
    t.index ["line_item_group_id"], name: "index_business_transactions_on_line_item_group_id"
    t.index ["parent_id"], name: "index_business_transactions_on_parent_id"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "user_id"
    t.boolean "sold", default: false
    t.integer "line_item_count", default: 0
    t.boolean "purchase_emails_sent", default: false
    t.datetime "purchase_emails_sent_at"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "children_count", default: 0
    t.integer "weight"
    t.integer "view_columns", default: 2
    t.string "slug"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.text "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id", "commentable_type", "updated_at"], name: "index_comments_for_popularity_worker"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contents", id: :serial, force: :cascade do |t|
    t.string "key"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_tinycms_contents_on_key", unique: true
  end

  create_table "direct_debit_mandates", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "state"
    t.datetime "activated_at"
    t.datetime "last_used_at"
    t.datetime "revoked_at"
    t.index ["user_id"], name: "index_direct_debit_mandates_on_user_id"
  end

  create_table "discounts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "percent"
    t.integer "max_discounted_value_cents"
    t.integer "num_of_discountable_articles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibits", id: :serial, force: :cascade do |t|
    t.bigint "article_id"
    t.string "queue"
    t.bigint "related_article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "exhibition_date"
    t.index ["article_id"], name: "index_exhibits_on_article_id"
    t.index ["related_article_id"], name: "index_exhibits_on_related_article_id"
  end

  create_table "fair_trust_questionnaires", id: :serial, force: :cascade do |t|
    t.bigint "article_id"
    t.boolean "support", default: false
    t.text "support_explanation"
    t.boolean "labor_conditions", default: false
    t.text "labor_conditions_explanation"
    t.boolean "awareness_raising", default: false
    t.text "awareness_raising_explanation"
    t.boolean "environment_protection", default: false
    t.text "environment_protection_explanation"
    t.text "support_checkboxes"
    t.text "labor_conditions_checkboxes"
    t.text "environment_protection_checkboxes"
    t.text "controlling_checkboxes"
    t.text "awareness_raising_checkboxes"
    t.boolean "controlling", default: false
    t.text "controlling_explanation"
    t.string "support_other"
    t.string "labor_conditions_other"
    t.string "environment_protection_other"
    t.string "controlling_other"
    t.string "awareness_raising_other"
    t.index ["article_id"], name: "index_fair_trust_questionnaires_on_article_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.text "text"
    t.string "subject"
    t.string "from"
    t.string "to"
    t.string "variety"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "article_id"
    t.string "feedback_subject"
    t.string "help_subject"
    t.text "source_page"
    t.string "user_agent"
    t.string "forename"
    t.string "lastname"
    t.string "organisation"
    t.string "phone"
    t.index ["article_id"], name: "index_feedbacks_on_article_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "hearts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "heartable_type"
    t.integer "heartable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "user_token"
    t.index ["heartable_id", "heartable_type", "updated_at"], name: "index_hearts_for_popularity_worker"
    t.index ["heartable_type", "heartable_id"], name: "index_hearts_on_heartable_type_and_heartable_id"
    t.index ["user_id", "heartable_id", "heartable_type"], name: "index_hearts_on_user_id_and_heartable_id_and_heartable_type", unique: true
    t.index ["user_id"], name: "index_hearts_on_user_id"
    t.index ["user_token", "heartable_id", "heartable_type"], name: "index_hearts_on_user_token_and_heartable_id_and_heartable_type", unique: true
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "imageable_id"
    t.string "type"
    t.boolean "is_title"
    t.string "external_url"
    t.boolean "image_processing"
    t.index ["imageable_id", "type"], name: "index_images_on_imageable_id_and_type"
  end

  create_table "libraries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "public"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "library_elements_count", default: 0
    t.string "exhibition_name"
    t.integer "hearts_count", default: 0
    t.integer "comments_count", default: 0
    t.float "popularity", default: 0.0
    t.boolean "audited", default: false
    t.index ["user_id"], name: "index_libraries_on_user_id"
  end

  create_table "library_elements", id: :serial, force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "exhibition_date"
    t.boolean "inactive", default: false
    t.index ["article_id"], name: "index_library_elements_on_article_id"
    t.index ["library_id"], name: "index_library_elements_on_library_id"
  end

  create_table "line_item_groups", id: :serial, force: :cascade do |t|
    t.text "message"
    t.bigint "cart_id"
    t.bigint "seller_id"
    t.bigint "buyer_id"
    t.boolean "tos_accepted"
    t.boolean "unified_transport", default: false
    t.boolean "unified_payment", default: false
    t.string "unified_payment_method"
    t.bigint "transport_address_id"
    t.bigint "payment_address_id"
    t.string "purchase_id"
    t.datetime "sold_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "unified_transport_provider"
    t.integer "unified_transport_maximum_articles"
    t.bigint "unified_transport_price_cents", default: 0
    t.bigint "free_transport_at_price_cents"
    t.boolean "purchase_emails_sent", default: false
    t.datetime "purchase_emails_sent_at"
    t.index ["buyer_id"], name: "index_line_item_groups_on_buyer_id"
    t.index ["cart_id"], name: "index_line_item_groups_on_cart_id"
    t.index ["payment_address_id"], name: "index_line_item_groups_on_payment_address_id"
    t.index ["purchase_id"], name: "index_line_item_groups_on_purchase_id"
    t.index ["seller_id"], name: "index_line_item_groups_on_seller_id"
    t.index ["transport_address_id"], name: "index_line_item_groups_on_transport_address_id"
  end

  create_table "line_items", id: :serial, force: :cascade do |t|
    t.bigint "line_item_group_id"
    t.bigint "article_id"
    t.integer "requested_quantity", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_line_items_on_article_id"
    t.index ["line_item_group_id"], name: "index_line_items_on_line_item_group_id"
  end

  create_table "mass_upload_articles", id: :serial, force: :cascade do |t|
    t.integer "mass_upload_id"
    t.integer "article_id"
    t.string "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "row_index"
    t.text "validation_errors"
    t.text "article_csv"
    t.string "process_identifier"
    t.index ["article_id"], name: "index_mass_upload_articles_on_article_id"
    t.index ["mass_upload_id"], name: "index_mass_upload_articles_on_mass_upload_id"
    t.index ["row_index", "mass_upload_id"], name: "index_mass_upload_articles_on_row_index_and_mass_upload_id"
    t.index ["row_index"], name: "index_mass_upload_articles_on_row_index"
  end

  create_table "mass_uploads", id: :serial, force: :cascade do |t|
    t.integer "row_count"
    t.text "failure_reason"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.string "state"
    t.index ["user_id"], name: "index_mass_uploads_on_user_id"
  end

  create_table "notices", id: :serial, force: :cascade do |t|
    t.text "message"
    t.boolean "open"
    t.integer "user_id"
    t.string "path"
    t.string "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.string "pay_key"
    t.string "state"
    t.string "type"
    t.text "error"
    t.text "last_ipn"
    t.bigint "line_item_group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["line_item_group_id"], name: "index_payment_on_line_item_group_id"
  end

  create_table "rails_admin_histories", id: :serial, force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.string "rating"
    t.text "text"
    t.bigint "rated_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "line_item_group_id"
    t.index ["line_item_group_id"], name: "index_line_item_group_id_on_ratings"
    t.index ["rated_user_id"], name: "index_ratings_on_rated_user_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.string "reason"
    t.text "description"
    t.integer "business_transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_transaction_id"], name: "index_refunds_on_business_transaction_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "social_producer_questionnaires", id: :serial, force: :cascade do |t|
    t.bigint "article_id"
    t.boolean "nonprofit_association", default: false
    t.text "nonprofit_association_checkboxes"
    t.boolean "social_businesses_muhammad_yunus", default: false
    t.text "social_businesses_muhammad_yunus_checkboxes"
    t.boolean "social_entrepreneur", default: false
    t.text "social_entrepreneur_checkboxes"
    t.text "social_entrepreneur_explanation"
    t.index ["article_id"], name: "index_social_producer_questionnaires_on_article_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "banned"
    t.string "nickname"
    t.text "about_me"
    t.text "terms"
    t.text "cancellation"
    t.text "about"
    t.string "phone"
    t.string "mobile"
    t.string "fax"
    t.string "slug"
    t.string "type"
    t.string "bank_code"
    t.string "bank_name"
    t.string "bank_account_owner"
    t.string "bank_account_number"
    t.string "paypal_account"
    t.string "seller_state"
    t.string "buyer_state"
    t.boolean "verified"
    t.boolean "bankaccount_warning"
    t.float "percentage_of_positive_ratings", default: 0.0
    t.float "percentage_of_negative_ratings", default: 0.0
    t.boolean "direct_debit", default: false
    t.float "percentage_of_neutral_ratings", default: 0.0
    t.boolean "ngo", default: false
    t.bigint "value_of_goods_cents", default: 0
    t.bigint "max_value_of_goods_cents_bonus", default: 0
    t.integer "fastbill_subscription_id"
    t.integer "fastbill_id"
    t.string "iban"
    t.string "bic"
    t.boolean "vacationing", default: false
    t.boolean "newsletter", default: false
    t.string "cancellation_form_file_name"
    t.string "cancellation_form_content_type"
    t.integer "cancellation_form_file_size"
    t.datetime "cancellation_form_updated_at"
    t.bigint "standard_address_id"
    t.integer "unified_transport_maximum_articles", default: 1
    t.string "unified_transport_provider"
    t.bigint "unified_transport_price_cents", default: 0
    t.boolean "free_transport_available"
    t.bigint "free_transport_at_price_cents", default: 0
    t.boolean "receive_comments_notification", default: true
    t.boolean "heavy_uploader", default: false
    t.boolean "uses_vouchers", default: false
    t.bigint "total_purchase_donations_cents", default: 0
    t.string "belboon_tracking_token"
    t.datetime "belboon_tracking_token_set_at"
    t.integer "voluntary_contribution"
    t.string "invoicing_email", default: "", null: false
    t.string "order_notifications_email", default: "", null: false
    t.boolean "direct_debit_exemption", default: false
    t.integer "next_direct_debit_mandate_number", default: 1
    t.boolean "marketplace_owner_account", default: false
    t.string "referral", default: ""
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["standard_address_id"], name: "index_users_on_standard_address_id"
  end

end
