class DirectDebitMandate < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :reference, presence: true, uniqueness: true

  # state machine
  after_initialize :initialize_state_machines
  state_machine initial: :new do
    state :new, :active, :inactive

    event :activate do
      transition new: :active
    end

    event :deactivate do
      transition active: :inactive
    end

    event :revoke do
      transition active: :revoked
    end

    before_transition new: :active do |mandate, _transition|
      mandate.activated_at = Time.now
    end

    before_transition active: :revoked do |mandate, _transition|
      mandate.revoked_at = Time.now
    end
  end

  # class methods
  def self.creditor_identifier
    'DE15ZZZ00001452371'
  end

  # instance methods
  def reference_date
    created_at&.to_date
  end

  def to_s
    "#{self.reference} (#{I18n.l(self.reference_date)})"
  end
end
