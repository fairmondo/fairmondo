class ChangeIntegerToBigInt < ActiveRecord::Migration
  change_column :article_templates, :user_id, :integer, limit: 8

  change_table :articles do |t|
    t.change :user_id, :integer, limit: 8
    t.change :price_cents, :integer, limit: 8
    t.change :article_template_id, :integer, limit: 8
    t.change :calculated_fair_cents, :integer, limit: 8, default: 0, null: false
    t.change :calculated_friendly_cents, :integer, limit: 8, default: 0, null: false
    t.change :calculated_fee_cents, :integer, limit: 8, default: 0, null: false
  end

  change_column :articles_categories, :article_id, :integer, limit: 8

  change_table :bids do |t|
    t.change :user_id, :integer, limit: 8
    t.change :price_cents, :integer, limit: 8
    t.change :auction_transaction_id, :integer, limit: 8
  end

  change_table :exhibits do |t|
    t.change :article_id, :integer, limit: 8
    t.change :related_article_id, :integer, limit: 8
  end

  change_column :fair_trust_questionnaires, :article_id, :integer, limit: 8

  change_table :feedbacks do |t|
    t.change :user_id, :integer, limit: 8
    t.change :article_id, :integer, limit: 8
  end

  change_column :images, :imageable_id, :integer, limit: 8

  change_column :libraries, :user_id, :integer, limit: 8

  change_table :library_elements do |t|
    t.change :article_id, :integer, limit: 8
    t.change :library_id, :integer, limit:8
  end

  change_table :ratings do |t|
    t.change :transaction_id, :integer, limit: 8
    t.change :rated_user_id, :integer, limit: 8
  end

  change_column :social_producer_questionnaires, :article_id, :integer, limit: 8

  change_table :transactions do |t|
    t.change :buyer_id, :integer, limit: 8
    t.change :parent_id, :integer, limit: 8
    t.change :article_id, :integer, limit: 8
    t.change :seller_id, :integer, limit: 8
  end

  change_table :users do |t|
    t.change :value_of_goods_cents, :integer, limit: 8, default: 0
    t.change :max_value_of_goods_cents_bonus, :integer, limit: 8, default: 0
  end
end
