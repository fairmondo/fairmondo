# To make a model commentable:
# + include Commentable (in model)
# + concerns: [:commentable] (in routes.rb)
# + add comments_count column to the model's table
# + add the class to COMMENTABLES (in CommentsController)
# + render "comments/commentable_comments", commentable: resource (in view)
# + make sure there is an ID on the element surrounding that render like #library17
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true, inverse_of: :comments

  delegate :image_url, :nickname,
           to: :user, prefix: true
  delegate :user,
           to: :commentable, prefix: true

  validates :commentable, presence: true
  validates :user, presence: true
  validates :text, presence: true, length: { maximum: 240 }

  default_scope { order(created_at: :desc) }

  scope :legal_entity_publishable, -> do # LegalEntity comments are only published at certain times.
    # if now is not between 10am and 5pm
    #   show if created_at is <= the last 5pm
    # else show everything
    if Time.now < Time.now.beginning_of_day + FIRST_PUBLISH_HOUR.hours or Time.now > Time.now.beginning_of_day + LAST_PUBLISH_HOUR.hours
      last_5pm = Time.now.hour >= LAST_PUBLISH_HOUR ? Time.now.beginning_of_day : Time.now.yesterday.beginning_of_day
      last_5pm += LAST_PUBLISH_HOUR.hours

      where("comments.created_at <= ?", last_5pm)
    else
      where '1=1'
    end
  end
  FIRST_PUBLISH_HOUR = 10
  LAST_PUBLISH_HOUR = 17

  paginates_per 5
end
