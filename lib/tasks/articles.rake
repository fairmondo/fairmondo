# encoding: UTF-8

namespace :setup do

  desc 'Get a list of articles from http://www.itemmaster.com'

  task :articles => :environment do | t, args |

    require 'faker'
    require 'time'
    require 'net/http'
    require 'rexml/document'
    require 'activerecord-import'

    start_time = Time.now

    month = 24
    date = (Time.now - (60*60*24*7*4*month)).strftime('%Y%m%d')
    count = 20000

    puts "Getting articles from Item Master..."

    uri = URI.parse("https://api.itemmaster.com/v2/item/?since=#{date}&idx=0&limit=#{count}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    articles_xml = http.request(request).body
    doc = REXML::Document.new(articles_xml)

    puts "Completed task 'Getting articles'. #{doc.elements["items"].attributes["count"]} articles have been fetched.\n"

    print "Extracting titles and contents"

    articles = Hash.new

    count = 0
    fake_count = 0
    doc.elements.each('items/item') do |element|
      print "."
      name = element.elements["name"].to_s.slice(0..65)

      if element.elements["otherDescription"].to_s == "<otherDescription/>"
        articles[name] = Faker::Lorem.paragraph(rand(7)+1)
        fake_count += 1
      else
        articles[name] = element.elements["otherDescription"].to_s.slice(0..255)
        count += 1
      end
    end

    puts "\nDone. #{count} titles and contents have been extracted. #{fake_count} contents have been faked."

    puts "Creating an article for each entry."

    article_list = []
    image_list = []

    count = 0
    articles.each_pair do |name, description|
      print "."
      @article = FactoryGirl.build :article, :without_image, :title => name, :content => description
      article_list << @article
      count += 1
    end

    Article.import article_list

    puts "\nHooray! #{count} articles have been written to the database."

    end_time = Time.now - start_time

    puts "This took #{end_time} seconds."

  end
end
