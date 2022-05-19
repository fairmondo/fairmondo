#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :mass_upload do
    state { :pending }
    file { fixture_file_upload('test/fixtures/mass_upload_correct.csv', 'text/csv') }
    association :user, factory: :legal_entity

    factory :mass_upload_to_finish do
      state { :processing }
      row_count { 0 }
    end
  end
end
