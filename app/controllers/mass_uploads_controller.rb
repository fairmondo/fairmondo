#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MassUploadsController < ApplicationController
  PERMITTED_PARAMS = %i(file).freeze

  respond_to :html
  respond_to :csv, only: :show

  before_action :ensure_complete_profile, only: [:new, :create]
  before_action :set_mass_upload, only: [:show, :update, :restart]
  before_action :check_value_of_goods, only: [:update]

  def show
    authorize @mass_upload
    @erroneous_articles = @mass_upload.erroneous_articles.page(params[:erroneous_articles_page])

    respond_with @mass_upload do |format|
      format.csv do
        send_data ArticleExporter.export_erroneous_articles(@mass_upload.erroneous_articles),
                  filename: "Fairmondo_export_errors_#{Time.now.strftime('%Y-%d-%m %H:%M:%S')}.csv"
      end
    end
  end

  def new
    @mass_upload = current_user.mass_uploads.build
    authorize @mass_upload
    respond_with @mass_upload
  end

  def create
    @mass_upload = current_user.mass_uploads.build(params.require(:mass_upload).permit(*PERMITTED_PARAMS))
    authorize @mass_upload
    @mass_upload.process if @mass_upload.save
    respond_with @mass_upload, location: -> { user_path(@mass_upload.user, anchor: 'my_mass_uploads') }
  end

  def update
    authorize @mass_upload
    @mass_upload.mass_activate
    flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
    redirect_to user_path(@mass_upload.user)
  end

  def restart
    authorize @mass_upload
    ProcessMassUploadWorker.perform_async(@mass_upload.id)
    redirect_to user_path(@mass_upload.user, anchor: 'my_mass_uploads')
  end

  private

  def set_mass_upload
    @mass_upload = current_user.mass_uploads.find(params[:id])
  end
end
