class Article < ActiveRecord::Base
  extend Enumerize


  # bugbug Check if all/any should be accessible (done only for mass upload)
  attr_accessible :title, :content, :created_at, :updated_at, :id, :user_id,
                  :transaction_id, :default_transport, :default_payment,
                  :categories, :transport_insured_cents, :basis_price_cents,
                  :basis_price_amount, :category_1, :category_2, :vat,
                  :categories, :article_template_id, :active, :slug, :state

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :title, :use => :slugged
  validates_presence_of :slug

  delegate :terms, :cancellation, :about, :country , :to => :seller, :prefix => true

  # Relations


  validates_presence_of :transaction , :unless => :template?
  belongs_to :transaction, :dependent => :destroy
  accepts_nested_attributes_for :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  belongs_to :seller, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?

  belongs_to :article_template

   #article module concerns
  include Categories, Commendation, FeesAndDonations, Images, Initial, Attributes, Search, Sanitize, Template, State


  def images_attributes=(attributes)
    self.images.clear
    attributes.each_key do |key|
      if attributes[key].has_key? :id
        self.images << Image.find(attributes[key][:id]) unless attributes[key].has_key?(:_destroy)
      else
        self.images << Image.new(attributes[key])
      end
    end
  end


  # We have to do this in the article class because we want to
  # override the dynamic Rails method to get rid of the RecordNotFound
  # http://stackoverflow.com/questions/9864501/recordnotfound-with-accepts-nested-attributes-for-and-belongs-to
  def seller_attributes=(seller_attrs)
    if seller_attrs.has_key?(:id)
      self.seller = User.find(seller_attrs.delete(:id))
      rejected = seller_attrs.reject { |k,v| valid_seller_attributes.include?(k) }
      if rejected != nil && !rejected.empty? # Docs say reject! will return nil for no change but returns empty array
        raise SecurityError
      end
      self.seller.attributes = seller_attrs
    end
  end

   # The allowed attributes for updating user/seller in article form
  def valid_seller_attributes
    ["bank_code", "bank_account_number", "bank_account_owner" ,"paypal_account", "bank_name" ]
  end

  amoeba do
    enable
    include_field :fair_trust_questionnaire
    include_field :social_producer_questionnaire
    include_field :categories
    nullify :transaction_id
    nullify :article_template_id
    customize(lambda { |original_article,new_article|
      original_article.images.each do |image|
        copyimage = Image.new
        copyimage.image = image.image
        new_article.images << copyimage
        copyimage.save
      end
    })
  end

  # bugbug Mass upload via csv

  def self.import(file, current_user)
    CSV.foreach(file.path, headers: false) do |row|
      row << ('user_id')
      row << ('categories')
      row << ('transaction_id')
    end
    CSV.foreach(file.path, headers: true) do |row|
      categories = [Category.find(row['category_1'])]
      categories << Category.find(row['category_2']) if row['category_2']
      row.delete('category_1')
      row.delete('category_2')
      # What is a Transaction anyway? Are they really needed at this moment?
      # How to create it the right way?
      transaction = Transaction.create(type: "PreviewTransaction")
      row['transaction_id'] = transaction.id
      row['user_id'] = current_user.id
      row['categories'] = categories
      p '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      a = Article.new(row.to_hash)
      p a
      a.save!
      # Article.create(row.to_hash)
    end
  end

end