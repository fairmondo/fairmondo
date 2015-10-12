#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Library < ActiveRecord::Base
  extend Sanitization, Enumerize
  include Commentable

  auto_sanitize :name

  delegate :nickname, to: :user, prefix: true

  validates :name, :user, presence: true
  validates :name, uniqueness: { scope: :user_id }, length: { maximum: 70 }

  enumerize :exhibition_name, in: [
    :donation_articles, :old, :queue1, :queue2, :queue3, :queue4,
    :book1,  :book2,  :book3,  :book4,  :book5,  :book6,  :book7,  :book8,
    :fair1,  :fair2,  :fair3,  :fair4,  :fair5,  :fair6,  :fair7,  :fair8,
    :eco1,   :eco2,   :eco3,   :eco4,   :eco5,   :eco6,   :eco7,   :eco8,
    :small1, :small2, :small3, :small4, :small5, :small6, :small7, :small8,
    :used1,  :used2,  :used3,  :used4,  :used5,  :used6,  :used7,  :used8
  ]
  before_update :uniquify_exhibition_name

  # Relations
  belongs_to :user

  has_many :library_elements, dependent: :destroy
  has_many :articles, through: :library_elements

  has_many :hearts, as: :heartable

  # Scopes
  scope :not_empty, -> { where('libraries.library_elements_count > 0') }
  scope :min_elem, -> (num) { where('libraries.library_elements_count >= ?', num) }
  scope :published, -> { where(public: true) }
  scope :no_admins, -> { joins(:user).where('users.admin = ?', false) }
  scope :most_popular, -> { reorder('libraries.popularity DESC, libraries.updated_at DESC') }
  scope :most_recent, -> { reorder(created_at: :desc) }
  scope :trending, -> { most_popular.not_empty.published }
  scope :audited, -> { where(audited: true) }
  scope :trending_welcome_page, -> { trending.audited.limit(2) }

  # libraries with most of the articles belonging to one of the given categories
  scope :for_category, (lambda do |categories|
    joins(articles: :categories)
    .where(categories: { id: categories }, public: true)
    .group('libraries.id')
    .having('count(*) > libraries.library_elements_count / 2')
  end)

  default_scope { order(updated_at: :desc) }

  # Returns true if the library contains article
  def includes_article? article
    self.articles.include? article
  end

  # Returns true if the library is currently shown on the welcome page
  def on_welcome_page?
    Library.trending_welcome_page.include? self
  end

  # Returns true if the library has no library elements
  def has_elements?
    library_elements_count != 0
  end

  # Returns true if the library has comments
  def has_comments?
    comments_count > 0
  end

  private

  # when an exhibition name is set to a library, remove the same exhibition
  # name from all other libraries.
  def uniquify_exhibition_name
    if self.exhibition_name
      Library.where(exhibition_name: self.exhibition_name).where('id != ?', self.id).each do |library|
        library.update_attribute(:exhibition_name, nil)
      end
    end
    true
  end
end
