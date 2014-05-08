namespace :transactions do
  desc "Count Transactions for all Categories"
  task :categories => :environment do
    roots = Category.roots

    roots.each do |c|
      count = get_recursive_sold_count c
      puts "#{c.name}: #{count}"
    end

  end
end


def get_recursive_sold_count category
  count = 0
  category.children.each do |c|
    count += get_recursive_sold_count c
  end
  count += BusinessTransaction.joins(:article => :categories).where("business_transactions.state = ? AND business_transactions.sold_at > ? AND categories.id = ?", :sold, Time.parse("2013-09-23 23:25:00.000000 +02:00"), category.id).count
  count
end