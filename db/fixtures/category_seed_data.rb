module CategorySeedData
  def setup_categories
    Category.create(:name => "Fahrzeuge", :desc => "")
    electronic = Category.create(:name => "Elektronik", :desc => "")
    Category.create(:name => "Haus & Garten", :desc => "")
    Category.create(:name => "Freizeit & Hobby", :desc => "")
    computer = Category.create(:name => "Computer", :desc => "", :parent => electronic)
    Category.create(:name => "Audio & HiFi ", :desc => "", :parent => electronic)
    Category.create(:name => "Hardware", :desc => "", :parent => computer)
    Category.create(:name => "Software", :desc => "", :parent => computer)
    Category.rebuild!
  end
end