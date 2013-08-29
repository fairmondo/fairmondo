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
  custom_actions :resource => :already_sold

  before_filter :redirect_if_already_sold, only: [:edit, :update]
  before_filter :redirect_if_not_yet_sold, only: :show
  before_filter :authorize_resource

  def edit
    edit! { return render :step2 if resource.edit_params_valid? params }
  end

  # def show
  #   if resource.available? # if available actually pundit should forbid this action
  #     redirect_to edit_transaction_path resource
  #   else
  #     show!
  #   end
  # end

  def update
    resource.buyer_id = current_user.id
    update! do |success, failure|
      resource.buy if success.class # using .class was the only way I could find to get a true or false value
      failure.html { redirect_to :back, :alert => resource.errors.full_messages.first }
    end
  end

  private
    def authorize_resource
      authorize resource
    end

    def redirect_if_already_sold
      redirect_to already_sold_transaction_path(resource) unless resource.available?
    end

    def redirect_if_not_yet_sold
      redirect_to edit_transaction_path(resource) if resource.available?
    end
end
