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
class TransactionsController < InheritedResources::Base
  respond_to :html
  actions :show, :edit, :update

  before_filter :authenticate_user!
  before_filter :authorize_resource

  def edit
    edit!
  end

  private
  def authorize_resource
    authorize resource
  end

  # def update
  #   authorize resource
  #   update! do |success,failure|
  #     success.html { redirect_to user_libraries_path(@user, :anchor => "library#{@library.id}") }
  #     failure.html { redirect_to user_libraries_path(@user), :alert => @library.errors.full_messages.first }
  #   end
  # end
end
