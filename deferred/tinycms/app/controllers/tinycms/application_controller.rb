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
class Tinycms::ApplicationController < ApplicationController
  include Tinycms::ApplicationHelper

  skip_before_filter :authenticate_user!

  private
  unless method_defined? :authenticate_tinycms_user
    if method_defined? :authenticate_user!
      def authenticate_tinycms_user
        authenticate_user!
      end
    else
      warn "Tinycms: Please define 'authenticate_tinycms_user' in your ApplicationController"
      def authenticate_tinycms_user
      end
    end
  end

  def ensure_admin
    raise "You need to be an administrator to do that." unless tinycms_admin?
  end

  unless method_defined? :tinycms_user
    if method_defined? :current_user
      define_method :tinycms_user do
        current_user
      end
    else
      raise "Tinycms: Please define 'tincms_user' in your ApplicationController"
    end
  end
  helper_method :tinycms_user

  unless method_defined? :tinycms_admin?
    def tinycms_admin?
      tinycms_user && tinycms_user.admin?
    end
  end
  helper_method :tinycms_admin?

end
