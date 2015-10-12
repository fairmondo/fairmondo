#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# To make a model commentable:
# + include Commentable (in model)
# + concerns: [:commentable] (in routes.rb)
# + add comments_count column to the model's table
# + add the class to COMMENTABLES (in CommentsController)
# + render "comments/commentable_comments", commentable: resource (in view)
# + make sure there is an ID on the element surrounding that render like #library17

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true, inverse_of: :comments

  delegate :image_url, :nickname,
           to: :user, prefix: true
  delegate :user,
           to: :commentable, prefix: true

  validates :commentable, presence: true
  validates :user, presence: true
  validates :text, presence: true, length: { maximum: 1000 }

  default_scope { order(created_at: :desc) }

  scope :legal_entity_publishable, -> do # LegalEntity comments are only published at certain times.
    # if now is not between 10am and 5pm
    #   show if created_at is <= the last 5pm
    # else show everything
    if Time.now < Time.now.beginning_of_day + FIRST_PUBLISH_HOUR.hours || Time.now > Time.now.beginning_of_day + LAST_PUBLISH_HOUR.hours
      last_5pm = Time.now.hour >= LAST_PUBLISH_HOUR ? Time.now.beginning_of_day : Time.now.yesterday.beginning_of_day
      last_5pm += LAST_PUBLISH_HOUR.hours

      where('comments.created_at <= ?', last_5pm)
    else
      where '1=1'
    end
  end
  FIRST_PUBLISH_HOUR = 10
  LAST_PUBLISH_HOUR = 17

  paginates_per 5
end
