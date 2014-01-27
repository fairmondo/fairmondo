class ErroneousArticle < ActiveRecord::Base
  belongs_to :mass_upload
  default_scope order('row_index ASC')
end
