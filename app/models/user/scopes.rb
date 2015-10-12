#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module User::Scopes
  extend ActiveSupport::Concern

  included do
    scope :sorted_ngo, -> { order(:nickname).where(ngo: true) }
    scope :ngo_with_profile_image, -> { where(ngo: true).joins(:image).limit(6) }
    scope :banned, -> { where(banned: true) }
    scope :unbanned, -> { where('banned = ? OR banned IS NULL', false) }
  end
end
