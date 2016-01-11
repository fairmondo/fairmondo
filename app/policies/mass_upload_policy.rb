#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MassUploadPolicy < Struct.new(:user, :mass_upload)
  def show?
    (mass_upload.finished? || mass_upload.activated?) && own?
  end

  def new?
    create?
  end

  def create?
    user.is_a? LegalEntity # TODO Use Article policy
  end

  def update?
    own? && create?
  end

  private

  def own?
    user.id == mass_upload.user.id
  end
end
