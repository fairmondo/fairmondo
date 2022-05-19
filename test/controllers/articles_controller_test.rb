#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  let(:user) { create(:user) }

  describe '#index' do
    describe 'searching' do
      setup do
        ArticlesIndex.reset!
        @vehicle_category = Category.find_by_name!('Fahrzeuge')
        @hardware_category = Category.find_by_name!('Hardware')
        @electronic_category = Category.find_by_name!('Elektronik')
        @software_category = Category.find_by_name!('Software')

        @normal_article = create :article, :index_article,
                                 price_cents: 1, title: 'noraml article thing',
                                 content: 'super thing', created_at: 4.days.ago, id: 1234
        @second_hand_article = create :second_hand_article, :index_article,
                                      price_cents: 2, title: 'muscheln',
                                      categories: [@vehicle_category], content: 'muscheln am meer',
                                      created_at: 3.days.ago, id: 1235
        @hardware_article = create :second_hand_article, :index_article, :simple_fair,
                                   :simple_ecologic, :simple_small_and_precious, :with_ngo,
                                   price_cents: 3, title: 'muscheln 2',
                                   categories: [@hardware_category], content: 'abc',
                                   created_at: 2.days.ago, id: 1236
        @no_second_hand_article = create :no_second_hand_article, :index_article,
                                         price_cents: 4, title: 'muscheln 3',
                                         categories: [@hardware_category], content: 'cde', id: 1237,
                                         created_at: 1.day.ago
      end

      it 'should work with all filters' do
        # should find the article with title 'muscheln' when searching for muscheln
        get :index, params: { article_search_form: { q: 'muscheln' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@second_hand_article, @hardware_article, @no_second_hand_article].map(&:id).sort

        # should find the article with title 'muscheln' when searching for muschel
        get :index, params: { article_search_form: { q: 'muschel' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@second_hand_article, @hardware_article, @no_second_hand_article].map(&:id).sort

        # should find the article with content 'meer' when searching for meer
        get :index, params: { article_search_form: { q: 'meer', search_in_content: '1' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@second_hand_article].map(&:id).sort

        # should find the article with price 1 when filtering <= 1
        get :index, params: { article_search_form: { price_to: '0,01' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@normal_article].map(&:id).sort

        # should find the article with price 4 when filtering >= 4
        get :index, params: { article_search_form: { price_from: '0,04' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@no_second_hand_article].map(&:id).sort

        # should find the article with price 2 and 3 when filtering >= 2 <= 3
        get :index, params: { article_search_form: { price_to: '0,03', price_from: '0,02' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.sort.must_equal [@second_hand_article, @hardware_article].map(&:id).sort

        # order by price asc
        get :index, params: { article_search_form: { order_by: 'cheapest' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.must_equal [@normal_article, @second_hand_article, @hardware_article, @no_second_hand_article].map(&:id)

        # order by newest
        get :index, params: { article_search_form: { order_by: 'newest' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.must_equal [@no_second_hand_article, @hardware_article, @second_hand_article, @normal_article].map(&:id)

        # order by condition old
        get :index, params: { article_search_form: { order_by: 'old', q: 'muscheln' } }
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.last.must_equal @no_second_hand_article.id
        result.size.must_equal 3

        # order by condition new"
        get :index, params: { article_search_form: { order_by: 'new', q: 'muscheln' } }
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.first.must_equal @no_second_hand_article.id
        result.size.must_equal 3

        # order by fair
        get :index, params: { article_search_form: { order_by: 'fair' } }
        @controller.instance_variable_get(:@articles)
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.first.must_equal @hardware_article.id
        result.size.must_equal 4

        # order by ecologic
        get :index, params: { article_search_form: { order_by: 'ecologic' } }
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.first.must_equal @hardware_article.id
        result.size.must_equal 4

        # order by small_and_precious
        get :index, params: { article_search_form: { order_by: 'small_and_precious' } }
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.first.must_equal @hardware_article.id
        result.size.must_equal 4

        # order by price desc
        get :index, params: { article_search_form: { order_by: 'most_expensive' } }
        @controller.instance_variable_get(:@articles).map { |a| a.id.to_i }.must_equal [@normal_article, @second_hand_article, @hardware_article, @no_second_hand_article].reverse.map(&:id)

        # order by friendly_percent desc
        get :index, params: { article_search_form: { order_by: 'most_donated' } }
        result = @controller.instance_variable_get(:@articles)
        result.map { |a| a.id.to_i }.first.must_equal @hardware_article.id
        result.size.must_equal 4

        get :index, params: { article_search_form: { category_id: @hardware_category.id } }
        assert_redirected_to(category_path(@hardware_category.id))
      end

      it 'for string with no suggestions must return empty array' do
        get :index, params: { article_search_form: { q: '@#$!' } }
        @controller.instance_variable_get(:@articles).must_equal []
      end

      # wegreen search term
      describe '#wegreen_search_term' do
        it 'should return query string' do
          article_search_form = ArticleSearchForm.new q: 'cantfindme'
          article_search_form.wegreen_search_string.must_equal 'cantfindme'
        end

        it 'should return category name' do
          article_search_form = ArticleSearchForm.new(category_id: @vehicle_category.id)
          article_search_form.wegreen_search_string.must_equal @vehicle_category.name
        end

        it 'should return category name' do
          article_search_form = ArticleSearchForm.new()
          article_search_form.wegreen_search_string.must_be_nil
        end
      end
    end

    describe 'for signed-out users' do
      it 'should be successful' do
        get :index
        assert_response :success
      end

      it 'should render the :index view' do
        get :index
        assert_template(:index)
      end
    end

    describe 'for signed-in users' do
      before :each do
        @article = create :article
        sign_in user
      end

      it 'should be successful' do
        get :index
        assert_template(:index)
      end
    end
  end

  describe '#show' do
    let(:article) { create(:article, seller: user) }
    describe 'for all users' do
      it 'should be successful' do
        article_fair_trust = create :fair_trust
        get :show, params: { id: article_fair_trust }
        assert_response :success
      end

      it 'should be successful' do
        article_social_production = create :social_production
        get :show, params: { id: article_social_production }
        assert_response :success
      end

      it 'should be successful' do
        get :show, params: { id: article }
        assert_response :success
      end

      it 'should render the :show view' do
        get :show, params: { id: article }
        assert_template :show
      end

      it 'should render 404 on closed article' do
        article.deactivate
        article.close
        get :show, params: { id: article.id }
        assert_template :article_closed
      end

      it "doesn't throw an error when the search for other users articles breaks" do
        Chewy::Query.any_instance.stubs(:to_a).raises(StandardError.new('test')) # simulate connection error so that we dont have to use elastic
        get :show, params: { id: article.id }
        assert_template :show
      end

      it "doesn't throw an error when the search for other users articles breaks" do
        Chewy::Query.any_instance.stubs(:to_a).raises(Faraday::ConnectionFailed.new('test')) # simulate connection error so that we dont have to use elastic
        get :show, params: { id: article.id }
        assert_template :show
      end

      it "doesn't throw an error when the search for other users articles breaks" do
        Chewy::Query.any_instance.stubs(:to_a).raises(Faraday::TimeoutError.new('test')) # simulate connection error so that we dont have to use elastic
        get :show, params: { id: article.id }
        assert_template :show
      end

      it "doesn't throw an error when the search for other users articles breaks" do
        Chewy::Query.any_instance.stubs(:to_a).raises(Faraday::ClientError.new('test')) # simulate connection error so that we dont have to use elastic
        get :show, params: { id: article.id }
        assert_template :show
      end

      it 'should render 404 on closed article' do
        slug = article.slug
        article.deactivate
        article.close
        get :show, params: { id: slug }
        assert_template :article_closed
      end
    end

    describe 'for signed-in users' do
      before do
        sign_in user
      end

      it 'should be successful' do
        get :show, params: { id: article }
        assert_response :success
      end

      it 'should render the :show view' do
        get :show, params: { id: article }
        assert_template :show
      end

      it 'should render a flash message for the owner when it still has a processing image' do
        @controller.expects(:at_least_one_image_processing?).returns true
        get :show, params: { id: article }
        flash.now[:notice].must_equal I18n.t('article.notices.image_processing')
      end
    end
  end

  describe '#new' do
    describe 'for non-signed-in users' do
      it 'should require login' do
        get :new
        assert_redirected_to(new_user_session_url(seller: true))
      end
    end

    describe 'for signed-in users' do
      before :each do
        sign_in user
      end

      it 'should render the :new view' do
        get :new
        assert_template :new
      end

      it 'should be possible to get a new article from an existing one' do
        article = create :article, seller: user
        get :new, params: { edit_as_new: article.id }
        assert_template :new
        draftarticle = @controller.instance_variable_get(:@article)
        assert draftarticle.new_record?
        draftarticle.title.must_equal(article.title)
        draftarticle.original.must_equal article
      end
    end
  end

  describe '#edit' do
    describe 'for non-signed-in users' do
      it 'should deny access' do
        @article = create :article
        get :edit, params: { id: @article.id }
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      before :each do
        sign_in user
      end

      it 'should be successful for the seller' do
        @article = create :preview_article, seller: user
        get :edit, params: { id: @article.id }
        assert_template :edit
      end

      it 'should not be able to edit other users articles' do
        @article = create :preview_article, seller: (create(:user))

        assert_raises(Pundit::NotAuthorizedError) {
          get :edit, params: { id: @article.id }
        }
      end
    end
  end

  describe '#create' do
    before :each do
      @article_attrs = attributes_for :article, category_ids: [create(:category).id]
    end

    describe 'for non-signed-in users' do
      it 'should not create an article' do
        assert_no_difference 'Article.count' do
          post :create, params: { article: @article_attrs }
        end
      end
    end

    describe 'for signed-in users' do
      before :each do
        sign_in user
      end

      it 'should create an article' do
        assert_difference 'Article.count', 1 do
          post :create, params: { article: @article_attrs }
        end
      end

      it 'should save images even if article is invalid' do
        @article_attrs = attributes_for :article, :invalid, categories: [create(:category).id]
        @article_attrs[:images_attributes] = { '0' => { image: fixture_file_upload('/test.png', 'image/png') } }
        assert_difference 'Image.count', 1 do
          post :create, params: { article: @article_attrs }
        end
      end

      it 'should not raise an error for very high quantity values' do
        post :create, params: { article: @article_attrs.merge(quantity: '100000000000000000000000') }
        assert_template :new
      end

      it 'should successfully save an edit_as_new clone and transfer its slug and comments' do
        original_article = create :article, seller: user
        create :article, original: original_article
        comment = create :comment, commentable: original_article
        original_slug = original_article.slug

        assert_difference 'Article.count', 1 do
          post :create, params: { article: @article_attrs.merge(original_id: original_article.id) }
        end
        new_article = @controller.instance_variable_get(:@article)

        assert original_article.reload.closed?

        assert_equal new_article.slug, original_slug
        refute_equal original_article.slug, original_slug

        assert_equal original_article.comments.count, 0
        assert_equal comment, new_article.comments.first
      end
    end
  end

  # TODO: add more tests for delete
  describe '#destroy' do
    describe 'for signed-in users' do
      before :each do
        @article = create :preview_article, seller: user
        @article_attrs = attributes_for :article, categories: [create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it 'should delete the preview article' do
        assert_difference 'Article.count', -1 do
          put :destroy, params: { id: @article.id }
          assert_redirected_to(user_path(user))
        end
      end

      it 'should softdelete the locked article' do
        assert_no_difference 'Article.count' do
          put :update, params: { id: @article.id, activate: true, article: { tos_accepted: '1' } }
          # put :update, id: @article.id, deactivate: true
          put :destroy, params: { id: @article.id }
        end
      end
    end
  end

  describe '#update' do
    describe 'for signed-in users' do
      before :each do
        @article = create :preview_article, seller: user
        @article_attrs = attributes_for :article, categories: [create(:category)]
        @article_attrs.delete :seller
        sign_in user
      end

      it 'should update the article with new information' do
        put :update, params: { id: @article.id, article: @article_attrs }
        assert_redirected_to @article.reload
      end

      it 'changes the articles informations' do
        put :update, params: { id: @article.id, article: @article_attrs }
        assert_redirected_to @article.reload
        @controller
          .instance_variable_get(:@article)
          .title.must_equal @article_attrs[:title]
      end
    end

    describe 'activate article' do
      before do
        sign_in user
        @article = create :preview_article, seller: user
      end

      it 'should work' do
        put :update, params: { id: @article.id, article: { tos_accepted: '1' }, activate: true }
        assert_redirected_to @article
        flash[:notice].must_equal I18n.t 'article.notices.create_html'
      end

      it 'should work with an invalid article and set it as new article' do
        @article.title = nil
        @article.save validate: false
        ## we now have an invalid record
        put :update, params: { id: @article.id, article: { tos_accepted: '1' }, activate: true }
        assert_redirected_to new_article_path(edit_as_new: @article.id)
      end
    end

    describe 'deactivate article' do
      before do
        sign_in user
        @article = create :article, seller: user
      end

      it 'should work' do
        put :update, params: { id: @article.id, deactivate: true }
        assert_redirected_to @article
        flash[:notice].must_equal(I18n.t 'article.notices.deactivated')
      end

      it 'should work with an invalid article' do
        @article.title = nil
        @article.save validate: false
        ## we now have an invalid record
        put :update, params: { id: @article.id, deactivate: true }
        assert_redirected_to @article
        @article.reload.locked?.must_equal true
      end
    end
  end

  describe '#autocomplete' do # , search: true
    it 'should be successful' do
      ArticlesIndex.reset!
      @article = create :article, :index_article, title: 'chunky bacon'
      get :autocomplete, params: { q: 'chunky' }
      assert_response :success
      response.body.must_equal({
        query: 'chunky',
        suggestions: [{
          value: 'chunky bacon',
          data: {
            type: 'result',
            url: '/articles/chunky-bacon',
            thumb: '<img src="/assets/missing.png" alt="Missing" />'
          }
        }]
      }.to_json)

      get :autocomplete, params: { q: '@#%$#@' }
      assert_response :success
      response.body.must_equal({
        query: '@#%$#@',
        suggestions: []
      }.to_json)
    end

    it 'should rescue a StandardError error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(StandardError.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::ConnectionFailed error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::ConnectionFailed.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::TimeoutError error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::TimeoutError.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::ClientError error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::ClientError.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::ParsingError error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::ParsingError.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::SSLError error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::SSLError.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end

    it 'should rescue an Faraday::ResourceNotFound error' do
      ArticleAutocomplete.any_instance.stubs(:autocomplete).raises(Faraday::ResourceNotFound.new('test'))
      get :autocomplete, params: { keywords: 'chunky' }
      assert_response :success
      response.body.must_equal({ 'query' => nil, 'suggestions' => [] }.to_json)
    end
  end
end
