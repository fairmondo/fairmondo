class ArticleTemplatesController < InheritedResources::Base

  before_filter :authenticate_user!
  before_filter :build_resource, :only => [:new, :create]
  before_filter :build_article
  before_filter :setup_categories, :except => [:destroy]
  before_filter :build_questionnaires, :except => [:destroy]
  before_filter :build_transaction, :only => [:create]
  before_filter :save_images, :only => [:create, :update]
  actions :all, :except => [:show,:index]

  def build_resource
    super
    authorize @article_template
    @article_template
  end


  def begin_of_association_chain
    current_user
  end

  # def collection
  #   @article_templates ||= end_of_association_chain.paginate(:page => params[:page])
  # end

  def update
    update! {collection_url}
  end

  def create
    create! {collection_url}
  end

  def destroy
    destroy! {collection_url}
  end

  private

  def collection_url
    user_path(current_user, :anchor => "my_article_templates")
  end

  def build_article
    @article ||= resource.article || resource.build_article
  end

  def build_questionnaires
    @fair_trust_questionnaire ||= @article.fair_trust_questionnaire || @article.build_fair_trust_questionnaire
    @social_producer_questionnaire ||= @article.social_producer_questionnaire || @article.build_social_producer_questionnaire
  end

  def build_transaction
    @article.build_transaction
  end

  def save_images
    #At least try to save the images -> not persisted in browser
    if @article
      @article.images.each do |image|
        ## I tried for hours but couldn't figure out a way to write a test that transmit a wrong image.
        ## If the image removal is ever needed, comment it back in. ArticlesController doesn't use it either. -KK
        # if image.image
          image.save
        # else
        #   @article.images.remove image
        # end
      end
    end
  end

end
