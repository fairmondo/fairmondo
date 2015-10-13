#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class DeferredGarbageCollection

  DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 15.0).to_f

  @@last_gc_run = Time.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end

  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.now
    end
  end
end
