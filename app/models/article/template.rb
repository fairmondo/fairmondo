#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::Template
  extend ActiveSupport::Concern

  included do

    attr_accessible :article_template_attributes
    # refs #128
    default_scope where(:article_template_id => nil)

    before_save :build_and_save_template, :if => :save_as_template?
    accepts_nested_attributes_for :article_template, :reject_if => proc {|attributes| attributes['save_as_template'] == "0" }

    before_validation :set_user_on_article_template , :if => :save_as_template?
    validates_associated :article_template , :if => :save_as_template?

  end

  def save_as_template?
    self.article_template && self.article_template.save_as_template == "1"
  end

  def set_user_on_article_template
    self.article_template.user = self.seller
  end

   # see #128
  def template?
    # Note:
    # * if not yet saved, there cannot be a article_template_id
    # * the inverse reference is set in article_template model before validation
    article_template_id != nil || article_template != nil
  end

    ########## build Template #################
  def build_and_save_template
    # Reown Template
    cloned_article = self.amoeba_dup
    cloned_article.article_template_id = self.article_template_id
    self.article_template_id = nil
    cloned_article.save #&& cloned_article.images.each { |image| image.save}
  end

end
