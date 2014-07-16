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
class PaymentsController < ApplicationController
  respond_to :html

  def show
    @payment = Payment.find params[:id]
    authorize @payment
    redirect_to @payment.paypal_checkout_url
  end

  def create
    authorize create_or_update_target
    @payment.save
    respond_with @payment
  end

  private
    def create_or_update_target
      @payment = Payment.find_or_initialize_by(
        business_transaction_id: BusinessTransaction.find(params[:business_transaction_id]).id
      )
    end
end