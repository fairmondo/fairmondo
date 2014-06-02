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
class BusinessTransactionsController < InheritedResources::Base
  respond_to :html
  actions :show, :edit, :update
  custom_actions :resource => [:already_sold, :print_order_buyer, :request_refund]#, :print_order_seller]

  before_filter :redirect_if_already_sold, only: [:edit, :update]
  before_filter :redirect_if_not_yet_sold, only: :show, unless: :multiple?
  before_filter :redirect_to_child_show, only: :show, if: :multiple?
  before_filter :authorize_resource
  before_filter :dont_cache

  def edit
    edit! { return render :step2 if request.patch? && resource.edit_params_valid?(refined_params) }
  end

  # def show
  #   if resource.available? # if available actually pundit should forbid this action
  #     redirect_to edit_business_transaction_path resource
  #   else
  #     show!
  #   end
  # end

  def print_order_buyer
    show! do |format|
      format.html do
        render :print_order_buyer, layout: false
      end
    end
  end

  def update
    resource.buyer_id = current_user.id
    update! do |success, failure|
      resource.buy if success.class # using .class was the only way I could find to get a true or false value
      failure.html do
        if resource.edit_params_valid? refined_params
          return render :step2
        else
          return render :edit
        end
      end
    end
  end

  private
    ## show ##
    def redirect_if_not_yet_sold
      if resource.available? && ( !resource.buyer || !resource.buyer.is?(current_user) )
        redirect_to edit_business_transaction_path(resource)
      end
    end

    def redirect_to_child_show
      if resource.children
        child_transactions = resource.children.select { |c| c.buyer == current_user }
        unless child_transactions.empty?
          redirect_to business_transaction_path child_transactions[-1]
        end
      end
    end

    ## edit, update ##
    def redirect_if_already_sold
      redirect_to already_sold_business_transaction_path(resource) unless resource.available?
    end

    ## other ##
    def multiple?
      resource.multiple?
    end
end
