class CategoryRefinery < ApplicationRefinery

  # def default
  #   [ :name, :parent, :desc, :parent_id ]
  # end

  def show #search
    [ :page, article_search_form: SearchRefinery.new(nil, user).default ]
  end
end
