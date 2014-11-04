class Indexer

  def self.index_article article
   # indexing
    if article.active? && !article.template?
      SearchIndexWorker.perform_async(:article, article.id, :store)
    elsif !article.preview?
      SearchIndexWorker.perform_async(:article, article.id, :delete)
    end
  end

  def self.index_articles article_ids
    article_ids.each do |article_id|
      SearchIndexWorker.perform_async(:article, article_id, :store)
    end
  end

  def self.index_mass_upload mass_upload_id
    activation_ids = MassUpload.find(mass_upload_id).articles_for_mass_activation.pluck(:id)
    Indexer.index_articles activation_ids
  end

  def self.settings
    {
      index: {
        store: { type: Rails.env.test? ? :memory : :niofs }
      },
      analysis: {
        filter: {
          decomp:{
            type: "decompound"
          },
          german_stemming: {
            type: 'snowball',
            language: 'German2'
          },
          ngram_filter: {
            type: "ngram",
            min_gram: 2,
            max_gram: 20,
          }
        },
        analyzer: {
          decomp_stem_analyzer: {
            type: "custom",
            tokenizer: "letter",
            filter: [
                    'lowercase',
                    'decomp',
                    'german_stemming',
                    'asciifolding'
                    ]
          },
          decomp_analyzer: {
            type: "custom",
            tokenizer: "letter",
            filter: [
                    'lowercase',
                    'decomp',
                    'asciifolding'
                    ]
          }
        }
      }
    }
  end
end
