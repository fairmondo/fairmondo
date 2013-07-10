class Settings < RailsSettings::CachedSettings
  attr_accessible :var
  attr_accessible(*column_names , :as => :admin)
end
