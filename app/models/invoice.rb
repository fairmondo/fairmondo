class Invoice < ActiveRecord::Base
  attr_accessible :article_id, :created_at, :due_date, :state, :updated_at, :user_id

  belongs_to :user
  has_many :articles

  validates_presence_of :article_id, :user_id, :created_at, :updated_at, :due_date, :state


  # State machine for states of invoice
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
end
