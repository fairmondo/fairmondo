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

  def calendar_time?
    current_time = Time.now
    if (current_time >= Time.new(2015, 11, 24)) && (current_time <= Time.new(2015, 12, 25, 9))
      true
    else
      false
    end
  end

  def calendar_partial_name
    now = Time.now
    if now < Time.new(2015, 12, 1)
      'welcome/advent_calendar/window_pre'
    else
      day = now.day
      day -= 1 if now.hour < 9
      day_str = day.to_s.rjust(2, '0')
      "welcome/advent_calendar/window_#{day_str}"
    end
  end
end
