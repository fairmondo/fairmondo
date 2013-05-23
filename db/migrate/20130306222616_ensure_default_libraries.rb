class EnsureDefaultLibraries < ActiveRecord::Migration
  class User < ActiveRecord::Base
    has_many :libraries
    def create_default_library
      if self.libraries.empty?
        # Library.create(:name => I18n.t('library.default'),:public => false, :user_id => self.id) uncommented because its dirty and it was already run on server
      end
    end
  end
  class Library < ActiveRecord::Base
    belongs_to :user
    attr_accessible :name
  end
  def up
    User.reset_column_information
    Library.reset_column_information
    User.all.each do |user|
      user.create_default_library
    end
  end

  def down
    #not needed ... cant harm
  end
end
