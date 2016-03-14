class DirectDebitMandate < ActiveRecord::Base
  belongs_to :user

  # class methods
  def self.creditor_identifier
    'DE15ZZZ00001452371'
  end
end
