class Settings < RailsSettings::CachedSettings
  def self.setting_attrs
    [:var, :value]
  end
  #! attr_accessible *settings_attributes
  #! attr_accessible *settings_attributes, :as => :admin
end
