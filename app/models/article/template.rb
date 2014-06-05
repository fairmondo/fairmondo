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


    # Build the template
    after_save :build_and_save_template, :if => :save_as_template?

  end

  def save_as_template?
    self.save_as_template == "1"
  end

   # see #128
  def template?
    template_name != nil
  end

    ########## build Template #################
  def build_and_save_template
    # Reown Template
    cloned_article = self.amoeba_dup #duplicate the article
    cloned_article.save_as_template = "0" #no loops
    cloned_article.save #save the cloned article
  end

end
