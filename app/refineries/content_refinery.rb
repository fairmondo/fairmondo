class ContentRefinery < ApplicationRefinery

  def default
    [ :body, :key ]
  end

  def new
    [ :key ]
  end

end
