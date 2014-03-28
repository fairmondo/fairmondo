class FairAlternative

  def self.find_for article
    search = Article.search do
      query do
        boolean do
          must { match "title.search", article.title, fuzziness: 0.8}
          must do
            boolean :minimum_number_should_match => 1 do
              should { term :fair, true, boost: 10.0  }
              should { term :ecologic, true, boost: 5.0 }
              should { term :condition, "old", boost: 1.0 }
            end
          end
        end
      end
      filter :terms, :categories => FairAlternative.without_other_category(article.categories)
      size 1
    end
    alternative = search.first

    if rate_article(article) < rate_article(alternative)
      return alternative
    else
      return nil

    end
  rescue # Rescue all Errors by not showing an alternative
    return nil
  end


  # Only allow categories that are not "Other"
  def self.without_other_category(categories)
    ids = categories.map(&:id)
    other = Category.other_category.first
    ids.map! { |id| id == other.id ? 0 : id} if other  #set the other category to 0 because solr throws exceptions if categories are empty
    ids
  end


  private

    # Rating to not have worse alternatives than the article
    def self.rate_article article
      if article == nil
        return 0
      end
      if article.fair
        return 3
      end
      if article.ecologic
        return 2
      end
      if article.condition == "old"
        return 1
      end
      return 0
    end

end
