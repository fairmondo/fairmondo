#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# Connector model for MassUpload <-> Articles
# with additional action
class MassUploadArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :mass_upload
  has_one :user, through: :mass_upload
  default_scope { order('row_index ASC') }

  ACTION_MAPPING = {
    'c' => :create,
    'create' => :create,
    'u' => :update,
    'update' => :update,
    'x' => :delete,
    'delete' => :delete,
    'a' => :activate,
    'activate' => :activate,
    'd' => :deactivate,
    'deactivate' => :deactivate,
    'nothing' => :nothing
  }
  IDENTIFIERS = %w(id custom_seller_identifier)

  def done?
    self.article.present? || self.validation_errors.present?
  end

  def self.find_or_create_from_row_index index, mass_upload
    mass_upload_article = mass_upload.mass_upload_articles.where(row_index: index).first
    mass_upload_article || mass_upload.mass_upload_articles.create!(row_index: index)
  end

  def process article_attributes
    @original_attributes = article_attributes
    prepare_attributes
    prepare_article
    self.with_lock do
      store unless self.done?
    end
    update_index if @prepared_action == :update
  end

  private

  #### THIS METHOD IS CALLED IN A LOCK
  def store
    store_article
    update_mass_upload_article
  end

  #### THIS METHOD IS CALLED IN A LOCK
  def store_article
    case @prepared_action
    when :activate, :create, :update
      @prepared_article.save!
    when :delete
      @prepared_article.close_without_validation
    when :deactivate
      @prepared_article.deactivate_without_validation
    end
  end

  #### THIS METHOD IS CALLED IN A LOCK
  def update_mass_upload_article
    if @prepared_action == :error
      self.update_attributes(article_csv: original_csv, validation_errors: @error_text, action: :error)
    else
      self.update_attributes(article_id: @prepared_article.id, action: @prepared_action) # save action and article
    end
  end

  def update_index
    Indexer.index_article @prepared_article
  end

  ##################################### Prepare Attributes ####################################

  def prepare_attributes
    @article_attributes = @original_attributes.dup
    sanitize_fields
    prepare_categories
    prepare_questionaires
    prepare_action
  end

  # Throw away additional fields that are not needed
  def sanitize_fields
    @article_attributes.slice!(*MassUpload.article_attributes)
  end

  def prepare_categories
    @article_attributes['category_ids'] = @article_attributes.delete('categories').split(',') if @article_attributes['categories']
  end

  def prepare_questionaires
    MassUpload::Questionnaire.include_fair_questionnaires(@article_attributes)
    MassUpload::Questionnaire.add_commendation(@article_attributes)
  end

  # Defaults: create when no ID is set, does nothing when an ID exists
  # @return [String]
  def acquire_processing_default
    return :nothing if @article_attributes['id']
    return :nothing if @article_attributes['custom_seller_identifier'] && find_article_by_custom_seller_identifier.present?
    return :create
  end

  def prepare_action
    @article_attributes['action'].strip! if @article_attributes['action']
    action = @article_attributes['action']
    if ACTION_MAPPING.keys.include? action
      @prepared_action = ACTION_MAPPING[action]
    elsif action == nil
      @prepared_action = acquire_processing_default
    else
      put_error I18n.t('mass_uploads.errors.unknown_action')
    end
  end

  ################################## Prepare Article #######################################

  def prepare_article
    find_or_build_article if [:create, :update, :delete, :activate, :deactivate, :nothing].include? @prepared_action
    update_article if @prepared_action == :update
    revise_prices if [:create, :update].include? @prepared_action
    validate_article if [:create, :update].include? @prepared_action
    calculate_fees if [:create, :update, :activate].include? @prepared_action
  end

  def update_article
    if @prepared_article.bought_or_in_cart?
      @prepared_article = Article.edit_as_new @prepared_article
    else
      @prepared_article.state = :locked
    end
    @prepared_article.categories.clear if @article_attributes['category_ids']
    @article_attributes.delete('id')
    @prepared_article.assign_attributes(@article_attributes)
  end

  def revise_prices
    @prepared_article.basic_price ||= 0
    @prepared_article.transport_type1_price_cents ||= 0
    @prepared_article.transport_type2_price_cents ||= 0
    @prepared_article.payment_cash_on_delivery_price_cents ||= 0
  end

  def find_or_build_article
    @prepared_article = (@prepared_action == :create) ? user.articles.build(@article_attributes) : find_by_id_or_custom_seller_identifier
  end

  def validate_article
    put_error @prepared_article.errors.full_messages.join("\n") unless @prepared_article.valid?
  end

  def calculate_fees
    # needs to be done in advance for every article. would cost alot while mass activating
    @prepared_article.calculate_fees_and_donations
  end

  # We allow sellers to use their custom field as an identifier but we need the ID internally
  def find_by_id_or_custom_seller_identifier
    if IDENTIFIERS.select { |v| @article_attributes.include?(v) && @article_attributes[v].present? }.empty?
      put_error I18n.t('mass_uploads.errors.no_identifier')
      nil
    else
      article = @article_attributes['id'].present? ? find_article_by_id : find_article_by_custom_seller_identifier
      put_error I18n.t('mass_uploads.errors.article_not_found') unless article.present?
      article
    end
  end

  def find_article_by_custom_seller_identifier
    user.articles.where(custom_seller_identifier: @article_attributes['custom_seller_identifier']).latest_without_closed.first
  end

  def find_article_by_id
    user.articles.where(id: @article_attributes['id']).latest_without_closed.first
  end

  # error handling

  def put_error error
    @prepared_action = :error
    @error_text = error
  end

  def original_csv
    reconstructed_line = MassUpload.article_attributes.map { |column| @original_attributes[column] }
    CSV.generate_line(reconstructed_line, col_sep: ';')
  end
end
