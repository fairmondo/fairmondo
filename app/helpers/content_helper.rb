#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module ContentHelper
  def tinycms_content(key)
    render 'contents/embed', content: find_content(key)
  end

  def tinycms_content_body(key)
    content = find_content(key)
    content && content.body ? content.body : ''
  end

  def find_content key
    ::Content.find_or_create_by(key: key.to_s.parameterize)
  end

  def tinycms_content_body_sanitized(key)
    content = tinycms_content_body(key)
    Sanitize.clean(content)
  end

  def expand_content_body(body)
    body = body.dup
    pattern = /<p>\[articles ids="(?:(\d{1,10})\s)?(?:(\d{1,10})\s)?(?:(\d{1,10})\s)?(\d{1,10})"\]<\/p>/i
    while body =~ pattern
      begin
        article_ids = Regexp.last_match[1..-1].compact.map(&:to_i)
        articles = Article.find(article_ids)
        rendered_articles = render 'articles/shared/articles_grid', articles: articles,
                                                                    with_admin_section: false
        body.sub!(pattern, rendered_articles)
      rescue ActiveRecord::RecordNotFound
        body.sub!(pattern, t('tinycms.content.article_not_found_html'))
      end
    end
    body.html_safe
  end
end
