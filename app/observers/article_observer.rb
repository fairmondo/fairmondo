# See http://rails-bestpractices.com/posts/19-use-observer
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#

class ArticleObserver < ActiveRecord::Observer
  # ATTENTION !!!
  # The MassUploader Model won't trigger the after_save callback on article activation.
  # If you write callbacks that need to be triggered on a mass upload as well
  # make sure to trigger them manually there

  def before_save(article)
    article.quantity_available = article.quantity if article.quantity_changed?
  end

  def after_save(article)
    # derive a template
    if article.save_as_template?
      cloned_article = article.amoeba_dup # duplicate the article
      cloned_article.save_as_template = '0' # no loops
      article.update_column(:article_template_name, nil)
      cloned_article.templatify
      cloned_article.save # save the cloned article
    end

    if article.state_changed? && article.sold?
      Indexer.index_article article
    end
  end

  def before_activate(article, _transition)
    article.changing_state = true
    article.calculate_fees_and_donations
  end

  def after_activate(article, _transition)
    article.library_elements.update_all(inactive: false)
    ArticleMailer.delay.article_activation_message(article.id)
    Indexer.index_article article
  end

  # before_deactivate and before_close will only work on state_changes
  # without validation when you implement it in article/state.rb

  def after_deactivate(article, _transition)
    article.library_elements.update_all(inactive: true)
    Indexer.index_article article
  end

  def before_create(article)
    put_discount_for article

    if original_article = article.original # handle saving of an edit_as_new clone
      # move slug to new article
      old_slug = original_article.slug
      original_article.update_column :slug, (old_slug + original_article.id.to_s)
      article.slug = old_slug
    end
  end

  def after_create article
    if original_article = article.original # handle saving of an edit_as_new clone
      # move comments to new article
      original_article.comments.find_each do |comment|
        comment.update_column :commentable_id, article.id
      end

      original_article.library_elements.update_all(article_id: article.id, inactive: false)

      # do not remove sold articles, we want to keep them
      # if the old article has errors we still want to remove it from the marketplace
      original_article.close_without_validation

      # the original has been handled. now unset the reference (for policy)
      article.update_column :original_id, nil
    end
  end

  def after_close(article, _transition)
    article.remove_from_libraries
    article.cleanup_images unless article.business_transactions.any?
    Indexer.index_article article
  end

  private

  def put_discount_for article
    article.discount_id = Discount.current.last.id if article.qualifies_for_discount?
  end
end
