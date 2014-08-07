# Non-ActiveRecord Placeholder
class Statistic
  def statistics_category_articles c
    a = Article.new(:categories => [c])
    articles = a.find_like_this(1)
    articles.total
  rescue
    0
  end

  def statistics_category_sales c
    BusinessTransaction.includes(article: [:categories]).where(categories: {id: c.id}).sold.count
  rescue
    0
  end

  def legal_entities_count
    LegalEntity.all.count
  end

  def legal_entity_articles_count
    Article.active.joins(:seller).where("users.type = ?", "LegalEntity").count
  end

  def private_users_count
    PrivateUser.all.count
  end

  def private_user_articles_count
    Article.active.joins(:seller).where("users.type = ?", "PrivateUser").count
  end

  def sum_article_prices
    Money.new(Article.active.sum(:price_cents))
  end

  def sum_article_prices_with_quantity
    Money.new(Article.active.sum("price_cents * quantity"))
  end

  def sum_article_fees
    Money.new(Article.active.sum(:calculated_fee_cents))
  end

  def sum_article_fees_with_quantity
    Money.new(Article.active.sum("calculated_fee_cents * quantity"))
  end

  def sum_fair_article_fees
    Money.new(Article.active.where(:fair => true).sum(:calculated_fee_cents))
  end

  def sum_fair_article_fees_with_quantity
    Money.new(Article.active.where(:fair => true).sum("calculated_fee_cents * quantity"))
  end

  def sum_conventional_article_fees
    Money.new(Article.active.where(:fair => false).sum(:calculated_fee_cents))
  end

  def sum_conventional_article_fees_with_quantity
    Money.new(Article.active.where(:fair => false).sum("calculated_fee_cents * quantity"))
  end

  def sum_donations
    Money.new(Article.active.sum(:calculated_fair_cents))
  end

  def sum_donations_with_quantity
    Money.new(Article.active.sum("calculated_fair_cents * quantity"))
  end

  def fair_article_percentage
    count_fair = Article.active.where(:fair => true).count
    count_total =  Article.active.count
    (count_fair*1.0 / (count_total==0 ? 1 : count_total))*100
  end

  def eco_article_percentage
    count_eco = Article.active.where(:ecologic => true).count
    count_total =  Article.active.count
    (count_eco*1.0 / (count_total==0 ? 1 : count_total))*100
  end

  def sold_articles_count
    BusinessTransaction.count
  end

  def sold_articles_count_with_quantity
    BusinessTransaction.sum(:quantity_bought)
  end

  def sum_sold_article_prices
    Money.new(BusinessTransaction.joins(:article).sum("articles.price_cents * business_transactions.quantity_bought"))
  end

  def sum_sold_article_fees
    Money.new(BusinessTransaction.joins(:article).sum("articles.calculated_fee_cents * business_transactions.quantity_bought"))
  end

  def sum_sold_article_donations
    Money.new(BusinessTransaction.joins(:article).sum("articles.calculated_fair_cents * business_transactions.quantity_bought"))
  end

  def sold_articles_count_last_week
    BusinessTransaction.last_week.count
  end

  def sold_articles_count_growth_rate
    growth_rate BusinessTransaction.last_week.count , BusinessTransaction.week_before_last_week.count
  end

  def sold_articles_count_with_quantity_last_week
    BusinessTransaction.last_week.sum(:quantity_bought)
  end

  def sold_articles_count_with_quantity_growth_rate
    growth_rate sold_articles_count_with_quantity_last_week ,  BusinessTransaction.week_before_last_week.sum(:quantity_bought)
  end

  def sold_article_prices_last_week
    Money.new(BusinessTransaction.last_week.joins(:article).sum("articles.price_cents * business_transactions.quantity_bought"))
  end

  def sold_article_prices_growth_rate
    growth_rate BusinessTransaction.last_week.joins(:article).sum("articles.price_cents * business_transactions.quantity_bought") , BusinessTransaction.week_before_last_week.joins(:article).sum("articles.price_cents * business_transactions.quantity_bought")
  end

  def sold_article_fees_last_week
    Money.new(BusinessTransaction.last_week.joins(:article).sum("articles.calculated_fee_cents * business_transactions.quantity_bought"))
  end

  def sold_article_fees_growth_rate
    growth_rate BusinessTransaction.last_week.joins(:article).sum("articles.calculated_fee_cents * business_transactions.quantity_bought"), BusinessTransaction.week_before_last_week.joins(:article).sum("articles.calculated_fee_cents * business_transactions.quantity_bought")
  end

  def sold_article_donations_last_week
    Money.new(BusinessTransaction.last_week.joins(:article).sum("articles.calculated_fair_cents * business_transactions.quantity_bought"))
  end

  def sold_article_donations_growth_rate
    growth_rate BusinessTransaction.last_week.joins(:article).sum("articles.calculated_fair_cents * business_transactions.quantity_bought"), BusinessTransaction.week_before_last_week.joins(:article).sum("articles.calculated_fair_cents * business_transactions.quantity_bought")
  end


  private

  def growth_rate last_week, week_before_last_week
    if week_before_last_week == 0
      "-"
    else
       ((last_week.to_f / week_before_last_week.to_f - 1) * 100).round(2)
    end
  end
end
