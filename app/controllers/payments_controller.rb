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
    @payment = Payment.find(params[:id])
    authorize @payment
    redirect_to PaypalAPI.checkout_url @payment.pay_key
  end

  # create happens on buy. this is to initialize the payment with paypal
  def update
    @payment = Payment.find(params[:id])
    authorize @payment
    if @payment.init
      redirect_to PaypalAPI.checkout_url @payment.pay_key
    else
      redirect_to :back, flash: { error: "Paypal mag grad nich" }
    end
  end
end
