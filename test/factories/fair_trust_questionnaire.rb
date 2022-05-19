#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :fair_trust_questionnaire do
    support { true }
    support_checkboxes { [:prefinance, :minimum_wage, :direct_negotiations] }
    support_explanation do
      'Pip, dear old chap. life is made of ever many partings welded together, '\
      'as I may say, and one man\'s a blacksmith and one\'s a whitesmith, one\'s a goldsmith, and '\
      'one\'s a coppersmith. Diwisions among such must come, and must be met as they come.'
    end

    labor_conditions { true }
    labor_conditions_checkboxes do
      [:secure_environment, :working_hours, :sexual_equality, :child_labor_ban]
    end

    labor_conditions_explanation do
      'I loved her simply because I found her irresistible. Once for '\
      'all: I knew to my sorrow, often and often, if not always, that I loved her against reason, '\
      'against promise, against peace, against hope,against happiness, against all discouragement '\
      'that could be.'
    end

    controlling { true }
    controlling_checkboxes { [:transparent_supply_chain, :inspectors] }
    controlling_explanation do
      'May I ask you if you have ever had an opportunity of remarking, '\
      'down in your part of the country, that the children of not exactly suitable marriages are '\
      'always most particularly anxious to be married?'
    end
  end
end
