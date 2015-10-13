#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module WelcomeHelper
  def rss_image_extractor content
    if content.start_with? '<p><img'
      Sanitize.clean(content[0..(content.index('/>') + 1)], elements: ['img'], attributes: { 'img' => %w(src alt) }).html_safe
    else
      ''
    end
  end

  def featured_library_path library
    library ? library_path(library) : '#'
  end
end
