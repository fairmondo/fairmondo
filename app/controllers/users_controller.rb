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
class UsersController < InheritedResources::Base

  respond_to :html
  actions :show
  custom_actions :resource => :profile, :collection => :login

  before_filter :authorize_resource, :except => :login
  before_filter :dont_cache, only: [ :show ]
  skip_before_filter :authenticate_user!, only: [:show, :profile, :login]
  skip_after_filter :verify_authorized_with_exceptions, only: [:login]

  def login
    login! do |format|
      format.html {render "/devise/sessions/new" , :layout => false}
    end
  end

  private

    def authorize_resource
      authorize resource
    end

end
