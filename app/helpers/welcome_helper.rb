#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module WelcomeHelper
  CALENDAR_WINDOW_LINKS = [
    '/adventskalender',
    '/advent01_naturkosmetik',
    '/advent02_ratespiele',
    '/advent03_tolino',
    '/advent04_holzspielzeug',
    '/advent05_variomondo',
    '/advent06_schokolade',
    '/advent07_',
    '/advent08_',
    '/advent09_',
    '/advent10_',
    '/advent11_',
    '/advent12_',
    '/advent13_',
    '/advent14_',
    '/advent15_',
    '/advent16_',
    '/advent17_',
    '/advent18_',
    '/advent19_',
    '/advent20_',
    '/advent21_',
    '/advent22_',
    '/advent23_',
    '/advent24_'
  ]

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

  # returns a number between 0 and 24
  def calendar_window_num
    now = Time.now
    if now < Time.new(2015, 12, 1, 9)
      0
    elsif now >= Time.new(2015, 12, 25, 9)
      24
    else
      day = now.day
      day -= 1 if now.hour < 9
      day
    end
  end

  def calendar_window_link(window_num)
    CALENDAR_WINDOW_LINKS[window_num]
  end
end
