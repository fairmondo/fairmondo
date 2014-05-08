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
class Image < ActiveRecord::Base

  # This is a hack because delayed_paperclip is not working correctly for now
  default_scope order('created_at ASC')

  # Get The Geometry of a image
  #
  # Use the returned Object to get the Size of the image
  # geo = image.geometry :medium
  # geo.width
  # geo.height
  #
  # param style [Symbol] style of the image you want the dimensions of
  # return [Paperclip Geometry Object]
  def geometry style
    Paperclip::Geometry.from_file(self.image.path(style))
  end

  def self.reprocess image_id, style = :thumb
    image = Image.find(image_id).image.reprocess! style
  end
end
