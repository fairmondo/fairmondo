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
  Category.find_or_create_by_name("Fahrzeuge")
  electronic = Category.find_or_create_by_name("Elektronik")
  Category.find_or_create_by_name("Haus & Garten")
  Category.find_or_create_by_name("Freizeit & Hobby")
  Category.find_or_create_by_name("Sonstiges")
  computer = Category.find_or_create_by_name("Computer", :parent => electronic)
  Category.find_or_create_by_name("Audio & HiFi", :parent => electronic)
  Category.find_or_create_by_name("Hardware", :parent => computer)
  Category.find_or_create_by_name("Software", :parent => computer)
  Category.rebuild!
end


