#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
#

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
