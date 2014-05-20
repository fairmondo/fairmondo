class ActiveUserArticles

  def initialize user
    @user = user;
  end

  def paginate page
    finder page, Kaminari.config.default_per_page
  end

  def find_some
    finder 1,10
  end

  private
    def finder page, per
      articles = Article.search(:page => page,:per_page => per) do
        query { all }
        filter :term, :seller => @user.id
      end
    rescue
      @user.articles.includes(:images).where(:state => 'active').page(page).per(per)
    end
    
end