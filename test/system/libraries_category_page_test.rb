#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class LibrariesCategoryPageTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    @library = create(:library, :public, user: @user)

    @category = create :category
    @category_child = create(:category, parent: @category)
    @category_grandchild = create(
      :category, parent: @category_child)
  end

  test 'library is shown on category page unless owner is logged in' do
    articles = []
    3.times do
      articles.push create(
        :article, seller: @user, categories: [@category])
    end

    articles.each do |article|
      create(:library_element, library: @library, article: article)
    end

    visit category_path(@category)
    assert page.has_content?(@library.name)

    sign_in @user
    visit category_path(@category)
    page.wont_have_content(@library.name)
  end

  test 'library is shown on parent category page' do
    articles = []
      .push(create(
              :article, seller: @user, categories: [@category]))
      .push(create(
              :article, seller: @user, categories: [@category_child]))
      .push(create(
              :article, seller: @user, categories: [@category_grandchild]))

    articles.each do |article|
      create(:library_element, library: @library, article: article)
    end

    visit category_path(@category)
    assert page.has_content?(@library.name)
  end
end
