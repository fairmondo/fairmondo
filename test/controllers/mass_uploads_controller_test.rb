#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class MassUploadsControllerTest < ActionController::TestCase
  # Strictly speaking not necessary since already tested in the feature tests
  describe "GET 'new'" do
    describe 'for non-signed-in users' do
      it 'should require login' do
        get :new
        assert_redirected_to(new_user_session_path)
      end
    end

    describe 'for signed-in users' do
      let(:user) { create :legal_entity, direct_debit_exemption: true }
      before { sign_in user }

      it 'should render the :new view' do
        get :new
        assert_template :new
      end
    end
  end

  describe 'mass-upload creation' do
    let(:user) { create(:legal_entity, :paypal_data, direct_debit_exemption: true) }
    let(:attributes) { attributes_for(:mass_upload, user: user) }

    before do
      sign_in user
    end

    describe 'POST ::create' do
      it 'should create a mass-upload object' do
        assert_difference 'MassUpload.count', 1 do
          post :create, params:{ mass_upload: attributes }
        end
        assert_redirected_to user_path(user, anchor: 'my_mass_uploads')
        assert_equal(3, MassUpload.last.articles.count)
      end
      it 'should create a mass-upload object for heavy uploaders' do
        user.update_attribute(:heavy_uploader, true)
        assert_difference 'MassUpload.count', 1 do
          post :create, params:{ mass_upload: attributes }
        end
        assert_redirected_to user_path(user, anchor: 'my_mass_uploads')
        assert_equal(3, MassUpload.last.articles.count)
      end
    end

    describe 'PUT ::update' do
      it 'should update description' do
        post :create, params:{ mass_upload: attributes }
        mass_upload = MassUpload.last
        mass_upload.finish!

        Indexer.expects(:index_mass_upload).with(mass_upload.id)

        post :update, params:{ id: MassUpload.last.id }
        assert_redirected_to user_path(user)
        assert MassUpload.last.articles.first.active?
      end
    end
  end
end
