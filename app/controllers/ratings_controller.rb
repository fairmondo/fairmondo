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
class RatingsController < InheritedResources::Base
  respond_to :html
  actions :index, :create, :new

  before_filter :get_user
  before_filter :authorize_new_with_transaction, only: :new
  skip_before_filter :authenticate_user!, only: :index

  def create
    authorize build_resource
    build_resource.rating_user = current_user
    build_resource.rated_user = build_resource.transaction.seller
    create! do |success,failure|
      success.html { redirect_to user_path(current_user, :anchor => :bought), :notice => t('rating.notice.saved') }
    end
  end

  protected

    def collection
      @ratings ||= end_of_association_chain.page(params[:page])
    end

    def begin_of_association_chain
      @user
    end

  private

    def get_user
      @user = User.find(params[:user_id])
    end

    def authorize_new_with_transaction
      rating = build_resource
      rating.transaction = Transaction.find(params[:transaction_id])
      authorize rating
    end
end
