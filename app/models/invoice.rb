class Invoice < ActiveRecord::Base
  invoice_attributes =  [ :article_id,
                          :created_at,
                          :due_date,
                          :state,
                          :updated_at,
                          :invoice_date,
                          :user_id ]
  attr_accessible *invoice_attributes
  attr_accessible *invoice_attributes, :as => :admin

  belongs_to :user
  has_and_belongs_to_many :articles

  validates_presence_of :user_id, :created_at, :updated_at, :due_date, :state


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

  def self.invoice_action_chain( transaction )
    extend InvoicesHelper

    @article  = Article.find_by_transaction_id( transaction.id )
    @seller   = User.find_by_id( @article.user_id )

    if has_open_invoice( @seller )
      add_article_to_invoice ( @article )
    else
      create_new_invoice( @article, @seller )
    end
  end
  # Funzt aus irgendeinem Grund nicht
  # handle_asynchronously :invoice_action_chain
end
