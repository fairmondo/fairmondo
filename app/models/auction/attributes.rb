module Auction::Attributes
  extend ActiveSupport::Concern

  included do

    #common fields
    attr_accessible :title, :content, :condition  ,:condition_extra, :payment ,:payment_details  , :quantity 
    
    #transport
    attr_accessible :default_transport, :transport_pickup, 
                    :transport_insured, :transport_insured_price_cents,
                    :transport_insured_price, :transport_insured_provider, 
                    :transport_uninsured, :transport_uninsured_price_cents,
                    :transport_uninsured_price, :transport_uninsured_provider,
                    :transport_details
    
    # market place state
    attr_protected :locked, :active

    #money_rails
    attr_accessible :price_cents , :currency, :price
    
    validates_presence_of :title , :content, :unless => :template? # refs #128 
    validates_length_of :title, :minimum => 6, :maximum => 65
    
    validates_presence_of :condition, :price_cents
    validates_presence_of :condition_extra , :if => :old?
    enumerize :condition, :in => [:new, :old], :predicates =>  true
    enumerize :condition_extra, :in => [:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken] # refs #225

    validates_numericality_of :price,
    :greater_than_or_equal_to => 0

    monetize :price_cents
    
   
    enumerize :default_transport, :in => [:pickup, :insured, :uninsured]
   
    validates_presence_of :default_transport
    validates :transport_insured_price, :transport_insured_provider, :presence => true ,:if => :transport_insured
    validates :transport_uninsured_price, :transport_uninsured_provider, :presence => true ,:if => :transport_uninsured
  
    monetize :transport_uninsured_price_cents
    monetize :transport_insured_price_cents
    
    validate :default_transport_selected
    
    serialize :payment, Array
    enumerize :payment, :in => [:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice], :multiple => true
    validates :payment, :size => 1..-1
    validates_presence_of :payment_details

    validates_presence_of :quantity
    validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000

  end
  
  def default_transport_selected
    if self.default_transport
      unless self.send("transport_#{self.default_transport}")
        errors.add(:default_transport, t("errors.messages.invalid_default_transport"))
      end
    end
  end
  
end