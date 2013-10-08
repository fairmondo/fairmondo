# encoding: utf-8
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class MassUpload

  # Required for Active Model Conversion which is required by Formtastic
  include ActiveModel::Conversion

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  include Checks, Questionnaire, FeesAndDonations

  def initialize(attributes = nil)
    @errors = ActiveModel::Errors.new(self)

    if attributes && attributes[:file]
      self.file = attributes[:file]
    end
  end

  attr_accessor :file
  attr_reader   :errors, :articles

  def parse_csv_for(user)

    unless file_selected?
      return false
    end

    unless csv_format?
      return false
    end

    unless correct_encoding_and_escaping?
      return false
    end

    unless correct_article_count?
      return false
    end

    unless correct_header?
      return false
    end

    build_articles_for(user)

    unless articles_valid?
      return false
    end

    save_articles!

    true
  end


  def build_articles_for(user)
    @articles = []
    CSV.foreach(self.file.path, headers: true, col_sep: ";") do |row|
      row_hash = row.to_hash
      categories = Category.find_imported_categories(row_hash['categories'])
      row_hash.delete("categories")
      row_hash = Questionnaire.include_fair_questionnaires!(row_hash)
      article = Article.new(row_hash)
      article.user_id = user.id
      Questionnaire.add_commendation(article)
      revise_prices(article)
      article.categories = categories if categories
      @articles << article
    end
  end

  def articles_valid?
    valid = true
    @articles.each_with_index do |article, index|
      if article.errors.full_messages.any?
        add_article_error_messages(article, index)
        valid = false
      end

      if article.invalid?
        add_article_error_messages(article, index)
        valid = false
      end
    end
    return valid
  end

  def add_article_error_messages(article, index)
    # bugbugb Needs refactoring (the error messages should be styled elsewhere -> no <br>s)
    article.errors.full_messages.each do |message|
      first_line_break = ""
      if article.errors.full_messages[0] == message && index > 0 # && image_errors == false
        first_line_break = "<br/>"
      end
      errors.add(:file, "<br/>#{first_line_break} #{I18n.t('mass_upload.errors.wrong_article', message: message, index: (index + 2))}")
    end
  end

  def save_articles!
    @articles.each do |article|
      article.calculate_fees_and_donations
      article.save!
    end
  end

  def revise_prices(article)
    unless article.basic_price
      article.basic_price = 0
    end
    unless article.transport_type1_price_cents
      article.transport_type1_price_cents = 0
    end
    unless article.transport_type2_price_cents
      article.transport_type2_price_cents = 0
    end
    unless article.payment_cash_on_delivery_price_cents
      article.payment_cash_on_delivery_price_cents = 0
    end
  end

  # The following 3 methods are needed for Active Model Errors

  def MassUpload.human_attribute_name(attr, options = {})
   attr
  end

  # The following 2 are not currently used but might be needed because of Active
  # Model Errors in the future. They are commented out to make sure the test
  # coverage can reach 100%
  # def read_attribute_for_validation(attr)
  #  send(attr)
  # end

  # def MassUpload.lookup_ancestors
  #  [self]
  # end

  # The following method is needed for Active Model Conversions
  def persisted?
    false
  end
end