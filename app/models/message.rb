class Message < ActiveRecord::Base
  attr_accessible :content, :title, :recipient_id

  belongs_to :message_sender, :class_name => 'User', :foreign_key => 'sender_id', :inverse_of => :messages_sent
  belongs_to :message_recipient, :class_name => 'User', :foreign_key => 'recipient_id', :inverse_of => :messages_received

  validates :title, presence: true
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
end
