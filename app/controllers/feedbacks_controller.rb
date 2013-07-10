#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class FeedbacksController < InheritedResources::Base
  respond_to :html
  actions :create, :new
  skip_before_filter :authenticate_user!
  def create
    authorize build_resource
    create! do |success,failure|

      success.html { redirect_to :back, :notice => (I18n.t 'article.actions.reported')  }
      failure.html { redirect_to :back, :alert => @feedback.errors.full_messages.first }

    end
  end

  def new
    @type = params[:type]
    authorize build_resource
    new!
  end

end
