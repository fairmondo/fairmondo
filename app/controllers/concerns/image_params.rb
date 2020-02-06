#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ImageParams
  extend ActiveSupport::Concern

  IMAGE_PARAMS = %i(image is_title).freeze
  NESTED_IMAGE_PARAMS = (%i(_destroy, id) + IMAGE_PARAMS).freeze
end
