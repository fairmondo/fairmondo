#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Indexer
  def self.index_article article
    SearchIndexWorker.perform_async(:article, article.id)
  end

  def self.index_articles article_ids
    article_ids.each do |id|
      SearchIndexWorker.perform_async(:article, id)
    end
  end

  def self.index_mass_upload mass_upload_id
    activation_ids = MassUpload.find(mass_upload_id).articles_for_mass_activation.pluck(:id)
    Indexer.index_articles activation_ids
  end
end
