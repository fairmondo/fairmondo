#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::Delegates
  extend ActiveSupport::Concern

  included do
    delegate :id, :terms, :cancellation, :about, :country, :ngo, :nickname,
             :email, :vacationing?, :free_transport_available,
             :free_transport_at_price,
             to: :seller, prefix: true
    delegate :nickname,
             to: :friendly_percent_organisation, prefix: true, allow_nil: true
  end
end
