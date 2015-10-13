#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbackPolicy < Struct.new(:user, :feedback)
  def new?
    true
  end

  def create?
    true
  end
end
