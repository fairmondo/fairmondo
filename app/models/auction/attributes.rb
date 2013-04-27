module Auction::Attributes
  extend ActiveSupport::Concern
  
  included do
    
    #common fields
    attr_accessible :title, :content, :condition  ,:condition_extra, :transport, :payment ,:payment_details , :transport_details , :quantity 
    
    # market place state
    attr_protected :locked, :active
    
    #money_rails
    attr_accessible :price_cents , :currency, :price
    
    validates_presence_of :title , :content, :unless => :template? # refs #128 
    
    
    validates_presence_of :condition, :price_cents
    validates_presence_of :condition_extra , :if => :old?
    enumerize :condition, :in => [:new, :old], :predicates =>  true
    enumerize :condition_extra, :in => [:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken] # refs #225
    
    validates_numericality_of :price,
    :greater_than_or_equal_to => 0
    
    monetize :price_cents
    
    serialize :transport, Array
    enumerize :transport, :in => [:pickup, :insured, :uninsured], :multiple => true 
    validates :transport, :size => 1..-1
    validates_presence_of :transport_details
    
    serialize :payment, Array
    enumerize :payment, :in => [:bank_transfer, :cash, :paypal, :cach_on_delivery, :invoice], :multiple => true
    validates :payment, :size => 1..-1
    validates_presence_of :payment_details

    validates_presence_of :quantity
    validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000
    
  end
  
  
end