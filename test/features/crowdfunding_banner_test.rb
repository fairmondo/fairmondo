#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

feature 'crowdfunding campaign banner' do
  scenario 'User visits the campaign banner on any page' do
    article = create :article

    visit root_path
    assert page.has_selector?('.l-crowdfunding-summary')
    assert page.has_selector?('.l-crowdfunding-full')

    visit article_path(article)
    assert page.has_selector?('.l-crowdfunding-summary')
    assert page.has_selector?('.l-crowdfunding-full')
  end

  scenario 'current amount is extracted from CMS' do
    create :content, key: 'crowdfunding_amount', body: '<p>50000</p>'
    visit root_path
    assert page.has_content?('50.000 €')
  end
end
