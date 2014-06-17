# encoding: utf-8
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#


def setup_categories
  Category.find_or_create_by(name: "Fahrzeuge")
  electronic = Category.find_or_create_by(name: "Elektronik")
  Category.find_or_create_by(name: "Haus & Garten")
  Category.find_or_create_by(name: "Freizeit & Hobby")
  Category.find_or_create_by(name: "Sonstiges")
  computer = Category.find_or_create_by(name: "Computer", :parent_id => electronic.id)
  Category.find_or_create_by(name: "Audio & HiFi", :parent_id => electronic.id)
  Category.find_or_create_by(name: "Hardware", :parent_id => computer.id)
  Category.find_or_create_by(name: "Software", :parent_id => computer.id)
  Category.rebuild!
end


