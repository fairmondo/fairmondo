#
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
class ArticleTemplate < ActiveRecord::Base
  extend Sanitization

  delegate :title, to: :article, prefix: true

  # def self.article_template_attrs
  #   [:name, :article, article_attributes: Article.article_attrs(false)]
  # end
  auto_sanitize :name

  validates :name, uniqueness: { scope: :user_id }
  validates :name, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_one :article, dependent: :destroy

  accepts_nested_attributes_for :article



  # refs #128 avoid default scope
  def article
    Article.unscoped{super}
  end

  # Check if a template was selected and if user has the right to use it
  #
  # @apt public
  # @param user [User] Usually current_user
  # @param template_select [Hash, nil] Part of a param hash
  # @return [ArticleTemplate, false]
  def self.template_request_by user, template_select
    if template_select && template_select[:article_template] && !template_select[:article_template].blank?
      template = ArticleTemplate.find template_select[:article_template]
      user.article_templates.include?(template) ? template : false
    else
      false
    end
  end

end
