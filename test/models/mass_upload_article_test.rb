#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class MassUploadArticleTest < ActiveSupport::TestCase
  subject { MassUploadArticle.new }

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :mass_upload_id }
    it { _(subject).must_respond_to :article_id }
    it { _(subject).must_respond_to :action }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :row_index }
    it { _(subject).must_respond_to :validation_errors }
    it { _(subject).must_respond_to :article_csv }
    it { _(subject).must_respond_to :process_identifier }
  end
  describe 'methods' do
    describe '#done?' do
      it do
        MassUploadArticle.new(process_identifier: 'test').done?.must_equal false
      end
      it do
        MassUploadArticle.new(process_identifier: 'test', validation_errors: 'lala').done?.must_equal true
      end
      it do
        MassUploadArticle.new(process_identifier: 'test', article: Article.new).done?.must_equal true
      end
    end
  end

  # see https://github.com/fairmondo/fairmondo/issues/1414:
  # The issue was already fixed but only after the quantity was updated.
  #
  # see app/observers/article_observer.rb:
  # The callback is only triggered if the quantity is changed again
  describe 'quantity and quantity_available' do
    let(:old_quantity) { 1 }
    let(:quantity) { 100 }

    before do
      Article.any_instance.stubs(:valid?).returns(true)
      MassUploadArticle.any_instance.stubs(:update_index)
      Indexer.stubs(:index_article)
    end

    let(:unsanitized_row_hash) do
      {
        'title' => 'Richard Fischer: Tabellenbuch Kraftfahrzeugtechnik mit Formelsammlung (Taschenbuch, EAN 9783808521366)', 'categories' => '1', 'condition' => 'new', 'content' => '<h3>Tabellenbuch Kraftfahrzeugtechnik mit Formelsammlung</h3><p>von <b>Richard Fischer</b></p><p>Deutsch, September 2008, Europa Lehrmittel Verlag, Taschenbuch, ISBN 3808521368, EAN 9783808521366</p><p><b>Beschreibung</b></p><p><br \\>Das Standardwerk zur Lösung von kraftfahrzeugtechnischen Problemstellungen und Aufgaben in der Arbeitsplanung, im Technologiepraktikum und im Techniklabor.<br \\>Alle wichtigen Formeln, häufig mit Beispielaufgaben, Diagrammen und technischen Werten der Kfz-Technik.<br \\>Mathematik, technische Formeln, Grundkenntnisse der Metalltechnik, Fachkenntnisse Kfz-Technik, Werkstoffkunde, Technisches Zeichnen, Normteile.<br \\>Anschauliche und übersichtliche Darstellung.</p>',
        'quantity' => quantity,
        'price_cents' => '3120', 'vat' => '7', 'external_title_image_url' => 'http://media.ecobookstore.de/366/EAN_9783808521366.jpg', 'transport_type1' => 'true', 'transport_type1_provider' => 'Postversand', 'transport_type1_price_cents' => '0', 'transport_type1_number' => '9', 'transport_details' => nil, 'transport_time' => '1-3', 'unified_transport' => 'false', 'payment_bank_transfer' => 'true', 'payment_paypal' => 'true', 'payment_invoice' => 'false', 'payment_voucher' => 'true', 'payment_details' => nil, 'gtin' => '9783808521366', 'custom_seller_identifier' => 'LIB-9783808521366', 'action' => 'update'
      }
    end

    it 'should be updated' do
      Sidekiq.logger.stubs(:warn)

      mass_upload_article = create :update_mass_upload_article
      mass_upload = mass_upload_article.mass_upload
      user = mass_upload.user
      article = create :article, seller: user, custom_seller_identifier: 'LIB-9783808521366', quantity: old_quantity

      mass_upload_article.process unsanitized_row_hash
      article.reload

      article.quantity.must_equal quantity
    end

    it 'should update available quantity even if database column is not empty' do
      Sidekiq.logger.stubs(:warn)

      mass_upload_article = create :update_mass_upload_article
      mass_upload = mass_upload_article.mass_upload
      user = mass_upload.user
      article = create :article, seller: user, custom_seller_identifier: 'LIB-9783808521366', quantity: old_quantity, quantity_available: old_quantity

      mass_upload_article.process unsanitized_row_hash
      article.reload

      article.activate
      article.quantity_available.must_equal quantity
    end
  end

  describe 'empty CSV rows' do
    before do
      Article.any_instance.stubs(:valid?).returns(true)
      MassUploadArticle.any_instance.stubs(:update_index)
      Indexer.stubs(:index_article)
    end

    let(:unsanitized_row_hash) do
      {
        "﻿€"=>"NULL", "title"=>nil, "categories"=>nil, "condition"=>nil, "content"=>nil, "quantity"=>nil,
        "price_cents"=>nil, "vat"=>nil, "external_title_image_url"=>nil, "transport_type1"=>nil,
        "transport_type1_provider"=>nil, "transport_type1_price_cents"=>nil, "transport_type1_number"=>nil,
        "transport_details"=>nil, "transport_time"=>nil, "unified_transport"=>nil,
        "payment_bank_transfer"=>nil, "payment_paypal"=>nil, "payment_invoice"=>nil,
        "payment_voucher"=>nil, "payment_details"=>nil, "gtin"=>nil, "custom_seller_identifier"=>nil,
        "action"=>nil
      }
    end

    it 'should be updated' do
      skip('Bug not yet fixed')

      mass_upload_article = create :mass_upload_article
      mass_upload = mass_upload_article.mass_upload

      mass_upload_article.process unsanitized_row_hash
    end
  end
end
