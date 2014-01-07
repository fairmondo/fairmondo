class Notice < ActiveRecord::Base
  belongs_to :user

  def color
    super.to_sym
  end

  def color=(value)
    super(value.to_sym)
    color
  end
end
