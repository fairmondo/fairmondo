# encoding: UTF-8
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class MassUploadsFinishWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_uploads_finish,
                  retry: 20,
                  backtrace: true

  include Sidetiq::Schedulable

  recurrence {
    hourly.minute_of_hour(*((0..5).to_a.map{|d|d*10}))
  }

  def perform
    MassUpload.processing.each do |mass_upload|
      mass_upload.finish
    end
  end
end
