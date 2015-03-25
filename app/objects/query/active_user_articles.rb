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
      result = ArticlesIndex.all.filter(term: {seller_id: @user.id}).page(page).per(per)
      result.to_a # this will make sure the request is send
      result
    rescue Faraday::ConnectionFailed
      user_articles_for_error_case page, per
    rescue Faraday::TimeoutError
      user_articles_for_error_case page, per
    rescue Faraday::ClientError
      user_articles_for_error_case page, per
    end

    def user_articles_for_error_case page, per
      @user.articles.includes(:images).where(state: 'active').page(page).per(per)
    end
end
