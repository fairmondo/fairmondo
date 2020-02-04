#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleObserver < ActiveRecord::Observer
  # ATTENTION !!!
  # The MassUploader Model won't trigger the after_save callback on article activation.
  # If you write callbacks that need to be triggered on a mass upload as well
  # make sure to trigger them manually there

  def before_save(article)
    article.quantity_available = article.quantity if article.quantity_changed?

    if article.state_changed? && article.sold?
      Indexer.index_article article
    end
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
  end

  def before_activate(article, _transition)
    article.changing_state = true
    article.calculate_fees_and_donations
  end

  def after_activate(article, _transition)
    article.library_elements.update_all(inactive: false)
    ArticleMailer.article_activation_message(article.id).deliver_later
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
