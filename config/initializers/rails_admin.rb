# RailsAdmin config file. Generated on October 10, 2013 11:34
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Fairmondo', 'Admin']

  # RailsAdmin may need a way to know who the current user is
  config.authorize_with do
    redirect_to main_app.user_path(current_user.id) unless current_user.try(:admin?)
  end

  # Include specific models (exclude the others):
  config.included_models = [
    'Article', 'FairTrustQuestionnaire', 'SocialProducerQuestionnaire',
    'Category', 'ArticleImage', 'UserImage', 'FeedbackImage', 'Comment',
    'User', 'PrivateUser', 'LegalEntity',
    'Address', 'MassUpload', 'Library', 'LibraryElement',
    'Cart', 'LineItem', 'LineItemGroup', 'BusinessTransaction', 'Payment',
    'Rating', 'Refund', 'Discount',
    'Content', 'Feedback'
  ]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ['User']
    end
    export
    bulk_delete do
      except ['User']
    end
    show
    edit
    delete do
      except ['User']
    end
    show_in_app

    # Addons

    statistics do
      only ['BusinessTransaction', 'User', 'PrivateUser', 'LegalEntity']
    end
    nested_set do
      only ['Category']
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # Label methods for model instances: # Default is [:name, :title]
  config.label_methods << :nickname


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki

  config.model 'Article' do
    navigation_label 'Thema: Artikel'
    weight(-3)

    list do
      field :id
      field :title
      field :seller
      field :state
      field :created_at
      field :updated_at
    end

    field :id do
      read_only true
    end
    field :seller do
      read_only true
    end
    field :title
    field :content
    field :created_at
    field :updated_at
    field :condition
    field :price_cents
    field :fair
    field :fair_kind
    field :fair_seal
    field :ecologic
    field :ecologic_seal
    field :small_and_precious
    field :small_and_precious_reason
    field :small_and_precious_handmade
    field :quantity
    field :transport_details
    field :payment_details
    field :friendly_percent
    field :friendly_percent_organisation
    field :calculated_fair_cents do
      read_only true
    end
    field :calculated_friendly_cents do
      read_only true
    end
    field :calculated_fee_cents do
      read_only true
    end
    field :condition_extra
    field :small_and_precious_eu_small_enterprise
    field :ecologic_kind
    field :upcycling_reason
    field :slug do
      read_only true
    end
    field :transport_pickup
    field :transport_type1
    field :transport_type2
    field :transport_type1_provider
    field :transport_type2_provider
    field :transport_type1_price_cents
    field :transport_type2_price_cents
    field :payment_bank_transfer
    field :payment_cash
    field :payment_paypal
    field :payment_cash_on_delivery
    field :payment_invoice
    field :payment_cash_on_delivery_price_cents
    field :basic_price_cents
    field :basic_price_amount
    field :state do
      read_only true
    end
    field :vat
    field :custom_seller_identifier
    field :gtin
    field :transport_type1_number
    field :transport_type2_number
    field :discount_id
    field :categories
  end
  config.model 'FairTrustQuestionnaire' do
    parent Article
  end
  config.model 'SocialProducerQuestionnaire' do
    parent Article
  end
  config.model 'ArticleImage' do
    parent Article
    label 'Artikelbild'
    label_plural 'Artikelbilder'
  end
  config.model 'Category' do
    navigation_label 'Thema: Artikel'

    list do
      field :id
      field :name
      field :weight
      field :created_at
      field :updated_at
    end

    field :name
    field :desc
    field :created_at
    field :updated_at
    field :weight
    field :view_columns
    field :slug
    field :parent
    field :children

    nested_set(max_depth: 5)
  end
  config.model 'Discount' do
    navigation_label 'Thema: Artikel'
  end
  config.model 'Refund' do
    navigation_label 'Thema: Artikel'
  end

  config.model 'Cart' do
    weight(-1)
    navigation_label 'Thema: Verkaufsprozess'
    list do
      field :sold
      field :user
      field :line_item_count
      field :purchase_emails_sent
      field :purchase_emails_sent_at
    end
  end
  config.model 'LineItem' do
    navigation_label 'Thema: Verkaufsprozess'
  end
  config.model 'LineItemGroup' do
    navigation_label 'Thema: Verkaufsprozess'
  end
  config.model 'BusinessTransaction' do
    navigation_label 'Thema: Verkaufsprozess'
  end
  config.model 'Payment' do
    navigation_label 'Thema: Verkaufsprozess'
  end

  config.model 'User' do
    navigation_label 'Thema: Nutzer'
    weight(-2)

    list do
      field :id
      field :email
      field :nickname
      field :type
      field :verified
      field :banned
      field :created_at
      field :updated_at
    end

    configure :seller_line_item_groups, :has_many_association
    configure :buyer_line_item_groups, :has_many_association

    field(:id) { read_only true }
    field :email
    field :password
    field :password_confirmation
    field(:reset_password_sent_at) { read_only true }
    field(:sign_in_count) { read_only true }
    field(:current_sign_in_at) { read_only true }
    field(:last_sign_in_at) { read_only true }
    field(:current_sign_in_ip) { read_only true }
    field(:last_sign_in_ip) { read_only true }
    field :created_at
    field :updated_at
    field :admin
    field(:confirmation_token) { read_only true }
    field :confirmed_at
    field(:confirmation_sent_at) { read_only true }
    field :unconfirmed_email
    field :banned
    field :nickname
    field :about_me
    field :terms
    field :cancellation
    field :about
    field :phone
    field :mobile
    field :fax
    field(:slug) { read_only true }
    field(:type) { read_only true }
    field :bank_account_owner
    field :bank_account_number
    field :bank_code
    field :bank_name
    field :iban
    field :bic
    field :paypal_account
    field(:bankaccount_warning) { read_only true }
    field(:fastbill_id) { read_only true }
    field(:fastbill_subscription_id) { read_only true }
    field(:seller_state) { read_only true }
    field(:buyer_state) { read_only true }
    field :verified
    field :direct_debit

    field :ngo
    field :max_value_of_goods_cents_bonus
    field :heavy_uploader
    field(:buyer_line_item_groups) { read_only true }
    field(:seller_line_item_groups) { read_only true }

    show do
      field :addresses
      field(:articles) do
        associated_collection_scope do
          Proc.new { |scope| scope.limit(50) }
        end
      end
    end
  end
  config.model 'PrivateUser' do
    parent User
    label 'Privater Nutzer'
    label_plural 'Private Nutzer'

    list do
      field :id
      field :email
      field :nickname
      field :type
      field :verified
      field :banned
    end
  end
  config.model 'LegalEntity' do
    parent User
    label 'Gewerblicher Nutzer'
    label_plural 'Gewerbliche Nutzer'

    list do
      field :id
      field :email
      field :nickname
      field :type
      field :verified
      field :banned
    end
  end
  config.model 'UserImage' do
    parent User
    label 'Profilbild'
    label_plural 'Profilbilder'
  end
  config.model 'Address' do
    navigation_label 'Thema: Nutzer'
    object_label_method :concat_address
  end
  config.model 'Rating' do
    navigation_label 'Thema: Nutzer'
  end
  config.model 'MassUpload' do
    navigation_label 'Thema: Nutzer'
  end

  config.model 'Library' do
    navigation_label 'Sonstiges'
  end
  config.model 'LibraryElement' do
    parent Library
  end
    config.model 'Content' do
    navigation_label 'Sonstiges'
  end
  config.model 'Feedback' do
    navigation_label 'Sonstiges'
  end
  config.model 'FeedbackImage' do
    parent Feedback
    label 'Feedback-Bild'
    label_plural 'Feedback-Bilder'
  end
  config.model 'Comment' do
    navigation_label 'Sonstiges'
  end

  # Helper Methods
  def concat_address
    "#{address_line_1}, #{zip} #{city}"
  end
end
