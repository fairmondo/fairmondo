module Article::Initial
  extend ActiveSupport::Concern

  included do
   after_initialize :initialize_values
   after_initialize :build_dependencies
  end

  def initialize_values
    begin
    self.quantity ||= 1
    self.price ||= 1
    self.friendly_percent ||= 0
    self.active = false if self.new_record?
    # Auto-Completion raises MissingAttributeError:
    # http://www.tatvartha.com/2011/03/activerecordmissingattributeerror-missing-attribute-a-bug-or-a-features/
    rescue ActiveModel::MissingAttributeError
    end
  end

  def build_dependencies
    self.build_transaction unless self.transaction
    self.build_fair_trust_questionnaire unless self.fair_trust_questionnaire
    self.build_social_producer_questionnaire unless self.social_producer_questionnaire
  end


end
