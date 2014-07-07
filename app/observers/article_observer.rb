# See http://rails-bestpractices.com/posts/19-use-observer
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#

class ArticleObserver < ActiveRecord::Observer
  # ATTENTION !!!
  # The MassUploader Model won't trigger the after_save callback on article activation.
  # If you write callbacks that need to be triggered on a mass upload as well
  # make sure to trigger them manually there

  def after_save(article)

    # derive a template
    if article.save_as_template?

      cloned_article = article.amoeba_dup #duplicate the article
      cloned_article.save_as_template = "0" #no loops
      article.update_column(:template_name, nil)
      cloned_article.templatify
      cloned_article.save #save the cloned article
    end

    # Send a Category Proposal
    if article.category_proposal.present?
      ArticleMailer.category_proposal(article.category_proposal).deliver
    end

    Indexer.index_article article
  end

  def before_activate(article, transition)
    article.calculate_fees_and_donations
  end

  # before_deactivate and before_close will only work on state_changes
  # without validation when you implement it in article/state.rb

  def after_deactivate(article, transition)
     article.remove_from_libraries
  end

  def after_close(article, transition)
    article.remove_from_libraries
    article.cleanup_images
  end

end
