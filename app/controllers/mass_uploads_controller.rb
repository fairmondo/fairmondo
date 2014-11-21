class MassUploadsController < ApplicationController
  responders :location
  respond_to :html
  respond_to :csv, only: :show

  before_filter :ensure_complete_profile , :only => [:new, :create]
  before_filter :set_mass_upload, only: [:show, :update]
  before_filter :check_value_of_goods, :only => [:update]

  def show
    authorize @mass_upload
    @erroneous_articles = @mass_upload.erroneous_articles.page(params[:erroneous_articles_page])

    respond_with @mass_upload do |format|
      format.csv { send_data ArticleExporter.export_erroneous_articles(@mass_upload.erroneous_articles),
                   {filename: "Fairmondo_export_errors_#{Time.now.strftime("%Y-%d-%m %H:%M:%S")}.csv"} }
    end
  end

  def new
    @mass_upload = current_user.mass_uploads.build
    authorize @mass_upload
    respond_with @mass_upload
  end

  def create
    @mass_upload = current_user.mass_uploads.build(params.for(MassUpload).refine)
    authorize @mass_upload
    @mass_upload.process if @mass_upload.save
    respond_with @mass_upload, location: -> { user_path(@mass_upload.user, anchor: 'my_mass_uploads') }
  end

  def update
    authorize @mass_upload
    Indexer.delay.index_mass_upload @mass_upload.id
    @mass_upload.articles_for_mass_activation.update_all(state: 'active')
    send_emails_for @mass_upload
    flash[:notice] = I18n.t('article.notices.mass_upload_create_html').html_safe
    redirect_to user_path(@mass_upload.user)
  end

  private

    def set_mass_upload
      @mass_upload = current_user.mass_uploads.find(params[:id])
    end

    def send_emails_for mass_upload
      if mass_upload.articles_for_mass_activation.any?
        ArticleMailer.delay.mass_upload_activation_message(mass_upload.id)
      end
    end
end
