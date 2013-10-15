class Invoice < ActiveRecord::Base
  invoice_attributes =  [ :due_date,
                          :state,
                          :total_fee_cents,
                          :user_id ]
  # # attr_accessible *invoice_attributes
  # # attr_accessible *invoice_attributes, :as => :admin
  
  # def self.invoice_attrs
  #   [ :due_date,
  #     :state,
  #     :total_fee_cents,
  #     :user_id ]
  # end

  belongs_to :user
  has_many :transactions
  # Law of Demeter
  # try to refactor to use immediate associations
  # delegate :attr1, :attr2, :to => :article, :prefix => true

  validates_presence_of *invoice_attributes
  validates_numericality_of :total_fee_cents, :only_integer => true, :greater_than_or_equal_to => 0

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
    seller = transaction.seller
    unless seller.is_a_ngo?
      if seller.has_open_invoice?
        invoice = Invoice.find_by_user_id_and_state( seller.id, "open" ) #TODO sort by due_date
        invoice.add_item_to_open_invoice( transaction )
        invoice.set_due_date
        invoice.calculate_total_fee
      else
        create_new_invoice_and_add_item( transaction )
      end
    end
  end
  # Funzt aus irgendeinem Grund nicht
  # handle_asynchronously :invoice_action_chain

  def self.create_new_invoice_and_add_item( transaction )
    invoice = Invoice.new :user_id => transaction.seller_id,
                          :total_fee_cents => 0,
                          :state => 'open'

    invoice.set_due_date
    invoice.add_item_to_open_invoice( transaction )
    invoice.add_quarterly_fee
    invoice.save
  end

  def add_item_to_open_invoice( transaction )
    tr = Transaction.find( transaction.id )
    if self.due_date > 30.days.from_now
      tr.invoice_id = self.id
      tr.save
    else
      create_new_invoice_and_add_item( transaction )
    end
  end

  # this method adds the quarterly fee to the invoice if invoice is the last of this quarter
  def add_quarterly_fee
    # Das Datum muss ins selbe Format gebracht werden
    if Time.now.end_of_quarter == self.due_date
      #TODO Funktion muss noch geschrieben werden
    end
  end

  # calculates the total fee for the invoice, sums up all calculated values for each corresponding invoice item
  def calculate_total_fee
    self.transactions.each do |transaction|
      self.total_fee_cents += transaction.article.calculated_fair_cents + transaction.article.calculated_fee_cents # + transaction.calculated_friendly_cents 
    end
    self.save
  end

  # checks if the invoice is billable this month or if will be billed at the end of the quarter
  def invoice_billable?
    self.total_fee_cents >= 1000
  end

  # sets the due date for the invoice depending on the billable state
  def set_due_date
    if self.invoice_billable?
      self.due_date = 30.days.from_now.at_end_of_month
    else
      self.due_date = 30.days.from_now.at_end_of_quarter
    end
  end
end
