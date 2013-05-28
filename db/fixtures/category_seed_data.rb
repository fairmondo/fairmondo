module CategorySeedData
  def setup_categories
    Category.find_or_create_by_name("Fahrzeuge")
    electronic = Category.find_or_create_by_name("Elektronik")
    Category.find_or_create_by_name("Haus & Garten")
    Category.find_or_create_by_name("Freizeit & Hobby")
    computer = Category.find_or_create_by_name("Computer", :parent => electronic)
    Category.find_or_create_by_name("Audio & HiFi", :parent => electronic)
    Category.find_or_create_by_name("Hardware", :parent => computer)
    Category.find_or_create_by_name("Software", :parent => computer)
    Category.rebuild!
  end
end
