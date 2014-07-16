class MegaMigration < ActiveRecord::Migration

  class Article < ActiveRecord::Base
    has_many :business_transactions
    belongs_to :seller, class_name: 'PseudoUser', foreign_key: 'user_id'
  end

  # From "Make Ready for Battle"
  class BusinessTransaction < ActiveRecord::Base
    belongs_to :line_item_group
    belongs_to :article
    belongs_to :seller, class_name: 'PseudoUser', foreign_key: 'seller_id'
    belongs_to :buyer, class_name: 'PseudoUser', foreign_key: 'buyer_id'
  end

  class LineItemGroup < ActiveRecord::Base
    has_many :business_transactions
  end

  # From "MoveAddressesFromUserModelToAddressModel"
  class PseudoUser < ActiveRecord::Base
    self.table_name =  "users"
    has_many :addresses, foreign_key: 'user_id'
    has_many :bought_business_transactions, class_name: 'BusinessTransaction', foreign_key: 'buyer_id' # As buyer
  end

  class Address < ActiveRecord::Base
    belongs_to :user, class_name: 'PseudoUser', foreign_key: 'user_id' # As buyer
  end



  def up
    ### FIELD CREATIONS AND CHANGES ###

    # Create Addresses
    create_table :addresses do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :address_line_1
      t.string :address_line_2
      t.string :zip
      t.string :city
      t.string :country
      t.integer :user_id
      t.boolean :stashed, default: false
    end
    add_index :addresses, :user_id, name: :addresses_user_id_index


    # Create Carts
    create_table :carts do |t|
      t.timestamps
      t.integer :user_id, limit: 8
      t.boolean :sold, default: false
    end
    add_index :carts, ["user_id"], :name => "index_carts_on_user_id"

    # Create Line Items
    create_table :line_items do |t|
      t.integer  "line_item_group_id", limit: 8
      t.integer  "article_id",         limit: 8
      t.integer  "requested_quantity", default: 1
      t.timestamps
    end
    add_index :line_items, ["line_item_group_id"], :name => "index_line_items_on_line_item_group_id"
    add_index :line_items, ["article_id"], :name => "index_line_items_on_article_id"

    # Create Line Item Groups
    create_table :line_item_groups do |t|
      t.text :message
      t.integer :cart_id, limit:8
      t.integer :seller_id, limit:8
      t.integer :buyer_id, limit:8
      t.boolean :tos_accepted
      t.boolean :unified_transport, default: false
      t.boolean :unified_payment, default: false
      t.string  :unified_payment_method
      t.integer :transport_address_id, limit:8
      t.integer :payment_address_id, limit:8

      t.timestamps
    end
    add_index :line_item_groups, ["cart_id"], :name => "index_line_item_groups_on_cart_id"
    add_index :line_item_groups, ["seller_id"], :name => "index_line_item_groups_on_seller_id"
    add_index :line_item_groups, ["buyer_id"], :name => "index_line_item_groups_on_buyer_id"
    add_index :line_item_groups, ["transport_address_id"], :name => "index_line_item_groups_on_transport_address_id"
    add_index :line_item_groups, ["payment_address_id"], :name => "index_line_item_groups_on_payment_address_id"

    # Create Payments
    create_table :payments do |t|
      t.string :pay_key, :state
      t.text :error, :last_ipn
      t.timestamps
    end

    # Change Users
    add_column :users, :standard_address_id, :bigint
    add_column :users, :unified_transport_maximum_articles, :integer, default: 1
    add_column :users, :unified_transport_provider, :string
    add_column :users, :unified_transport_price_cents, :integer, limit: 8, default: 0
    add_column :users, :unified_transport_free, :boolean
    add_column :users, :unified_transport_free_at_price_cents, :integer, limit: 8, default: 0

    add_index :users, :standard_address_id, name: 'index_users_on_standard_address_id'

    # Change Business Transactions
    add_column :business_transactions, :transport_address_id, :bigint
    add_column :business_transactions, :payment_address_id, :bigint
    add_column :business_transactions, :payment_id, :bigint
    add_column :business_transactions, :line_item_group_id, :integer, limit: 8
    add_column :business_transactions, :unified_transport_provider, :string
    add_column :business_transactions, :unified_transport_maximum_articles, :integer
    add_column :business_transactions, :unified_transport_price_cents, :integer, limit: 8, default: 0
    add_column :business_transactions, :unified_transport_free_at_price_cents, :integer, limit: 8, default: 0

    add_index :business_transactions, :transport_address_id, name: 'index_business_transactions_on_transport_address_id'
    add_index :business_transactions, :payment_address_id, name: 'index_business_transactions_on_payment_address_id'
    add_index :business_transactions, :payment_id, name: 'index_business_transactions_on_payment_id'
    add_index :business_transactions, :line_item_group_id, name: 'index_business_transactions_on_line_item_group_id'


    # Change Articles
    add_column :articles, :quantity_available, :integer
    add_column :articles, :unified_transport, :boolean


    ### DATA CHANGES ###

    # Make Transaction Model Ready For Battle
    rename_column :business_transactions, :type, :type_fix

    mfps = BusinessTransaction.where(type_fix: 'MultipleFixedPriceTransaction')
    mfps.find_each do |mfp|
      mfp.article.update_column(:quantity_available, mfp.quantity_available)
      mfp.destroy
    end


    BusinessTransaction.where(type_fix: 'PreviewTransaction').destroy_all

    BusinessTransaction.where(state: 'available').find_each do |t|
      t.destroy
    end

    sfpt = BusinessTransaction.where(type_fix: 'SingleFixedPriceTransaction')
    sfpt.find_each do |sfp|
      sfp.article.update_column(:quantity_available, 0 )
    end


    BusinessTransaction.all.find_each do |t|
      lig = LineItemGroup.create(message: t.message, tos_accepted: t.tos_accepted, seller_id: t.seller_id, buyer_id: t.buyer_id,created_at: t.created_at, updated_at: t.updated_at)
      t.update_column :line_item_group_id, lig.id
    end



    # MoveAddressesFromUserModelToAddressModel
    PseudoUser.find_each do |user|
      user = user.becomes(PseudoUser)
      std_add = Address.create(
        title: user.title,
        first_name: user.forename,
        last_name: user.surname,
        company_name: user.company_name,
        address_line_1: user.street,
        address_line_2: user.address_suffix,
        zip: user.zip,
        city: user.city,
        country: user.country,
        user_id: user.id
      )
      std_add.reload
      user.update_column :standard_address_id, std_add.id

      user.bought_business_transactions.find_each do |bt|
        new_address = true
        address = nil

        user.addresses.find_each do |add|
          if (add.first_name == bt.forename) &&
              (add.last_name == bt.surname) &&
                (add.address_line_1 == bt.street) &&
                  (add.address_line_2 == bt.address_suffix) &&
                    (add.zip == bt.zip) &&
                      (add.city == bt.city) &&
                        (add.country == bt.country)

            new_address = false
            address = add
          end
        end

        if new_address
          address = user.addresses.build(
            first_name: bt.forename,
            last_name: bt.surname,
            address_line_1: bt.street,
            address_line_2: bt.address_suffix,
            zip: bt.zip,
            city: bt.city,
            country: bt.country
          )
          address.save
          address.reload
        end

        bt.update_column(:transport_address_id, address.id)
        bt.update_column(:payment_address_id, address.id)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
