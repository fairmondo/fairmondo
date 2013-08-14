class Invoice < ActiveRecord::Base
  attr_accessible :article_id, :created_at, :due_date, :paid, :state, :updated_at, :user_id
  belongs_to :user
  has_many :articles
end
