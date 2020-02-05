#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :feedback do
    text do
      'That was a memorable day to me, for it made great changes in me. But it is the same '\
      'with any life. Imagine one selected day struck out of it, and think how different its '\
      'course would have been. Pause you who read this, and think for a moment of the long chain '\
      'of iron or gold, of thorns or flowers, that would never have bound you, but for the '\
      'formation of the first link on one memorable day.'
    end
    variety { :report_article }
  end
end
