#
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
module MassUploadsHelper
  def process_percentage_of mass_upload
    result = mass_upload.processed_articles_count.to_f / mass_upload.row_count.to_f * 100
    result = 0 unless result > 0 # Mainly transforms "NaN" => 0.0 / 0.0
    result = 100 if result >= 100 # Mainly transforms "Infinity" => 1.0 / 0.0
    return result
  end
end