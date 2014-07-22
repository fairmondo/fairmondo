module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, counter_cache: true
  end
end
