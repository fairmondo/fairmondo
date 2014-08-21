module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy, inverse_of: :commentable
  end
end
