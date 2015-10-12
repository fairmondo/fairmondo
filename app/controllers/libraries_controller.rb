#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibrariesController < ApplicationController
  include LibrariesControllerAdminActions

  helper_method :user_focused?

  respond_to :html

  before_action :set_user, if: :user_focused?, only: :index
  before_action :set_library, only: [:show, :update, :destroy, :admin_audit]
  before_action :set_exhibition, only: :admin_add

  # Authorization
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # Build empty Library object if user creates a new library
    @library = @user.libraries.build if signed_in_user_with_focus?

    if signed_in_or_not_favorite?
      @libraries = LibraryPolicy::Scope.new(current_user, @user, focus.includes(user: :image))
        .resolve
        .page(params[:page])
        .per(12)
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    authorize @library

    @library_elements = @library.library_elements.active
      .preload(article_reduced: [:title_image, :seller])
      .page(params[:library_page])
      .per(24)

    # random() should work with PostgreSQL and SQLite
    @user_libraries = @library.user.libraries.not_empty.published
      .where('id != ?', @library.id)
      .reorder('random()')
      .limit(2)

    respond_with @library do |format|
      format.js
    end
  end

  def create
    @library = current_user.libraries.build(params.for(Library).refine)
    authorize @library

    respond_with @library do |format|
      create_response_for format
    end
  end

  def update
    authorize @library
    if @library.update(params.for(@library).refine)
      redirect_to library_path(@library)
    else
      redirect_to library_path(@library), alert: @library.errors.values.first.first
    end
  end

  def destroy
    authorize @library
    @library.destroy
    redirect_to user_libraries_path(current_user)
  end

  private

  def set_library
    @library = Library.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_focused?
    params.key?(:user_id)
  end

  def focus
    case
    when user_focused?
      @user.libraries
    when index_mode == 'trending'
      Library.trending
    when index_mode == 'myfavorite'
      current_user.hearted_libraries.reorder('hearts.created_at DESC')
    when index_mode == 'new'
      Library.reorder(created_at: :desc)
    end
  end

  # Configure the libraries collection that is displayed
  def index_mode
    @mode ||= params[:mode] || 'new'
  end

  def signed_in_user_with_focus?
    user_signed_in? && user_focused?
  end

  def signed_in_or_not_favorite?
    user_signed_in? || index_mode != 'myfavorite'
  end

  def create_response_for format
    # Both .js responses are only for the articles view!
    if @library.save
      format.html { redirect_to user_libraries_path(current_user, anchor: "library#{@library.id}") }
      format.js
    else
      format.html { redirect_to user_libraries_path(current_user), alert: @library.errors.values.first.first }
      format.js { render :new }
    end
  end
end
