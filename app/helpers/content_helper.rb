#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
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
end
