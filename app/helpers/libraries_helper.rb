#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module LibrariesHelper
  # Show range of paginated articles
  def article_range_str(paginated_articles)
    case
    when paginated_articles.total_count == 0
      t('common.text.no_articles')
    when paginated_articles.total_count == paginated_articles.size
      "#{paginated_articles.total_count}&nbsp;"\
      "#{t('common.text.articles')}".html_safe
    when article_range_start_number < article_range_end_number(paginated_articles)
      "#{t('common.text.article')}&nbsp;#{article_range_start_number}–"\
      "#{article_range_end_number(paginated_articles)}"\
      " #{t('common.text.glue_without_spaces.of')}&nbsp;"\
      "#{paginated_articles.total_count}".html_safe
    when article_range_start_number == article_range_end_number(paginated_articles)
      "#{t('common.text.article')}&nbsp;#{article_range_start_number}"\
      " #{t('common.text.glue_without_spaces.of')}&nbsp;"\
      "#{paginated_articles.total_count}".html_safe
    end
  end

  private

  def article_range_page
    params[:library_page] ? params[:library_page].to_i : 1
  end

  def article_range_offset(page)
    (page - 1) * 24
  end

  def article_range_start_number
    article_range_offset(article_range_page) + 1
  end

  def article_range_end_number(paginated_articles)
    article_range_offset(article_range_page) + paginated_articles.size
  end
end
