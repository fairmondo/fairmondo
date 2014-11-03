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
      ArticlesIndex::Article.filter(term: {seller_id: @user.id}).page(page).per(per).to_a
    rescue Faraday::ConnectionFailed
      @user.articles.includes(:images).where(state: 'active').page(page).per(per)
    end

end
