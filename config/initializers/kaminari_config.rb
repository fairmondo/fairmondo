#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Kaminari.configure do |config|
   config.default_per_page = 24
   config.max_pages = 300       # set max_pages to avoid large queries
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
   config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end

module Kaminari
  module Helpers
    class Paginator
      # Kaminari Helper Method so RailsBestPractices wont complain
      def kaminari_display_page? page
        page.left_outer? || page.right_outer? || page.inside_window?
      end
    end
  end
end
