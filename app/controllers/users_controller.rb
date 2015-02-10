#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class UsersController < ApplicationController

  include NoticeHelper
  respond_to :html
  respond_to :js, if: lambda { request.xhr? }
  respond_to :pdf, only: :profile

  before_filter :check_for_complete_mass_uploads, only: [:show]
  before_filter :set_user
  before_filter :dont_cache, only: [:show]
  before_filter :sanitize_print_param, only: [:profile]
  skip_before_filter :authenticate_user!, only: [:show, :profile, :contact]

  rescue_from Pundit::NotAuthorizedError, :with => :user_deleted

  def profile
    authorize @user
  end

  def show
    authorize @user
    @articles = ActiveUserArticles.new(@user).paginate(params[:active_articles_page])
  end

  def contact
    render layout: false
  end

  private

    def user_deleted
      render :user_deleted
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_for_complete_mass_uploads
      if user_signed_in?
        current_user.mass_uploads.processing.each do |mu|
          mu.finish
        end
      end
    end

    def sanitize_print_param
      if params[:print] && ['terms','cancellation'].include?(params[:print])
        @print = params[:print]
      end
    end

end
