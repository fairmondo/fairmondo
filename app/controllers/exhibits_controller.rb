class ExhibitsController < InheritedResources::Base
  actions :create,:update
  custom_actions :collection => :create_multiple
  skip_after_filter :verify_authorized_with_exceptions, only: [:create_multiple]


  def create
    authorize build_resource
    create! do |format|
      format.html {redirect_to resource.article}
    end
  end


  def create_multiple
    if params[:queue] && params[:articles]

      queue = params[:queue]
      articles = params[:articles]

      articles.each do |id|
        a = Article.find id
        e = Exhibit.create({
          article_id: a.id ,
          queue: queue
        })
        e.save!
      end
    end
    redirect_to root_path
  end


  def update
    authorize resource
    update! do |format|
      format.html {redirect_to resource.article}
    end
  end

end
