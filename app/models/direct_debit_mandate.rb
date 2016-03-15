class DirectDebitMandate < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :reference, presence: true

  # class methods
  def self.build(user)
    instance = DirectDebitMandate.new(user: user)
    instance.generate_reference
    instance
  end

  def self.creditor_identifier
    'DE15ZZZ00001452371'
  end

  # instance methods

  # generate_reference
  # The mandate reference is a base36 [0-9,A-Z] representation of the md5sum of the user id and
  # creation date of the mandate. It is 25 characters long.
  # Example: 70VP07ETJD0LE8Q1YF9F9Y7D4
  def generate_reference
    base_str = user_id.to_s + created_at.to_s
    s16 = Digest::MD5.hexdigest(base_str)
    i10 = s16.to_i(16)
    s36 = i10.to_s(36)
    self.reference = s36.upcase
  end
end
