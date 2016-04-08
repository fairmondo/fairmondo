class DirectDebitMandate < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :reference, presence: true, uniqueness: true

  after_initialize :create_reference_if_blank

  # state machine
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
    if created_at.present?
      created_at.to_date
    else
      Date.current
    end
  end

  private

  def create_reference_if_blank
    if self.reference.blank?
      self.reference = calculate_reference
    end
  end

  # calculate_reference
  # The mandate reference is a base36 [0-9,A-Z] representation of the md5sum of the user id and
  # creation date of the mandate. It is 25 characters long.
  # Example: 70VP07ETJD0LE8Q1YF9F9Y7D4
  def calculate_reference
    base_str = user_id.to_s + Time.now.utc.to_s
    s16 = Digest::MD5.hexdigest(base_str)
    i10 = s16.to_i(16)
    s36 = i10.to_s(36)
    s36.upcase
  end
end
