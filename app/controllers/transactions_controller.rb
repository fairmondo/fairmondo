#
#
# == License:
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
class TransactionsController < InheritedResources::Base
  respond_to :html
  actions :show, :edit, :update

  before_filter :authenticate_user!
  before_filter :authorize_resource
  # before_filter :ensure_tos_accepted, only: :edit

  def edit
    edit! do
      if params["transaction"] && params["transaction"]["tos_accepted"] == "1" && params["transaction"]["selected_payment"] && params["transaction"]["selected_transport"]
        return render :step2
      end
    end
  end

  private
  def authorize_resource
    authorize resource
  end

  # def ensure_tos_accepted
  #   if params["transaction"]["tos_accepted"] && params["transaction"]["tos_accepted"] != "1"
  #     flash[:error] = t('article.notices.incomplete_profile')
  #   end
  # end

  # def update
  #   authorize resource
  #   update! do |success,failure|
  #     success.html { redirect_to user_libraries_path(@user, :anchor => "library#{@library.id}") }
  #     failure.html { redirect_to user_libraries_path(@user), :alert => @library.errors.full_messages.first }
  #   end
  # end
end
