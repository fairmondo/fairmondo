# Rails Admin seems to need all fields to be accessible, but doing a rake db:setup will fail without the rescue block since the database isn't there yet. This is a helper module to DRYly implement this functionality.
module AccessibleForAdmins
  begin
    attr_accessible *column_names, as: :admin
  rescue
  end
end
