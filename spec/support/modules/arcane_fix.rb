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
