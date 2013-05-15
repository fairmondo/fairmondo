# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

require_relative 'fixtures/category_seed_data.rb'
include CategorySeedData

# skip the devise mailer callback
[User, Article].each do |model|
  model.skip_callback(:create, :after, :send_on_create_confirmation_instructions)
end

admin = User.find_by_email("admin@admin.com")
unless admin
  admin = FactoryGirl.create(:admin_user, :email => "admin@admin.com", :password => "password", :password_confirmation => "password", :trustcommunity => true)
end

user = User.find_by_email("user@user.com")
unless user
  user = FactoryGirl.create(:user, :email => "user@user.com", :password => "password", :password_confirmation => "password")
end

setup_categories

50.times do
  FactoryGirl.create :article, :without_image
end


# TinyCMS pages
Tinycms::Content.create key:'start-left', body:	'<h1>Willkommen!</h1><p>Dies ist die Beta-Testplattform f&uuml;r den Fairnopoly Online-Marktplatz.</p><p>Du kannst Dich hier gerne umschauen und frei herumspielen, solange Du untenstehende Datenschutzbestimmungen beachtest.</p><p>Die Funktionen sind noch eingeschr&auml;nkt und das Design muss noch weiter angepasst werden. Bitte teile uns alle Fehler, Ideen, Anregungen etc. mit, die Dir w&auml;hrend des Testens auffallen:</p><p><a href="http://info.fairnopoly.de/forum/?mingleforumaction=vforum&amp;g=2.0" target="_blank">Kommentieren &uuml;bers Forum</a></p><p>Oder per Email: bugs@fairnopoly.de</p><p>&nbsp;</p><p><strong>Datenschutzbestimmungen:</strong></p><p>1. Dies ist eine reine Testversion, Fairnopoly &uuml;bernimmt keine Garantie oder Haftung f&uuml;r auf dieser Testversion eingegebene Daten. Falls Du keine eigene Emailadresse f&uuml;r die Registrierung verwenden m&ouml;chtest, kannst Du einen der bei denen Logindaten verwenden:</p><p>Login: testerin@fairnopoly.de</p><p>Passwort: testerin</p><p>oder&nbsp;</p><p>Login: tester@fairnopoly.de</p><p>Passwort: tester &nbsp; &nbsp;</p><p>&nbsp;</p><p>2. Bitte lade nur Bilddateien hoch, zu deren Verwendung Du berechtigt bist. Fairnopoly &uuml;bernimmt keine Haftung f&uuml;r auf diese Testversion hochgeladene Inhalte.&nbsp; &nbsp; &nbsp;</p><p>&nbsp;</p><p>3.&nbsp;Nach Ablauf der Testphase (voraussichtlich am Freitag, 30.11.2012) werden s&auml;mtliche Daten gel&ouml;scht.</p>'
Tinycms::Content.create key:'start-video', body: '<p><iframe src="http://www.youtube.com/embed/8t6zRafs2J8?rel=0&amp;wmode=transparent&amp;" frameborder="0"></iframe></p>'
Tinycms::Content.create key:'start-right', body: nil
Tinycms::Content.create key:'banned', body: '<p>Da in dies eine nicht &ouml;ffentliche Beta ist muss der Account noch aktiviert werden.</p>'