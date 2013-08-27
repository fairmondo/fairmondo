class Invoice < ActiveRecord::Base
  invoice_attributes =  [ :article_id,
                          :created_at,
                          :due_date,
                          :state,
                          :updated_at,
                          :user_id ]
  attr_accessible *invoice_attributes
  attr_accessible *invoice_attributes, :as => :admin

  belongs_to :user
  has_many :invoice_items
  has_many :articles, :through => :invoice_items

  validates_presence_of :user_id, :due_date, :state


  ################ State machine for states of invoice ################
  state_machine :initial => :open do
  	state :open do
      # initial state for all new invoices
  	end

  	state :closed do
      # state when invoice is paid
  	end

  	state :first_reminder do
      # erste Mahnung
  	end

  	state :second_reminder do
      # zweite Mahnung
  	end

    # Abmahnen
    event :remind do
      transition :open => :first_reminder, :first_reminder => :second_reminder
    end

    # Rechnung ist beglichen und wird geschlossen
    event :close do
      transition [ :open, :first_reminder, :second_reminder ] => :closed
    end
  end
  ################ State machine for states of invoice ################

  ################ Methods ################
  def self.invoice_action_chain( transaction )
    @seller = transaction.article.seller

    if @seller.has_open_invoice?
      invoice = Invoice.where( :user_id => @seller.id, :state => :open ).order( "created_at" ).last
      add_article_to_open_invoice( transaction, invoice )
    else
      create_new_invoice_and_add_item( transaction, @seller )
    end
  end
  # Funzt aus irgendeinem Grund nicht
  # handle_asynchronously :invoice_action_chain

  def self.create_new_invoice_and_add_item( transaction, seller )
    invoice = Invoice.create  :user_id => seller.id,
                              :due_date => 1.month.from_now

    add_item_to_open_invoice( transaction, invoice )
  end

  def self.add_item_to_open_invoice( transaction, invoice )
    invoice_item = InvoiceItem.create   :article_id => transaction.article.id,
                                        :invoice_id => invoice.id,
                                        #:quantity => transaction.quantity_bought,
                                        :price_cents => transaction.article.price_cents,
                                        :calculated_fee_cents => transaction.article.calculated_fee_cents,
                                        :calculated_fair_cents => transaction.article.calculated_fair_cents,
                                        :calculated_friendly_cents => transaction.article.calculated_friendly_cents
                                        #:quarterly_fee
  end

  def total_fee( transaction )
    self.total_fee_cents += transaction.article.calculated_friendly_cents + transaction.article.calculated_fair_cents + transaction.article.calculated_fee_cents
  end

  def invoice_billable?
    self.total_fee_cents >= 10000
  end
end
