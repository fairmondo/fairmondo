class ImageRefinery < ApplicationRefinery
  def default nested_attrs = false
    output = [ :image, :is_title ]
    output.push(:_destroy, :id) if nested_attrs
    output
  end
end