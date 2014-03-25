
# encoding: UTF-8

namespace :db do
  desc 'Migrate & prepare test db'
  task :update do
    puts 'Updating database...'
    system 'rake db:migrate'
    system 'rake db:test:prepare'
    puts "\n\nDatabase updated.\n\n"
  end

  desc 'Reset, Migrate, Seed & prepare test db'
  task :upgrade do
    puts 'Upgrading database...'
    system 'rake db:migrate:reset'
    system 'rake db:seed'
    system 'rake db:test:prepare'
    puts "\n\nDatabase updated.\n\n"
  end

  desc 'DB table drop for staging'
  task :drop_tables do
    return false unless ENV['RAILS_ENV'] == 'staging'
    conn = ActiveRecord::Base.connection
    tables = conn.tables.map { |t| t }
    tables.each { |t| conn.execute("DROP TABLE IF EXISTS #{t}") }
    puts "DROP finished."
  end

  desc 'Get a list of articles from http://www.itemmaster.com'
  task :seed_articles, [:number_of_items] => :environment do | t, args |
    require 'faker'
    require 'time'
    require 'net/http'
    require 'rexml/document'
    require 'activerecord-import'

    def create_users(count)
      n = count / 10
      user_list = []
      print "Creating users"
      counter = 0
      n.times do
        print "."
        user = FactoryGirl.build :user
        user_list << user
        counter +=1
      end
      User.import user_list
      puts "\n#{n} users have been created."
    end

    def get_articles(date, count)
      puts "Getting articles from Item Master..."

      uri = URI.parse("https://api.itemmaster.com/v2/item/?since=#{date}&idx=0&limit=#{count}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      articles_xml = http.request(request).body
      doc = REXML::Document.new(articles_xml)

      puts "Completed task 'Getting articles'. #{doc.elements["items"].attributes["count"]} articles have been fetched.\n"
      return doc
    end

    def extract_articles_from_xml(xml_doc)
      articles = Hash.new
      count = 0
      faker_count = 0

      print "Extracting titles and contents"

      xml_doc.elements.each('items/item') do |element|
        print "."
        name = element.elements["name"].to_s.slice(0..65)

        if element.elements["otherDescription"].to_s == "<otherDescription/>"
          articles[name] = Faker::Lorem.paragraph(rand(7)+1)
          faker_count += 1
        else
          articles[name] = element.elements["otherDescription"].to_s.slice(0..255)
          count += 1
        end
      end

      puts "\nDone. #{count} titles and contents have been extracted. #{faker_count} contents have been faked."
      return articles
    end

    def build_articles(articles)
      category = Category.all.to_a
      user = User.all[2..User.all.length]
      count = 0
      article_list = []
      print "Creating an article for each entry."
      articles.each_pair do |name, description|
        print "."
        @article = FactoryGirl.build :article, :without_image, :seller => user.sample,
                                     :title => name, :content => description, :categories => [category.sample]
        article_list << @article
        count += 1
      end
      return article_list
    end

    # Variables and lists and hashes
    start_time = Time.now
    month = 24
    date = (start_time - (60*60*24*7*4*month)).strftime('%Y%m%d')

    args.with_defaults :number_of_items => 100
    count = args.number_of_items.to_i

    xml_doc = get_articles(date, count)

    articles = extract_articles_from_xml(xml_doc)
    create_users(count)
    Article.import build_articles(articles)

    end_time = Time.now - start_time
    puts "\nThis took #{end_time} seconds."

  end
end
