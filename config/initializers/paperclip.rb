#https://github.com/thoughtbot/paperclip/issues/1429

#TODO: when the issue is cosed update paperclip and remove this

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

# Default Url Monkey.
# https://github.com/thoughtbot/paperclip/issues/1335https://github.com/thoughtbot/paperclip/issues/1335
Paperclip.interpolates :default_image_url do |attachment, style|
  ActionController::Base.helpers.asset_path('missing.png')
end


# Modifications on delayed_paperclip
module DelayedPaperclip
  module Jobs
    class Sidekiq

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        queue = 'paperclip_foreground'
        queue = Thread.current.celluloid? ? 'paperclip_background' : queue if Thread.current.respond_to? :celluloid?
        ::Sidekiq::Client.push({ 'class' => self ,'queue' => queue,'args'  => [instance_klass, instance_id, attachment_name]})
      end

      def perform(instance_klass, instance_id, attachment_name)
        instance = instance_klass.constantize.find instance_id
        DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name)
        if instance.is_a? ArticleImage
           article = instance.article
           ::Indexer.index_article article if article && instance.id == article.title_image.id
        end
      rescue ActiveRecord::RecordNotFound
        # it's probably already deleted so just finish the job
      end

    end
  end
end