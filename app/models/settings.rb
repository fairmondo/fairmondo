class Settings < RailsSettings::CachedSettings
  attr_accessible :var
  extend AccessibleForAdmins
end
