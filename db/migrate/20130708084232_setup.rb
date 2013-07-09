class Setup < ActiveRecord::Migration
  def self.up
    # Cleaned up old migrations before launch

    create_table "article_templates", :force => true do |t|
      t.string   "name"
      t.integer  "user_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "article_templates", ["user_id"], :name => "index_article_templates_on_user_id"

    create_table "articles", :force => true do |t|
      t.string   "title"
      t.text     "content",                                :limit => 255
      t.datetime "created_at",                                                               :null => false
      t.datetime "updated_at",                                                               :null => false
      t.integer  "user_id"
      t.string   "condition"
      t.integer  "price_cents"
      t.string   "currency"
      t.string   "default_payment"
      t.boolean  "fair",                                                  :default => false
      t.string   "fair_kind"
      t.string   "fair_seal"
      t.boolean  "ecologic",                                              :default => false
      t.string   "ecologic_seal"
      t.boolean  "small_and_precious",                                    :default => false
      t.integer  "small_and_precious_edition"
      t.text     "small_and_precious_reason"
      t.boolean  "small_and_precious_handmade",                           :default => false
      t.integer  "quantity"
      t.string   "default_transport"
      t.text     "transport_details"
      t.text     "payment_details"
      t.integer  "friendly_percent",                       :limit => 3
      t.text     "friendly_percent_organisation"
      t.integer  "article_template_id"
      t.integer  "transaction_id"
      t.integer  "calculated_corruption_cents",                           :default => 0,     :null => false
      t.integer  "calculated_friendly_cents",                             :default => 0,     :null => false
      t.integer  "calculated_fee_cents",                                  :default => 0,     :null => false
      t.string   "condition_extra"
      t.boolean  "small_and_precious_eu_small_enterprise"
      t.string   "ecologic_kind"
      t.text     "upcycling_reason"
      t.string   "slug"
      t.boolean  "transport_pickup"
      t.boolean  "transport_insured"
      t.boolean  "transport_uninsured"
      t.string   "transport_insured_provider"
      t.string   "transport_uninsured_provider"
      t.integer  "transport_insured_price_cents",                         :default => 0,     :null => false
      t.integer  "transport_uninsured_price_cents",                       :default => 0,     :null => false
      t.boolean  "payment_bank_transfer"
      t.boolean  "payment_cash"
      t.boolean  "payment_paypal"
      t.boolean  "payment_cash_on_delivery"
      t.boolean  "payment_invoice"
      t.integer  "payment_cash_on_delivery_price_cents",                  :default => 0,     :null => false
      t.integer  "basic_price_cents",                                     :default => 0,     :null => false
      t.string   "basic_price_amount"
      t.string   "state"
      t.integer  "vat",                                                   :default => 0
    end

    add_index "articles", ["article_template_id"], :name => "index_articles_on_article_template_id"
    add_index "articles", ["id", "article_template_id"], :name => "index_articles_on_id_and_article_template_id", :unique => true
    add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true
    add_index "articles", ["transaction_id"], :name => "index_articles_on_transaction_id"
    add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

    create_table "articles_categories", :force => true do |t|
      t.integer "category_id"
      t.integer "article_id"
    end

    add_index "articles_categories", ["article_id", "category_id"], :name => "articles_category_index"
    add_index "articles_categories", ["article_id"], :name => "index_articles_categories_on_article_id"
    add_index "articles_categories", ["category_id"], :name => "index_articles_categories_on_category_id"

    create_table "bids", :force => true do |t|
      t.integer  "user_id"
      t.datetime "created_at",             :null => false
      t.datetime "updated_at",             :null => false
      t.integer  "price_cents"
      t.string   "price_currency"
      t.integer  "auction_transaction_id"
    end

    add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.string   "desc"
      t.integer  "parent_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
    end

    add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

    create_table "contents", :force => true do |t|
      t.string   "key"
      t.text     "body",       :limit => 255
      t.datetime "created_at",                :null => false
      t.datetime "updated_at",                :null => false
    end

    add_index "contents", ["key"], :name => "index_tinycms_contents_on_key", :unique => true

    create_table "delayed_jobs", :force => true do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.string   "queue"
      t.datetime "created_at",                :null => false
      t.datetime "updated_at",                :null => false
    end

    add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

    create_table "fair_trust_questionnaires", :force => true do |t|
      t.integer "article_id"
      t.boolean "support"
      t.text    "support_explanation"
      t.boolean "transparency"
      t.text    "transparency_explanation"
      t.boolean "collaboration"
      t.text    "collaboration_explanation"
      t.boolean "minimum_wage"
      t.text    "minimum_wage_explanation"
      t.boolean "child_labor"
      t.text    "child_labor_explanation"
      t.boolean "sexual_equality"
      t.text    "sexual_equality_explanation"
      t.boolean "labor_conditions"
      t.text    "labor_conditions_explanation"
      t.boolean "producer_advancement"
      t.text    "producer_advancement_explanation"
      t.boolean "awareness_raising"
      t.text    "awareness_raising_explanation"
      t.boolean "environment_protection"
      t.text    "environment_protection_explanation"
    end

    add_index "fair_trust_questionnaires", ["article_id"], :name => "index_fair_trust_questionnaires_on_article_id"

    create_table "feedbacks", :force => true do |t|
      t.text     "text"
      t.string   "subject"
      t.string   "from"
      t.string   "to"
      t.string   "type"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
      t.integer  "user_id"
      t.integer  "article_id"
      t.string   "feedback_subject"
      t.string   "help_subject"
    end

    add_index "feedbacks", ["article_id"], :name => "index_feedbacks_on_article_id"
    add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id"

    create_table "images", :force => true do |t|
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
      t.integer  "imageable_id"
      t.string   "imageable_type"
    end

    add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"

    create_table "libraries", :force => true do |t|
      t.string   "name"
      t.boolean  "public"
      t.integer  "user_id"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
      t.integer  "library_elements_count", :default => 0
    end

    add_index "libraries", ["user_id"], :name => "index_libraries_on_user_id"

    create_table "library_elements", :force => true do |t|
      t.integer  "article_id"
      t.integer  "library_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "library_elements", ["article_id"], :name => "index_library_elements_on_article_id"
    add_index "library_elements", ["library_id"], :name => "index_library_elements_on_library_id"

    create_table "rails_admin_histories", :force => true do |t|
      t.text     "message"
      t.string   "username"
      t.integer  "item"
      t.string   "table"
      t.integer  "month",      :limit => 2
      t.integer  "year",       :limit => 5
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

    create_table "sessions", :force => true do |t|
      t.string   "session_id", :null => false
      t.text     "data"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

    create_table "settings", :force => true do |t|
      t.string   "var",                      :null => false
      t.text     "value"
      t.integer  "thing_id"
      t.string   "thing_type", :limit => 30
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
    end

    add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

    create_table "social_producer_questionnaires", :force => true do |t|
      t.integer "article_id"
      t.boolean "nonprofit_association",                     :default => true
      t.text    "nonprofit_association_purposes"
      t.boolean "social_businesses_muhammad_yunus",          :default => true
      t.text    "social_businesses_muhammad_yunus_purposes"
      t.boolean "social_entrepreneur",                       :default => true
      t.text    "social_entrepreneur_purposes"
    end

    add_index "social_producer_questionnaires", ["article_id"], :name => "index_social_producer_questionnaires_on_article_id"

    create_table "transactions", :force => true do |t|
      t.integer  "max_bid"
      t.string   "type"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.datetime "expire"
    end

    create_table "users", :force => true do |t|
      t.string   "email",                  :default => "",    :null => false
      t.string   "encrypted_password",     :default => "",    :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.integer  "sign_in_count",          :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
      t.string   "forename"
      t.string   "surname"
      t.boolean  "admin",                  :default => false
      t.integer  "invitor_id"
      t.boolean  "trustcommunity"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.boolean  "banned"
      t.string   "nickname"
      t.text     "about_me"
      t.text     "terms"
      t.text     "cancellation"
      t.text     "about"
      t.string   "title"
      t.string   "country"
      t.string   "street"
      t.string   "city"
      t.string   "zip"
      t.string   "phone"
      t.string   "mobile"
      t.string   "fax"
      t.string   "slug"
      t.string   "type"
      t.string   "uid"
      t.boolean  "uid_confirmed"
      t.string   "bank_code"
      t.string   "bank_name"
      t.string   "bank_account_owner"
      t.string   "bank_account_number"
      t.string   "paypal_account"
      t.string   "company_name"
    end

    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
    add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  end

  def self.down
    # Doesn't make  any sense
  end
end
