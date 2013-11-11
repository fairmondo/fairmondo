class Notice < ActiveRecord::Base

  #def self.notification_attrs
  #  [:user,:message,:open]
  #end

  belongs_to :user

  def color
    super.to_sym
  end

  def color=(value)
    super(value.to_sym)
    color
  end


end
