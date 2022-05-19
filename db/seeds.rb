#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

admin = User.find_by_email("admin@admin.com")
unless admin
  admin = FactoryBot.create(:admin_user, :email => "admin@admin.com", :password => "password")
end

user = User.find_by_email("user@user.com")
unless user
  user = FactoryBot.create(:private_user, :email => "user@user.com", :password => "password")
end

user_legal = User.find_by_email("le@le.com")
unless user_legal
  user_legal = FactoryBot.create(:legal_entity, :paypal_data, :with_unified_transport_information, :email => "le@le.com", :password => "password")
end

require_relative 'fixtures/category_seed_data.rb'
include CategorySeedData
seed_categories

15.times do
  FactoryBot.create :article, :categories => [@categories.sample]
end
15.times do
  FactoryBot.create :article, :with_larger_quantity, :categories => [@categories.sample]
end
# Different articles to test transactions
FactoryBot.create :article, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_private_user, title: 'Tester By Private User', :categories => [@categories.sample]
FactoryBot.create :article, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_legal_entity,  title: 'Tester By Legal Entity', :categories => [@categories.sample]
5.times do |number|
  FactoryBot.create :article, :with_larger_quantity, :with_all_transports,
                     :with_all_payments, :with_private_user , categories: [@categories.sample],
                     title: "Cart Tester #{number}", seller: user_legal
end

# Fill Exhibitions
max_offset = Article.count - 4
[:queue1,:queue2,:queue3,:queue4,:old,:donation_articles,:book1,:book2,:book3,:book4,:book5,:book6,:book7,:book8].each do |queue|
  lib = FactoryBot.create :library, :public, exhibition_name: queue
  lib.articles << Article.offset(rand(0..max_offset)).first(4)
end

# TinyCMS pages
Content.create key:'start-left', body:  '<h1>Willkommen!</h1><p>Dies ist die Beta-Testplattform f&uuml;r den Fairmondo Online-Marktplatz.</p><p>Du kannst Dich hier gerne umschauen und frei herumspielen, solange Du untenstehende Datenschutzbestimmungen beachtest.</p><p>Die Funktionen sind noch eingeschr&auml;nkt und das Design muss noch weiter angepasst werden. Bitte teile uns alle Fehler, Ideen, Anregungen etc. mit, die Dir w&auml;hrend des Testens auffallen:</p><p><a href="http://info.fairmondo.de/forum/?mingleforumaction=vforum&amp;g=2.0" target="_blank">Kommentieren &uuml;bers Forum</a></p><p>Oder per E-Mail: bugs@fairmondo.de</p><p>&nbsp;</p><p><strong>Datenschutzbestimmungen:</strong></p><p>1. Dies ist eine reine Testversion, Fairmondo &uuml;bernimmt keine Garantie oder Haftung f&uuml;r auf dieser Testversion eingegebene Daten. Falls Du keine eigene E-Mail-Adresse f&uuml;r die Registrierung verwenden m&ouml;chtest, kannst Du einen der bei denen Logindaten verwenden:</p><p>Login: testerin@fairmondo.de</p><p>Passwort: testerin</p><p>oder&nbsp;</p><p>Login: tester@fairmondo.de</p><p>Passwort: tester &nbsp; &nbsp;</p><p>&nbsp;</p><p>2. Bitte lade nur Bilddateien hoch, zu deren Verwendung Du berechtigt bist. Fairmondo &uuml;bernimmt keine Haftung f&uuml;r auf diese Testversion hochgeladene Inhalte.&nbsp; &nbsp; &nbsp;</p><p>&nbsp;</p><p>3.&nbsp;Nach Ablauf der Testphase (voraussichtlich am Freitag, 30.11.2012) werden s&auml;mtliche Daten gel&ouml;scht.</p>'
Content.create key:'start-video', body: '<p><iframe src="http://www.youtube.com/embed/8t6zRafs2J8?rel=0&amp;wmode=transparent&amp;" frameborder="0"></iframe></p>'
Content.create key:'banned', body: '<p>Da in dies eine nicht &ouml;ffentliche Beta ist muss der Account noch aktiviert werden.</p>'
Content.create key:'test_phase_greeting', body: '<div class="well"><strong>Herzlich willkommen zur Testversion vom Fairmondo Online-Marktplatz!</strong> <br /><br /> Hier k&ouml;nnt Ihr bereits die wichtigsten Funktionen vorab ausprobieren. Bitte beachtet: Dies ist eine reine Testversion, an der noch viel geschraubt wird.Nach und nach wird von uns das restliche Design eingearbeitet, ein paar kleinere Probleme behoben, und weitere Hilfstexte eingepflegt. Von dem Funktionsumfang enspricht die Testversion aber der Pionierversion, mit der wir nach der Testphase und der Einarbeitung Eures Feedbacks starten! <br /><br /> <strong>Da es sich um eine Testversion handelt, k&ouml;nnen derzeit keine authentischen Artikelangebote eingestellt oder K&auml;ufe get&auml;tigt werden! Wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Ihr m&uuml;&szlig;t Euch auch nicht mit authentischen pers&ouml;nlichen Daten anmelden, au&szlig;er der E-Mail-Adresse, an welche die Registrierungsbest&auml;tigung verschickt wird. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht, dazu geh&ouml;rt auch die von Euch eingegebene E-Mail-Adresse. </strong> <br /><br /></div>'
Content.create key:'buy-ffps', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><a class="btn btn-primary btn-large pull-right" href="http://fairmondo.startnext.de/">Sichere Dir Deinen Anteil</a></span><span style="font-family: arial, helvetica, sans-serif; font-size: small; line-height: 16px;">Bis zum 1.3.2013 ist es m&ouml;glich, sich &uuml;ber unsere Crowdfunding-Kampagne an Fairmondo zu beteiligen: fairmondo.startnext.de</span></p>'
Content.create key:'progress-ffps', body: '<div class="progress progress-landing"><div class="bar" style="height: 100%; width: 100%;">&nbsp;</div></div><p><a class="pull-right" href="http://fairmondo.startnext.de">Anteile kaufen</a> 156.183 &euro; von 100.000 &euro; erreicht</p>'
Content.create key:'please-register', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><span class="b" style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;"><strong style="margin: 0px; padding: 0px;">Bitte beachten:</strong></span><span style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;">&nbsp;&nbsp;</span><span style="line-height: 16px;">Dies ist eine reine Testversion, wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht.</span></span></p>'
Content.create key:'about_us', body: '<h1>About</h1><p>Dummy Site</p>'
# Startseite
Content.create key:'heading_features', body: 'Tolle Dinge'
Content.create key:'heading_features2', body: 'Bücherbox'
Content.create key:'heading_features3', body: 'Gutes Gebrauchtes'
Content.create key:'heading_queue1', body: '<p>Mehr 1</p>'
Content.create key:'heading_queue2', body: '<p>Mehr 2</p>'
Content.create key:'heading_queue3', body: '<p>Mehr 3</p>'
Content.create key:'heading_queue4', body: '<p>Mehr 4</p>'
Content.create key:'newsheader', body: '<p> Fairmondo rox! <a href="http://info.fairmondo.de">This is a link to the blog</a>!</p>'
