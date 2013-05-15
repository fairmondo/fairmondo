module Article::Initial
  extend ActiveSupport::Concern

  included do
   after_initialize :initialize_values
  end

  def initialize_values
    begin
    self.quantity ||= 1
    self.price ||= 1
    self.friendly_percent ||= 0
    self.active = false if self.new_record?
    self.locked = false if self.new_record?
    # Auto-Completion raises MissingAttributeError:
    # http://www.tatvartha.com/2011/03/activerecordmissingattributeerror-missing-attribute-a-bug-or-a-features/
    rescue ActiveModel::MissingAttributeError
    end
  end
end