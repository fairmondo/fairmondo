module UsersHelper
  def user_resource
    @user
  end

  def active_articles
    resource.articles.where(:active => true).paginate :page => params[:active_articles_page]
  end

  def inactive_articles
    resource.articles.where(:active => false).paginate :page => params[:inactive_articles_page]
  end
end
