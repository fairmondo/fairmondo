module ActiveAdmin::ViewHelper
  def get_production_log
    begin 
      data = File.read(File.join(Rails.root,"log","production.log"))
      data 
    rescue
      "Problem reading production log data!"
    end
  end
end