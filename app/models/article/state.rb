#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::State
  extend ActiveSupport::Concern

  included do
    state_machine initial: :preview do
      state :preview do
        # Inactive and editable
      end

      state :active do
        # Searchable and buyable
      end

      state :locked do
        # Same as preview but not editable
      end

      state :closed do
        # Deleted
      end

      state :sold do
        # Sold
      end

      state :template do
        # Template
      end

      event :activate do
        transition [:preview, :locked] => :active
      end

      # Theoretical event, can't be performed over state-machine because people with validation issues can't do stuff anymore
      event :deactivate do
        transition active: :locked
      end

      event :close do
        transition locked: :closed
      end

      event :templatify do
        transition preview: :template
      end

      event :buy_out do
        transition active: :sold
      end
    end
  end

  def remove_from_libraries
    # delete the article from the collections
    self.library_elements.destroy_all
  end

  def deactivate_without_validation
    self.state = 'locked'
    ArticleObserver.instance.send('after_deactivate', self, nil)
    self.save(validate: false) # do it anyways
  end

  def close_without_validation
    self.state = 'closed'
    ArticleObserver.instance.send('after_close', self, nil)
    self.save(validate: false) # do it anyways
  end
end
