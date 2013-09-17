class Settings < RailsSettings::CachedSettings
  settings_attributes = [:var]
  attr_accessible *settings_attributes
  attr_accessible *settings_attributes, :as => :admin
end
