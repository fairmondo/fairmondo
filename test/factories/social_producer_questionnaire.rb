#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :social_producer_questionnaire do
    nonprofit_association { true }
    nonprofit_association_checkboxes { [:art_and_culture] }
  end
end
