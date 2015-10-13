#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

def setup_categories
  Category.find_or_create_by(name: "Fahrzeuge")
  electronic = Category.find_or_create_by(name: "Elektronik", weight: 100)
  Category.find_or_create_by(name: "Haus & Garten")
  Category.find_or_create_by(name: "Freizeit & Hobby", weight: 100)
  Category.find_or_create_by(name: "Sonstiges")
  computer = Category.find_or_create_by(name: "Computer", :parent_id => electronic.id)
  Category.find_or_create_by(name: "Audio & HiFi", :parent_id => electronic.id)
  Category.find_or_create_by(name: "Hardware", :parent_id => computer.id)
  Category.find_or_create_by(name: "Software", :parent_id => computer.id)
  Category.rebuild!
end
