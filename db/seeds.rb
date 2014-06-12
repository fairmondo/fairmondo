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
  admin = FactoryGirl.create(:admin_user, :email => "admin@admin.com", :password => "password", :password_confirmation => "password", :trustcommunity => true, direct_debit: true)
end

user = User.find_by_email("user@user.com")
unless user
  user = FactoryGirl.create(:private_user, :email => "user@user.com", :password => "password", :password_confirmation => "password", direct_debit: true)
end

user_legal = User.find_by_email("le@le.com")
unless user_legal
  user_legal = FactoryGirl.create(:legal_entity, :paypal_data, :email => "le@le.com", :password => "password", :password_confirmation => "password", direct_debit: true)
end

require_relative 'fixtures/category_seed_data.rb'
include CategorySeedData
seed_categories

15.times do
  FactoryGirl.create :article, :without_image, :categories => [@categories.sample]
end
15.times do
  FactoryGirl.create :article, :without_image, :with_larger_quantity, :categories => [@categories.sample]
end
# Different articles to test transactions
FactoryGirl.create :article, :without_image, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_private_user, title: 'Tester By Private User', :categories => [@categories.sample]
FactoryGirl.create :article, :without_image, :with_larger_quantity, :with_all_transports,
                   :with_all_payments, :with_legal_entity,  title: 'Tester By Legal Entity', :categories => [@categories.sample]

# Fill Exhibitions
max_offset = Article.count - 4
[:queue1,:queue2,:queue3,:queue4,:old,:donation_articles,:book1,:book2,:book3,:book4,:book5,:book6,:book7,:book8].each do |queue|
  lib = FactoryGirl.create :library, :public, exhibition_name: queue
  lib.articles << Article.offset(rand(0..max_offset)).first(4)
end

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
# Startseite
Content.create key:'heading_features', body: '<p>TOLLE DINGE</p>'
Content.create key:'heading_features2', body: '<p>BÜCHERBOX</p>'
Content.create key:'heading_queue1', body: '<p>Mehr 1</p>'
Content.create key:'heading_queue2', body: '<p>Mehr 2</p>'
Content.create key:'heading_queue3', body: '<p>Mehr 3</p>'
Content.create key:'heading_queue4', body: '<p>Mehr 4</p>'
Content.create key:'cfk_box', body: '<p><iframe src="https://player.vimeo.com/video/83495049?badge=0&amp;byline=0&amp;title=0&amp;portrait=0" width="490" height="276" frameborder="0" allowfullscreen="1"></iframe></p><p>Mit Fairnopoly bauen wir eine konsequent faire Alternative zu den gro&szlig;en Online-Marktpl&auml;tzen auf. &Uuml;ber 1.900 Menschen haben bereits in unsere Genossenschaft investiert.<br />Mit 50 Euro kannst auch Du dabei sein:</p><p><a class="Button" href="http://info.fairnopoly.de/anteile-zeichnen/" target="_blank">Anteile zeichnen</a></p>'
Content.create key:'newsheader', body: '<p> Fairnopoly rox! <a href="http://info.fairnopoly.de">This is a link to the blog</a>!</p>'
