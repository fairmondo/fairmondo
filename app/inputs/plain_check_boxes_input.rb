# We cannot namespace them properly as formtastic's lookup chain would not find them
# see  lib/formtastic/helpers/input_helper.rb
#module Fairtastic
#  module Inputs
class PlainCheckBoxesInput < Formtastic::Inputs::CheckBoxesInput

  def render_label?
    false    
  end
  
  def wrapper_classes_raw
    super << " check_boxes"
  end

end
