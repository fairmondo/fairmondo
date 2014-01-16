# RailsAdmin config file. Generated on October 10, 2013 11:34
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Fairnopoly', 'Admin']

  config.attr_accessible_role { :admin }

  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  config.authorize_with do
    redirect_to main_app.user_path(current_user.id) unless current_user.try(:admin?)
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = [ 'LegalEntity', 'PrivateUser']

  # Include specific models (exclude the others):
  # config.included_models = ['Article', 'ArticleTemplate', 'Category', 'Content', 'Exhibit', 'FairTrustQuestionnaire', 'Feedback', 'Image', 'LegalEntity', 'Library', 'LibraryElement', 'MultipleFixedPriceTransaction', 'PartialFixedPriceTransaction', 'PreviewTransaction', 'PrivateUser', 'SingleFixedPriceTransaction', 'SocialProducerQuestionnaire', 'Transaction', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



  ###  Article  ###

  config.model 'Article' do
    field :id do
      read_only true
    end
    field :seller do
      read_only true
    end
    field :transaction do
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
    #     field :article_template_id, :integer         # Hidden
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

    # Cross-section configuration:

    # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
    # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
    # label_plural 'My models'      # Same, plural
    # weight 0                      # Navigation priority. Bigger is higher.
    # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
    # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    # Section specific configuration:

    #     list do
    # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
    # items_per_page 100    # Override default_items_per_page
    # sort_by :id           # Sort column (default is primary key)
    # sort_reverse true     # Sort direction (default is true for primary key, last created first)
    #     end
    #     show do; end
    #     edit do; end
    #     export do; end
    # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
    # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
    # using `field` instead of `configure` will exclude all other fields and force the ordering
  end


  ###  ArticleTemplate  ###

  # config.model 'ArticleTemplate' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your article_template.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association
  #     configure :article, :has_one_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :name, :string
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Category  ###

  # config.model 'Category' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your category.rb model definition

  #   # Found associations:

  #     configure :parent, :belongs_to_association
  #     configure :articles, :has_and_belongs_to_many_association
  #     configure :children, :has_many_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :name, :string
  #     configure :desc, :string
  #     configure :parent_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :lft, :integer
  #     configure :rgt, :integer
  #     configure :depth, :integer

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Content  ###

  # config.model 'Content' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your content.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer
  #     configure :key, :string
  #     configure :body, :text
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Exhibit  ###

   config.model 'Exhibit' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your exhibit.rb model definition

  #   # Found associations:

  #     configure :article, :belongs_to_association
  #     configure :related_article, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
       configure :article_id, :integer         # Hidden
       configure :queue, :enum
       configure :related_article_id, :integer         # Hidden
       configure :created_at, :datetime
       configure :updated_at, :datetime
       configure :exhibition_date, :datetime

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
   end


  ###  FairTrustQuestionnaire  ###

  # config.model 'FairTrustQuestionnaire' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your fair_trust_questionnaire.rb model definition

  #   # Found associations:

  #     configure :article, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :support, :boolean
  #     configure :support_explanation, :text
  #     configure :labor_conditions, :boolean
  #     configure :labor_conditions_explanation, :text
  #     configure :awareness_raising, :boolean
  #     configure :awareness_raising_explanation, :text
  #     configure :environment_protection, :boolean
  #     configure :environment_protection_explanation, :text
  #     configure :support_checkboxes, :enum
  #     configure :labor_conditions_checkboxes, :enum
  #     configure :environment_protection_checkboxes, :enum
  #     configure :controlling_checkboxes, :enum
  #     configure :awareness_raising_checkboxes, :enum
  #     configure :controlling, :boolean
  #     configure :controlling_explanation, :text
  #     configure :support_other, :string
  #     configure :labor_conditions_other, :string
  #     configure :environment_protection_other, :string
  #     configure :controlling_other, :string
  #     configure :awareness_raising_other, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Feedback  ###

  # config.model 'Feedback' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your feedback.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association
  #     configure :article, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :text, :text
  #     configure :subject, :string
  #     configure :from, :string
  #     configure :to, :enum
  #     configure :variety, :enum
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :user_id, :integer         # Hidden
  #     configure :article_id, :integer         # Hidden
  #     configure :feedback_subject, :enum
  #     configure :help_subject, :enum
  #     configure :source_page, :text
  #     configure :user_agent, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Image  ###

  # config.model 'Image' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your image.rb model definition

  #   # Found associations:

  #     configure :imageable, :polymorphic_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :image_file_name, :string         # Hidden
  #     configure :image_content_type, :string         # Hidden
  #     configure :image_file_size, :integer         # Hidden
  #     configure :image_updated_at, :datetime         # Hidden
  #     configure :image, :paperclip
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :imageable_id, :integer         # Hidden
  #     configure :imageable_type, :string         # Hidden
  #     configure :is_title, :boolean
  #     configure :external_url, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  config.model 'User' do
    field :id do
     read_only true
    end
    field :email
    field :password
    field :password_confirmation
    #field :reset_password_token, :string         # Hidden
    field :reset_password_sent_at do
     read_only true
    end
    field :sign_in_count do
     read_only true
    end
    field :current_sign_in_at do
     read_only true
    end
    field :last_sign_in_at do
     read_only true
    end
    field :current_sign_in_ip do
     read_only true
    end
    field :last_sign_in_ip do
     read_only true
    end
    field :created_at
    field :updated_at
    field :forename
    field :surname
    field :admin
    #field :invitor_id, :integer
    #field :trustcommunity, :boolean
    field :confirmation_token do
     read_only true
    end
    field :confirmed_at
    field :confirmation_sent_at do
     read_only true
    end
    field :unconfirmed_email
    field :banned
    field :nickname
    field :about_me
    field :terms
    field :cancellation
    field :about
    field :title
    field :country
    field :street
    field :city
    field :zip
    field :phone
    field :mobile
    field :fax
    field :slug do
     read_only true
    end
    field :type do
     read_only true
    end
    field :bank_code
    field :bank_name
    field :bank_account_owner
    field :bank_account_number
    field :paypal_account
    field :company_name
    field :bankaccount_warning do
     read_only true
    end
    field :seller_state do
     read_only true
    end
    field :buyer_state do
     read_only true
    end
    field :verified
    field :direct_debit
    field :address_suffix

    field :ngo
    field :max_value_of_goods_cents_bonus
    field :articles do
      read_only true
    end
    field :bought_articles do
      read_only true
    end
    field :bought_transactions do
      read_only true
    end
    field :sold_transactions do
      read_only true
    end

    # Cross-section configuration:

    # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
    # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
    # label_plural 'My models'      # Same, plural
    # weight 0                      # Navigation priority. Bigger is higher.
    # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
    # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    # Section specific configuration:

    # list do
    #   filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
    #   items_per_page 100    # Override default_items_per_page
    #   sort_by :id           # Sort column (default is primary key)
    #   sort_reverse true     # Sort direction (default is true for primary key, last created first)
    # end
    # show do; end
    # edit do; end
    # export do; end
    # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
    # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
    # using `field` instead of `configure` will exclude all other fields and force the ordering
  end


  ###  Library  ###

  # config.model 'Library' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your library.rb model definition

  #   # Found associations:

  #     configure :user, :belongs_to_association
  #     configure :library_elements, :has_many_association
  #     configure :articles, :has_many_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :name, :string
  #     configure :public, :boolean
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :library_elements_count, :integer

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  LibraryElement  ###

  # config.model 'LibraryElement' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your library_element.rb model definition

  #   # Found associations:

  #     configure :article, :belongs_to_association
  #     configure :library, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :library_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:

  #     configure :buyer, :belongs_to_association
  #     configure :article, :belongs_to_association
  #     configure :seller, :belongs_to_association
  #     configure :children, :has_many_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :type, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :expire, :datetime
  #     configure :selected_transport, :enum
  #     configure :selected_payment, :enum
  #     configure :tos_accepted, :boolean
  #     configure :buyer_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :message, :text
  #     configure :quantity_available, :integer
  #     configure :quantity_bought, :integer
  #     configure :parent_id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :country, :string
  #     configure :seller_id, :integer         # Hidden
  #     configure :sold_at, :datetime
  #     configure :purchase_emails_sent, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:

  #     configure :buyer, :belongs_to_association
  #     configure :parent, :belongs_to_association
  #     configure :article, :belongs_to_association
  #     configure :seller, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :type, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :expire, :datetime
  #     configure :selected_transport, :enum
  #     configure :selected_payment, :enum
  #     configure :tos_accepted, :boolean
  #     configure :buyer_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :message, :text
  #     configure :quantity_available, :integer
  #     configure :quantity_bought, :integer
  #     configure :parent_id, :integer         # Hidden
  #     configure :article_id, :integer         # Hidden
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :country, :string
  #     configure :seller_id, :integer         # Hidden
  #     configure :sold_at, :datetime
  #     configure :purchase_emails_sent, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:

  #     configure :buyer, :belongs_to_association
  #     configure :article, :belongs_to_association
  #     configure :seller, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :type, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :expire, :datetime
  #     configure :selected_transport, :enum
  #     configure :selected_payment, :enum
  #     configure :tos_accepted, :boolean
  #     configure :buyer_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :message, :text
  #     configure :quantity_available, :integer
  #     configure :quantity_bought, :integer
  #     configure :parent_id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :country, :string
  #     configure :seller_id, :integer         # Hidden
  #     configure :sold_at, :datetime
  #     configure :purchase_emails_sent, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:

  #     configure :transactions, :has_many_association
  #     configure :articles, :has_many_association
  #     configure :bought_articles, :has_many_association
  #     configure :bought_transactions, :has_many_association
  #     configure :sold_transactions, :has_many_association
  #     configure :article_templates, :has_many_association
  #     configure :libraries, :has_many_association
  #     configure :image, :has_one_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :email, :string
  #     configure :password, :password         # Hidden
  #     configure :password_confirmation, :password         # Hidden
  #     configure :reset_password_token, :string         # Hidden
  #     configure :reset_password_sent_at, :datetime
  #     configure :sign_in_count, :integer
  #     configure :current_sign_in_at, :datetime
  #     configure :last_sign_in_at, :datetime
  #     configure :current_sign_in_ip, :string
  #     configure :last_sign_in_ip, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :admin, :boolean
  #     configure :invitor_id, :integer
  #     configure :trustcommunity, :boolean
  #     configure :confirmation_token, :string
  #     configure :confirmed_at, :datetime
  #     configure :confirmation_sent_at, :datetime
  #     configure :unconfirmed_email, :string
  #     configure :banned, :boolean
  #     configure :nickname, :string
  #     configure :about_me, :text
  #     configure :terms, :text
  #     configure :cancellation, :text
  #     configure :about, :text
  #     configure :title, :string
  #     configure :country, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :phone, :string
  #     configure :mobile, :string
  #     configure :fax, :string
  #     configure :slug, :string
  #     configure :type, :string
  #     configure :bank_code, :string
  #     configure :bank_name, :string
  #     configure :bank_account_owner, :string
  #     configure :bank_account_number, :string
  #     configure :paypal_account, :string
  #     configure :company_name, :string
  #     configure :bankaccount_warning, :boolean
  #     configure :seller_state, :string
  #     configure :buyer_state, :string
  #     configure :verified, :boolean
  #     configure :direct_debit, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:

  #     configure :buyer, :belongs_to_association
  #     configure :article, :belongs_to_association
  #     configure :seller, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :type, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :expire, :datetime
  #     configure :selected_transport, :enum
  #     configure :selected_payment, :enum
  #     configure :tos_accepted, :boolean
  #     configure :buyer_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :message, :text
  #     configure :quantity_available, :integer
  #     configure :quantity_bought, :integer
  #     configure :parent_id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :country, :string
  #     configure :seller_id, :integer         # Hidden
  #     configure :sold_at, :datetime
  #     configure :purchase_emails_sent, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  SocialProducerQuestionnaire  ###

  # config.model 'SocialProducerQuestionnaire' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your social_producer_questionnaire.rb model definition

  #   # Found associations:

  #     configure :article, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :nonprofit_association, :boolean
  #     configure :nonprofit_association_checkboxes, :enum
  #     configure :social_businesses_muhammad_yunus, :boolean
  #     configure :social_businesses_muhammad_yunus_checkboxes, :enum
  #     configure :social_entrepreneur, :boolean
  #     configure :social_entrepreneur_checkboxes, :enum
  #     configure :social_entrepreneur_explanation, :text

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  Transaction  ###

  # config.model 'Transaction' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your transaction.rb model definition

  #   # Found associations:

  #     configure :buyer, :belongs_to_association
  #     configure :article, :belongs_to_association
  #     configure :seller, :belongs_to_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :type, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :expire, :datetime
  #     configure :selected_transport, :enum
  #     configure :selected_payment, :enum
  #     configure :tos_accepted, :boolean
  #     configure :buyer_id, :integer         # Hidden
  #     configure :state, :string
  #     configure :message, :text
  #     configure :quantity_available, :integer
  #     configure :quantity_bought, :integer
  #     configure :parent_id, :integer
  #     configure :article_id, :integer         # Hidden
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :country, :string
  #     configure :seller_id, :integer         # Hidden
  #     configure :sold_at, :datetime
  #     configure :purchase_emails_sent, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end


  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:

  #     configure :transactions, :has_many_association
  #     configure :articles, :has_many_association
  #     configure :bought_articles, :has_many_association
  #     configure :bought_transactions, :has_many_association
  #     configure :sold_transactions, :has_many_association
  #     configure :article_templates, :has_many_association
  #     configure :libraries, :has_many_association
  #     configure :image, :has_one_association

  #   # Found columns:

  #     configure :id, :integer
  #     configure :email, :string
  #     configure :password, :password         # Hidden
  #     configure :password_confirmation, :password         # Hidden
  #     configure :reset_password_token, :string         # Hidden
  #     configure :reset_password_sent_at, :datetime
  #     configure :sign_in_count, :integer
  #     configure :current_sign_in_at, :datetime
  #     configure :last_sign_in_at, :datetime
  #     configure :current_sign_in_ip, :string
  #     configure :last_sign_in_ip, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :forename, :string
  #     configure :surname, :string
  #     configure :admin, :boolean
  #     configure :invitor_id, :integer
  #     configure :trustcommunity, :boolean
  #     configure :confirmation_token, :string
  #     configure :confirmed_at, :datetime
  #     configure :confirmation_sent_at, :datetime
  #     configure :unconfirmed_email, :string
  #     configure :banned, :boolean
  #     configure :nickname, :string
  #     configure :about_me, :text
  #     configure :terms, :text
  #     configure :cancellation, :text
  #     configure :about, :text
  #     configure :title, :string
  #     configure :country, :string
  #     configure :street, :string
  #     configure :city, :string
  #     configure :zip, :string
  #     configure :phone, :string
  #     configure :mobile, :string
  #     configure :fax, :string
  #     configure :slug, :string
  #     configure :type, :string
  #     configure :bank_code, :string
  #     configure :bank_name, :string
  #     configure :bank_account_owner, :string
  #     configure :bank_account_number, :string
  #     configure :paypal_account, :string
  #     configure :company_name, :string
  #     configure :bankaccount_warning, :boolean
  #     configure :seller_state, :string
  #     configure :buyer_state, :string
  #     configure :verified, :boolean
  #     configure :direct_debit, :boolean
  #     configure :address_suffix, :string

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
