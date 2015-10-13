#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

if Rails.env.development?
  Dir.entries("#{Rails.root}/app/models/users").each do |c|
    require_dependency File.join("app","models", "users", "#{c}") if c =~ /.rb$/
  end
  Dir.entries("#{Rails.root}/app/models/images").each do |c|
    require_dependency File.join("app","models", "images", "#{c}") if c =~ /.rb$/
  end
  ActionDispatch::Reloader.to_prepare do
    Dir.entries("#{Rails.root}/app/models/users").each do |c|
      require_dependency File.join("app","models", "users", "#{c}") if c =~ /.rb$/
    end
    Dir.entries("#{Rails.root}/app/models/images").each do |c|
      require_dependency File.join("app","models", "images", "#{c}") if c =~ /.rb$/
    end
  end
end


