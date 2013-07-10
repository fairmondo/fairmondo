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
class Image < ActiveRecord::Base
  attr_accessible :image

  belongs_to :imageable, polymorphic: true #has_and_belongs_to_many :articles
  has_attached_file :image, styles: { medium: "520x360>", thumb: "260x180#", mini: "130x90#" },
                            default_url: "/assets/missing.png",
                            url: "/system/:attachment/:id_partition/:style/:filename",
                            path: "public/system/:attachment/:id_partition/:style/:filename"



  validates_attachment_presence :image
  validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_size :image, :in => 0..5.megabytes


  # Using polymorphy with STI (User) is tricky: http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#label-Polymorphic+Associations
  # @api public
  def imageable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
end
