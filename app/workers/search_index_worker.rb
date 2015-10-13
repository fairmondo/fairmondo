#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class SearchIndexWorker
  include Sidekiq::Worker

  sidekiq_options queue: :indexing,
                  retry: 20, # this means approx 6 days
                  backtrace: true

  def perform type, ids
    type =  case type.to_sym
            when :article
              ArticlesIndex::Article
            end

    Chewy.atomic do
      type.import! ids, batch_size: 100
    end
  end
end
