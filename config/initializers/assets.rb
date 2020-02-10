# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


# Compile assets that are not required in the application.js
Rails.application.config.assets.precompile += %w(models/article/unactivated_article_warning.js inputs/bank_details.js inputs/newsletter_status.js session_expire.js)
