class Invoice < ActiveRecord::Base
  invoice_attributes =  [ :due_date,
                          :state,
                          :user_id,
                          :total_fee_cents ]
  attr_accessible *invoice_attributes
  attr_accessible *invoice_attributes, :as => :admin

  belongs_to :user
  has_many :invoice_items
  has_many :articles, :through => :invoice_items
  # Law of Demeter
  # try to refactor to use immediate associations
  # delegate :attr1, :attr2, :to => :article, :prefix => true

  validates_presence_of :user_id, :due_date, :state, :total_fee_cents
  validates_numericality_of :total_fee_cents


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
  # triggered by transaction_observer, transaction state_machine event: 'buy'
  def self.invoice_action_chain( transaction )
    @seller = transaction.article.seller

    if @seller.has_open_invoice?
      @invoice = Invoice.find_by_user_id_and_state( @seller.id, "open" ).last
      add_item_to_open_invoice( transaction, invoice )
      invoice.set_due_date
    else
      create_new_invoice_and_add_item( transaction, @seller )
    end
  end
  # Funzt aus irgendeinem Grund nicht
  # handle_asynchronously :invoice_action_chain

  def self.create_new_invoice_and_add_item( transaction, seller )
    invoice = Invoice.create  :user_id => seller.id,
                              :total_fee_cents => 0

    add_item_to_open_invoice( transaction, invoice )
    invoice.set_due_date
    invoice.add_quarterly_fee
  end

  def self.add_item_to_open_invoice( transaction, invoice )
    invoice_item = InvoiceItem.create   :article_id => transaction.article.id,
                                        :invoice_id => invoice.id,
                                        :quantity => transaction.quantity_bought,
                                        :price_cents => transaction.article.price_cents,
                                        :calculated_fee_cents => transaction.article.calculated_fee_cents,
                                        :calculated_fair_cents => transaction.article.calculated_fair_cents,
                                        :calculated_friendly_cents => transaction.article.calculated_friendly_cents
  end

  # this method adds the quarterly fee to the invoice if invoice is the last of this quarter
  def add_quarterly_fee
    # Das Datum muss ins selbe Format gebracht werden
    if Time.now.end_of_quarter == self.due_date
      invoice_item = InvoiceItem.create   :invoice_id => self.id,
                                          :quantity => 1,
                                          :price_cents => 100
    end
  end

  # calculates the total fee for the invoice, sums up all calculated values for each corresponding invoice item
  def calculate_total_fee
    self.invoice_items.each do |invoice_item|
      self.total_fee_cents += invoice_item.calculated_friendly_cents + invoice_item.calculated_fair_cents + invoice_item.calculated_fee_cents
    end
  end

  # checks if the invoice is billable this month or if will be billed at the end of the quarter
  def invoice_billable?
    self.total_fee_cents >= 1000
  end

  # sets the due date for the invoice depending on the billable state
  def set_due_date
    unless self.invoice_billable?
      self.due_date = 30.days.from_now.at_end_of_quarter
    else
      self.due_date = 30.days.from_now.at_end_of_month
    end
  end
end
