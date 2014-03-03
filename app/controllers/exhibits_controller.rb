class ExhibitsController < InheritedResources::Base

  actions :create,:update, :destroy
  custom_actions :collection => :create_multiple
  #skip_after_filter :verify_authorized_with_exceptions, only: [:create_multiple]

  def create
    authorize build_resource
    create! do |format|
      format.html {redirect_to resource.article}
    end
  end

  def create_multiple
    authorize build_resource
    if params[:exhibit][:queue] && params[:exhibit][:articles]

      queue = params[:exhibit][:queue]
      articles = params[:exhibit][:articles]

      articles.each do |id|
        if id.present?
          a = Article.find id
          e = Exhibit.create({
            article_id: a.id ,
            queue: queue
          })
          e.save!
        end
      end
    end
    redirect_to root_path
  end

  def update
    authorize resource
    update! do |format|
      format.html { redirect_to resource.article }
    end
  end

  def destroy
    authorize resource
     destroy! do |format|
       format.html { redirect_to root_path }
     end
  end

end
