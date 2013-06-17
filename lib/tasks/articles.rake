# encoding: UTF-8

namespace :setup do

  desc 'Get a list of articles from http://www.itemmaster.com'
 
  task :articles => :environment do
    
    require 'faker'
    require 'time'
    require 'net/http'
    require 'rexml/document'

    month = 6
    date = (Time.now - (60*60*24*7*4*month)).strftime('%Y%m%d')
    count = 20000
    
    puts "Getting articles from Item Master..."
    
    uri = URI.parse("https://api.itemmaster.com/v2/item/?since=#{date}&idx=0&limit=#{count}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(uri.request_uri)
    articles_xml = http.request(request).body
    
    puts "Completed task 'Getting articles'. #{count} articles have been fetched."
    
    puts "Extracting titles and contents..."
    
    doc = REXML::Document.new(articles_xml)
    titles = []
    contents = []

    doc.elements.each('items/item/name') do |element|
      titles << element.text.to_s.slice(0..64)
    end
    
    doc.elements.each('items/item/otherDescription') do |element|
      #contents << element.text.to_s #.slice(0..255)
      if element.text.to_s == ""
        contents << Faker::Lorem.paragraph(rand(7)+1)
      else
        contents << element.text #.to_s.slice(0..255)
      end
    end
    
    puts "Done."
    
    puts "Creating an article for each entry."
    

    titles.each_with_index do |title, index|
      FactoryGirl.create :article, :title => title, :content => contents[index]
    end
    
    puts "Hooray!"
    
  end
end
