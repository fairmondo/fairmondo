class Indexer

  def self.index_article article
   # indexing
    if article.active? && !article.template?
      SearchIndexWorker.perform_async(:article,article.id,:store)
    else
      SearchIndexWorker.perform_async(:article,article.id,:delete) unless article.preview?
    end
  end

  def self.index_articles article_ids
    articles = Article.find article_ids
    Article.index.import articles
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