#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

Rails.application.config.assets.precompile += %w( email/email.css )

Rails.application.config.assets.precompile += %w( inputs/bank_details.js )
Rails.application.config.assets.precompile += %w( models/article/unactivated_article_warning.js )
