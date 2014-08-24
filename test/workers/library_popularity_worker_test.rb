require_relative '../test_helper'

describe LibraryPopularityWorker do
  it "should calculate library popularity correctly" do
    #setup
    worker = LibraryPopularityWorker.new
    library = FactoryGirl.create(:library)
    user = FactoryGirl.create(:user)

    # first test: library with no comments or hearts should have popularity of 0.0
    assert_equal 0, worker.popularity_for(library), 'new library'

    # second test: create several hearts and comments
    # nineteen hearts with an age of 4 days, popularity = 19 x 1 -> 19
    # six hearts with an age of 0 days, popularity = 6 x 2 -> 12
    # seven comments with an age of 4 days, popularity = 7 x 5 -> 35
    # three comments with an age of 0 days, popularity = 3 x 10 -> 30
    # in sum: 96
    # library is younger than 3 days, so popularity = 96 * 10 -> 960
    19.times do |n|
      heart = library.hearts.build(user_token: "token-old-heart#{n}")
      heart.updated_at = 4.days.ago
      heart.save
    end
    6.times do |n|
      library.hearts.build(user_token: "token-new-heart#{n}").save
    end
    7.times do
      comment = library.comments.build(user_id: user.id, text: 'comment text')
      comment.updated_at = 4.days.ago
      comment.save
    end
    3.times do
      library.comments.build(user_id: user.id, text: 'comment text').save
    end
    assert_equal 960, worker.popularity_for(library), 'library with hearts and comments'

    # third test: set different updated_at values for the library
    # younger than 3 days: factor 10
    # between 3 and 7 days: factor 2
    # older than 7 days: factor 1
    library.updated_at = 4.days.ago
    assert_equal 192, worker.popularity_for(library), 'library updated 4 days ago'
    library.updated_at = 6.days.ago
    assert_equal 192, worker.popularity_for(library), 'library updated 6 days ago'
    library.updated_at = 8.days.ago
    assert_equal 96, worker.popularity_for(library), 'library updated 8 days ago'
  end
end
