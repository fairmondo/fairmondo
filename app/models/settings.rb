class Settings < RailsSettings::CachedSettings
  def self.settings_attrs
    [:var]
  end
  #! attr_accessible *settings_attributes
  #! attr_accessible *settings_attributes, :as => :admin
end
