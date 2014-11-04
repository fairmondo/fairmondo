class Indexer

  def self.index_article article
    SearchIndexWorker.perform_async(:article, article.id)
  end

  def self.index_articles article_ids
    article_ids.each_slice(100) do |ids| #give it to redis in batches of 100 so that redis wont overflow
      SearchIndexWorker.perform_async(:article, ids)
    end
  end

  def self.index_mass_upload mass_upload_id
    activation_ids = MassUpload.find(mass_upload_id).articles_for_mass_activation.pluck(:id)
    Indexer.index_articles activation_ids
  end

end
