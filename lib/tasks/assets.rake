namespace :assets do
  desc 'recreate sprite images and css'
  task :resprite => :environment do
    require 'sprite_factory'
     SpriteFactory.report  = true                         # output report during generation
     SpriteFactory.library = :chunkypng                   # use simple chunkypng gem to handle .png sprite generation
     SpriteFactory.layout  = :packed
     SpriteFactory.run!('app/assets/images/sprites' ,
        :style => 'scss' ,
        :selector => 'span.sprite_',
        :cssurl => "image-url('$IMAGE')",
        :output_style => "app/assets/stylesheets/sprites.css.scss" )
  end
end