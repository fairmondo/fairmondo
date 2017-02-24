#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# declares intergalactic war to fix some weird arcane shit that makes warden equal nil

module Devise
  module Controllers                                    ##        ######      ######       ##       ###     ##  ######
    module Helpers           #####      #####          ####       ##   ##    ##           ####      ####    ##  ##
      def current_user                                ##  ##      ##   ##   ##           ##  ##     ## ##   ##  ##
        @current_user ||=warden.authenticate(scope: :user) rescue nil###    ##          ##    ##    ##  ##  ##  ######
      end #urrent_user                              ##########    ##  ##    ##         ##########   ##   ## ##  ##
    end # /Helpers      #####      #####           ##        ##   ##   ##    ##       ##        ##  ##    ####  ##
  end # /Controllers                              ##          ##  ##    ##    ###### ##          ## ##     ###  ######
end # /Devise
