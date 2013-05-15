class WelcomeController < ApplicationController

  before_filter :build_login
  def index
    @articles = Article.count
    @percentage = (@articles.to_f/10000.0)*100.0
  end

end
