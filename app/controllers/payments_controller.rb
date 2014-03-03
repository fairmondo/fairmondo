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
class PaymentsController < InheritedResources::Base
  respond_to :html
  actions :create

  def create
    authorize resource_with_transaction
    paypal_response = resource.paypal_request
    asdf
    create! { redirect_to paypal_response.redirect_uri }
  end

  private
    def resource_with_transaction
      build_resource.transaction = Transaction.find(params[:transaction_id])
      resource
    end
end