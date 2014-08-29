class ArticleSearchFormRefinery < ApplicationRefinery
  def root
    false
  end

  def default
    [
      {
      article_search_form: [
      :q, :fair, :ecologic, :small_and_precious, :condition,
      :category_id, :zip, :order_by, :search_in_content]
      },
      :page
    ]
  end
end
