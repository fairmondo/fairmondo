#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# orig. source: https://github.com/plataformatec/devise/wiki/How-To:-Stub-authentication-in-controller-specs
module ControllerHelpers
  def sign_in user = double('user'), stub = true
    return super unless stub
    if user.nil?
      request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
      controller.stub :current_user => nil
    else
      request.env['warden'].stub :authenticate! => user
      controller.stub :current_user => user
      controller.stub :signed_in? => true
    end
  end
end
