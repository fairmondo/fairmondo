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
class UsersController < ApplicationController
  include NoticeHelper
  respond_to :html
  respond_to :pdf, only: :profile

  before_filter :check_for_complete_mass_uploads, only: [:show]
  before_filter :show_notice, only: [:show]
  before_filter :set_user
  before_filter :dont_cache, only: [:show]
  skip_before_filter :authenticate_user!, only: [:show, :profile]

  def profile
    authorize @user
  end

  def show
    authorize @user
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def show_notice
      if user_signed_in?
        notice = current_user.next_notice
        flash[notice.color] = render_open_notice notice if notice.present?
      end
    end

    def check_for_complete_mass_uploads
      if user_signed_in?
        current_user.mass_uploads.where(:state => :processing).each do |mu|
          mu.finish
        end
      end
    end

end
