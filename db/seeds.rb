# encoding: utf-8
#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

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
  user = FactoryGirl.create(:private_user, :email => "user@user.com", :password => "password", :password_confirmation => "password")
end

user_legal = User.find_by_email("le@le.com")
unless user_legal
  user_legal = FactoryGirl.create(:legal_entity, :paypal_data, :email => "le@le.com", :password => "password", :password_confirmation => "password")
end

c1 = Category.create(:name => "Technik")
c2 = Category.create(:name => "Elektronik",:parent_id => c1.id)
c3 = Category.create(:name => "Fahrzeuge",:parent_id => c1.id)
c4 = Category.create(:name => "Medien")
c5 = Category.create(:name => "Bekleidung")
c6 = Category.create(:name => "Möbel & Haushalt")
c7 = Category.create(:name => "Freizeit & Sport")
c8 = Category.create(:name => "Lebensmittel")
c9 = Category.create(:name => "Gesundheit & Pflege")
c10 = Category.create(:name => "Kunst & Sammeln")
c11 = Category.create(:name => "Sonstiges")
c12 = Category.create(:name => "Kinder & Baby")
c13 = Category.create(:name => "Auto", :parent_id => c3.id)
c14 = Category.create(:name => "Motorrad", :parent_id => c3.id)
c15 = Category.create(:name => "weitere/sonstige Fahrzeuge", :parent_id => c3.id)
c16 = Category.create(:name => "Foto & Kamera", :parent_id => c2.id)
c17 = Category.create(:name => "TV & Video", :parent_id => c2.id)
c18 = Category.create(:name => "Audio & HiFi", :parent_id => c2.id)
c19 = Category.create(:name => "Pc, Netzwerk, Software", :parent_id => c2.id)
c20 = Category.create(:name => "Handy & Telefon", :parent_id => c2.id)
c21 = Category.create(:name => "Filme", :parent_id => c4.id)
c22 = Category.create(:name => "Musik", :parent_id => c4.id)
c23 = Category.create(:name => "Kasette", :parent_id => c21.id)
Category.create(:name => "DVD", :parent_id => c21.id)
Category.create(:name => "Blu-ray", :parent_id => c21.id)
Category.create(:name => "Vinyl", :parent_id => c22.id)
Category.create(:name => "CD", :parent_id => c22.id)
Category.create(:name => "weitere Formate", :parent_id => c22.id)
Category.create(:name => "Konsole", :parent_id => c23.id)
Category.create(:name => "Pc", :parent_id => c23.id)
Category.create(:name => "Mann", :parent_id => c5.id)
Category.create(:name => "Frau", :parent_id => c5.id)
Category.create(:name => "Accessoires", :parent_id => c5.id)
Category.create(:name => "Schuhe", :parent_id => c5.id)
Category.create(:name => "Möbel", :parent_id => c6.id)
Category.create(:name => "Elektrogroß- und Haushaltsgeräte", :parent_id => c6.id)
Category.create(:name => "Bekleidung", :parent_id => c12.id)
Category.create(:name => "Spielzeug", :parent_id => c12.id)
Category.create(:name => "Ausrüstung", :parent_id => c12.id)
Category.create(:name => "Reise", :parent_id => c7.id)
Category.create(:name => "Sport", :parent_id => c7.id)
Category.create(:name => "Essen", :parent_id => c8.id)
Category.create(:name => "Getränke", :parent_id => c8.id)
Category.create(:name => "Kaffee & Tee", :parent_id => c8.id)
Category.create(:name => "Körperpflege", :parent_id => c9.id)
Category.create(:name => "Kosmetik", :parent_id => c9.id)
Category.create(:name => "Sonstiges", :parent_id => c9.id)
Category.create(:name => "Duschen & Baden", :parent_id => c9.id)
Category.create(:name => "Antiquitäten & Kunst", :parent_id => c10.id)
Category.create(:name => "Sammeln & Seltenes", :parent_id => c10.id)
Category.create(:name => "Schmuck & Uhren", :parent_id => c10.id)
Category.create(:name => "Outdoor", :parent_id => c7.id)
Category.create(:name => "Textilien", :parent_id => c6.id)
Category.create(:name => "Süßigkeiten", :parent_id => c8.id)
Category.create(:name => "Schuhe", :parent_id => c12.id)
Category.create(:name => "Bücher", :parent_id => c4.id)

15.times do
  FactoryGirl.create(:article, :without_image, :categories_and_ancestors => [c1.id])
end
15.times do
  FactoryGirl.create(:article, :without_image, :with_larger_quantity, :categories_and_ancestors => [c2.id,c3.id])
end
# Different articles to test transactions
FactoryGirl.create :article, :without_image, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_private_user, title: 'Tester By Private User', :categories_and_ancestors => [c4.id,c5.id]
FactoryGirl.create :article, :without_image, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_legal_entity,  title: 'Tester By Legal Entity', :categories_and_ancestors => [c6.id,c7.id]


# TinyCMS pages
Content.create key:'start-left', body:  '<h1>Willkommen!</h1><p>Dies ist die Beta-Testplattform f&uuml;r den Fairnopoly Online-Marktplatz.</p><p>Du kannst Dich hier gerne umschauen und frei herumspielen, solange Du untenstehende Datenschutzbestimmungen beachtest.</p><p>Die Funktionen sind noch eingeschr&auml;nkt und das Design muss noch weiter angepasst werden. Bitte teile uns alle Fehler, Ideen, Anregungen etc. mit, die Dir w&auml;hrend des Testens auffallen:</p><p><a href="http://info.fairnopoly.de/forum/?mingleforumaction=vforum&amp;g=2.0" target="_blank">Kommentieren &uuml;bers Forum</a></p><p>Oder per Email: bugs@fairnopoly.de</p><p>&nbsp;</p><p><strong>Datenschutzbestimmungen:</strong></p><p>1. Dies ist eine reine Testversion, Fairnopoly &uuml;bernimmt keine Garantie oder Haftung f&uuml;r auf dieser Testversion eingegebene Daten. Falls Du keine eigene Emailadresse f&uuml;r die Registrierung verwenden m&ouml;chtest, kannst Du einen der bei denen Logindaten verwenden:</p><p>Login: testerin@fairnopoly.de</p><p>Passwort: testerin</p><p>oder&nbsp;</p><p>Login: tester@fairnopoly.de</p><p>Passwort: tester &nbsp; &nbsp;</p><p>&nbsp;</p><p>2. Bitte lade nur Bilddateien hoch, zu deren Verwendung Du berechtigt bist. Fairnopoly &uuml;bernimmt keine Haftung f&uuml;r auf diese Testversion hochgeladene Inhalte.&nbsp; &nbsp; &nbsp;</p><p>&nbsp;</p><p>3.&nbsp;Nach Ablauf der Testphase (voraussichtlich am Freitag, 30.11.2012) werden s&auml;mtliche Daten gel&ouml;scht.</p>'
Content.create key:'start-video', body: '<p><iframe src="http://www.youtube.com/embed/8t6zRafs2J8?rel=0&amp;wmode=transparent&amp;" frameborder="0"></iframe></p>'
Content.create key:'banned', body: '<p>Da in dies eine nicht &ouml;ffentliche Beta ist muss der Account noch aktiviert werden.</p>'
Content.create key:'test_phase_greeting', body: '<div class="well"><strong>Herzlich willkommen zur Testversion vom Fairnopoly Online-Marktplatz!</strong> <br /><br /> Hier k&ouml;nnt Ihr bereits die wichtigsten Funktionen vorab ausprobieren. Bitte beachtet: Dies ist eine reine Testversion, an der noch viel geschraubt wird.Nach und nach wird von uns das restliche Design eingearbeitet, ein paar kleinere Probleme behoben, und weitere Hilfstexte eingepflegt. Von dem Funktionsumfang enspricht die Testversion aber der Pionierversion, mit der wir nach der Testphase und der Einarbeitung Eures Feedbacks starten! <br /><br /> <strong>Da es sich um eine Testversion handelt, k&ouml;nnen derzeit keine authentischen Artikelangebote eingestellt oder K&auml;ufe get&auml;tigt werden! Wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Ihr m&uuml;&szlig;t Euch auch nicht mit authentischen pers&ouml;nlichen Daten anmelden, au&szlig;er der Emailadresse, an welche die Registrierungsbest&auml;tigung verschickt wird. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht, dazu geh&ouml;rt auch die von Euch eingegebene Emailadresse. </strong> <br /><br /></div>'
Content.create key:'buy-ffps', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><a class="btn btn-primary btn-large pull-right" href="http://fairnopoly.startnext.de/">Sichere Dir Deinen Anteil</a></span><span style="font-family: arial, helvetica, sans-serif; font-size: small; line-height: 16px;">Bis zum 1.3.2013 ist es m&ouml;glich, sich &uuml;ber unsere Crowdfunding-Kampagne an Fairnopoly zu beteiligen: fairnopoly.startnext.de</span></p>'
Content.create key:'progress-ffps', body: '<div class="progress progress-landing"><div class="bar" style="height: 100%; width: 100%;">&nbsp;</div></div><p><a class="pull-right" href="http://fairnopoly.startnext.de">Anteile kaufen</a> 156.183 &euro; von 100.000 &euro; erreicht</p>'
Content.create key:'please-register', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><span class="b" style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;"><strong style="margin: 0px; padding: 0px;">Bitte beachten:</strong></span><span style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;">&nbsp;&nbsp;</span><span style="line-height: 16px;">Dies ist eine reine Testversion, wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht.</span></span></p>'
Content.create key:'about_us', body: '<h1>About</h1><p>Dummy Site</p>'
# Fuer den Genossenschaftsanteilfortschrittsbalken
Content.create key:'monatsziel', body: '<p>50000</p>'
Content.create key:'monatsanteile', body: '<p>2150</p>'
Content.create key:'bisherige_einlagen', body: '<p>288550</p>'
