#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ArticleControllerFilters
  extend ActiveSupport::Concern

  included do
    before_action :set_article, only: [:edit, :update, :destroy, :show]

    # Authorization
    skip_before_action :authenticate_user!,
                       only: [:show, :index, :new, :autocomplete]
    before_action :seller_sign_in, only: :new
    skip_after_filter :verify_authorized_with_exceptions, only: [:autocomplete]

    # Layout Requirements
    before_action :ensure_complete_profile, only: [:new, :create]

    # search_cache
    before_action :build_search_cache, only: :index
    before_action :category_specific_search,
                  only: :index,
                  unless: -> { request.xhr? || request.format == :json }

    # Calculate value of active goods
    before_action :check_value_of_goods, only: [:update],
                                         if: :activate_params_present?

    # Calculate fees and donations
    before_action :calculate_fees_and_donations,
                  only: :show,
                  if: -> { !@article.active? && policy(@article).activate? }

    # Flash image processing message
    before_action :flash_image_processing_message,
                  only: :show,
                  if: :show_image_processing_message?

    private

    def show_image_processing_message?
      !flash.now[:notice] &&
        @article.owned_by?(current_user) &&
        at_least_one_image_processing?
    end
  end
end
