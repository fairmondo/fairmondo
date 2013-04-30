class AuctionTemplatesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  before_filter :build_resource, :only => [:new, :create]
  before_filter :build_auction
  before_filter :setup_categories, :except => [:destroy]
  before_filter :build_questionnaires, :except => [:destroy]
  before_filter :build_transaction, :only => [:create]
  before_filter :save_images, :only => [:create, :update]
  actions :all, :except => [:show,:index]
  
  def build_resource
    super
    authorize @auction_template
    @auction_template
  end
  
  
  def begin_of_association_chain
    current_user
  end
  
  def collection
    @auction_templates ||= end_of_association_chain.paginate(:page => params[:page])
  end
    
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
    user_path(current_user, :anchor => "my_auction_templates")
  end
  
  def build_auction
    @auction ||= resource.auction || resource.build_auction 
  end
 
  def build_questionnaires
    @fair_trust_questionnaire ||= @auction.fair_trust_questionnaire || @auction.build_fair_trust_questionnaire
    @social_producer_questionnaire ||= @auction.social_producer_questionnaire || @auction.build_social_producer_questionnaire
  end
  
  def build_transaction
    @auction.build_transaction
  end
  
  def save_images
    #At least try to save the images -> not persisted in browser 
    if @auction 
       
        @auction.images.each do |image|
          if image.image
            image.save
          else
            @auction.images.remove image
          end
        end
    end
  end
  
end
