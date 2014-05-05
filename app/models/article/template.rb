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
module Article::Template
  extend ActiveSupport::Concern

  included do

    # def self.template_attrs with_nested = true
    #   output = [:save_as_template]
    #   output.push(:id) unless with_nested # Article.id needed for article_template update
    #   output.push(article_template_attributes: ArticleTemplate.article_template_attrs) if with_nested
    #   output
    # end
    #! attr_accessible :article_template_attributes, :save_as_template
    attr_accessor :save_as_template, :backup_template_id

    # Make the original article loose template status
    before_save :ensure_no_template_id, :if => :save_as_template?

    # Build the template
    after_save :build_and_save_template, :if => :save_as_template?
    before_validation :set_user_on_template, :if => :save_as_template?

    # Things to do for the associated template
    accepts_nested_attributes_for :article_template, :reject_if => :not_save_as_template?
    validates_associated :article_template , :if => :save_as_template?

  end

  def save_as_template?
    self.save_as_template == "1"
  end

   def not_save_as_template?
    !save_as_template?
   end

  def set_user_on_template
    self.article_template.user = self.seller
  end

   # see #128
  def template?
    # Note:
    # * if not yet saved, there cannot be a article_template_id
    # * the inverse reference is set in article_template model before validation
    article_template_id != nil
  end

  def ensure_no_template_id
    self.backup_template_id = self.article_template_id # backup the template id
    self.article_template_id = nil # remove the article template link
  end


    ########## build Template #################
  def build_and_save_template
    # Reown Template
    cloned_article = self.amoeba_dup #duplicate the article
    cloned_article.article_template_id = self.backup_template_id # get back the original template id
    cloned_article.save_as_template = "0" #no loops
    cloned_article.save #save the cloned article
  end

end
