#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UsersController < ApplicationController
  include NoticeHelper
  respond_to :html
  respond_to :js, if: lambda { request.xhr? }
  respond_to :pdf, only: :profile

  before_action :check_for_complete_mass_uploads, only: [:show]
  before_action :set_user
  before_action :dont_cache, only: [:show]
  before_action :sanitize_print_param, only: [:profile]
  skip_before_action :authenticate_user!, only: [:show, :profile, :contact]

  rescue_from Pundit::NotAuthorizedError, with: :user_deleted

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
    if params[:print] && %w(terms cancellation).include?(params[:print])
      @print = params[:print]
    end
  end
end
