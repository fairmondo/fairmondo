#
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
module Article::Images
  extend ActiveSupport::Concern

  included do
    # ---- IMAGES ------
    attr_accessible :images_attributes

    has_many :images, as: :imageable #has_and_belongs_to_many :images
    accepts_nested_attributes_for :images, allow_destroy: true


    # Gives first image if there is one
    # @api public
    # @return [Image, nil]
    def title_image
      if images.empty?
        return nil
      else
        return images[0]
      end
    end



  end
end
