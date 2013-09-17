#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Tinycms
  module ApplicationHelper
    include Tinycms::Helper

    def return_to_path(fallback, options = {})
      return session.delete(:return_to) || fallback if options[:clear]
      session[:return_to] || fallback
    end

    # still ugly
    # see http://stackoverflow.com/questions/7588870/engine-routes-in-application-controller
    # http://stackoverflow.com/questions/9232175/access-main-app-helpers-when-overridings-a-rails-engine-view-layout
    # all approaches had their gochtas / didn't work
    #
    # TODO remove namespacing and isolate_namespace
    # or iterate throug main_app methods and define
    #
    # also see http://www.candland.net/2012/04/17/rails-routes-used-in-an-isolated-engine/
    #
    def method_missing method, *args, &block
      if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method, *args)
      if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end

  end
end
