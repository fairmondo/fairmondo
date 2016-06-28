#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class TestSidekiqWorker
  include Sidekiq::Worker

  def perform(arg)
    a = arg
    sleep(0.01)
  end
end
