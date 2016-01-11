#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ImageRefinery < ApplicationRefinery
  def default nested_attrs = false
    output = [:image, :is_title]
    output.push(:_destroy, :id) if nested_attrs
    output
  end
end
