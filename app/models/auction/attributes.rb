module Auction::Attributes
  extend ActiveSupport::Concern
  
  included do
    
    validates_presence_of :title , :content, :unless => :template? # refs #128 
    validates_presence_of :condition, :price_cents
    
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
    
    enumerize :condition, :in => [:new, :old]
    enumerize :color, :in => [:white, :black, :yellow, :orange, :red, :green, :blue, :turquoise, :brown, :violet, :grey, :multicolored]   
    validates_length_of :size, :maximum => 4
    validates_presence_of :quantity
    validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000
    
  end
end