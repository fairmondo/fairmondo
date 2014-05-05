class ContentRefinery < ApplicationRefinery

  def default
    [ :body, :key ]
  end

  def new
    [ :key ]
  end

  def show
    [ :id ]
  end
end
