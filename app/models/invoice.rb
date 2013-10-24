class Invoice < ActiveRecord::Base
  require 'fastbill-automatic'

  INVOICE_THRESHOLD = 1000

  def self.invoice_attrs
    [ :due_date,
      :state,
      :total_fee_cents,
      :user_id ]
  end

  belongs_to :user
  has_many :transactions
  # Law of Demeter
  # try to refactor to use immediate associations
  # delegate :attr1, :attr2, :to => :article, :prefix => true

  validates_presence_of *Invoice.invoice_attrs
  # validates_numericality_of :total_fee_cents, :only_integer => true, :greater_than_or_equal_to => 0

  ################ State machine for states of invoice ################
  state_machine :initial => :open do
  	state :open do
      # initial state for all new invoices
  	end

    state :pending do
      # state when invoice is delivered but not paid
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
    
    state :third_reminder do
      # dritte Mahnung
    end

    # Rechnung wird verschickt und wartet auf Bezahlung
    event :send_invoice do
      transition :open => :pending
    end

    # Abmahnen
    event :remind do
      transition :open => :first_reminder, :first_reminder => :second_reminder, :second_reminder => :third_reminder
    end

    # Rechnung ist beglichen und wird geschlossen
    event :close do
      transition [ :open, :first_reminder, :second_reminder, :third_reminder ] => :closed
    end
  end
  ################ State machine for states of invoice ################

  ################ Methods ################
  # triggered by transaction_observer, transaction state_machine event: 'buy'
  def self.invoice_action_chain( transaction )
    begin
      unless transaction.seller.is_ngo? #TODO keine Gebuehren statt NGO, Methode fuer NGOs im Usermodel
        invoice = Invoice.find_by_user_id_and_state( transaction.seller.id, "open" ) || Invoice.create( :user_id => transaction.seller_id, :due_date => 30.days.from_now.at_end_of_quarter, :total_fee_cents => 0 )
      end
      invoice.add_item( transaction )
      invoice.calculate_total_fee_cents( transaction )
      invoice.set_due_date
      invoice.save!
    rescue
      # raise "Error"
    end
  end

  def add_item( transaction ) 
    transaction.invoice_id = self.id
    # raise "Halt!"
    transaction.save!
  end

  # this method adds the quarterly fee to the invoice if invoice is the last of this quarter
  def add_quarterly_fee
    # Das Datum muss ins selbe Format gebracht werden
    if Time.now.end_of_quarter == self.due_date
      #TODO Funktion muss noch geschrieben werden
    end
  end

  # calculates the total fee for the invoice, sums up all calculated values for each corresponding invoice item
  # dies sollte die Standard ausgabe fuer total fee werden, der wert soll raus aus der tabelle
  def total_fee
    total_fee = 0
    self.transactions.each do |tr|
      if tr.quantity_bought && tr.article.calculated_fair_cents && tr.article.calculated_fee_cents
        total_fee += tr.quantity_bought * (tr.article.calculated_fair_cents + tr.article.calculated_fee_cents)
      end
    end
    total_fee
  end
  
  def calculate_total_fee_cents( transaction )
    self.total_fee_cents += transaction.quantity_bought * (transaction.article.calculated_fair_cents + transaction.article.calculated_fee_cents)
    self.save
  end

  # checks if the invoice is billable this month or if will be billed at the end of the quarter
  def invoice_billable?
    self.total_fee_cents >= INVOICE_THRESHOLD
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
