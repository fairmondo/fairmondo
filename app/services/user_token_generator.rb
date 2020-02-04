#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserTokenGenerator
  def self.generate(user_agent, remote_addr)
    Digest::SHA2.hexdigest([user_agent, remote_addr].join)
  end
end
