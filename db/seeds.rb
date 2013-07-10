#
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
Tinycms::Content.create key:'start-left', body:  '<h1>Willkommen!</h1><p>Dies ist die Beta-Testplattform f&uuml;r den Fairnopoly Online-Marktplatz.</p><p>Du kannst Dich hier gerne umschauen und frei herumspielen, solange Du untenstehende Datenschutzbestimmungen beachtest.</p><p>Die Funktionen sind noch eingeschr&auml;nkt und das Design muss noch weiter angepasst werden. Bitte teile uns alle Fehler, Ideen, Anregungen etc. mit, die Dir w&auml;hrend des Testens auffallen:</p><p><a href="http://info.fairnopoly.de/forum/?mingleforumaction=vforum&amp;g=2.0" target="_blank">Kommentieren &uuml;bers Forum</a></p><p>Oder per Email: bugs@fairnopoly.de</p><p>&nbsp;</p><p><strong>Datenschutzbestimmungen:</strong></p><p>1. Dies ist eine reine Testversion, Fairnopoly &uuml;bernimmt keine Garantie oder Haftung f&uuml;r auf dieser Testversion eingegebene Daten. Falls Du keine eigene Emailadresse f&uuml;r die Registrierung verwenden m&ouml;chtest, kannst Du einen der bei denen Logindaten verwenden:</p><p>Login: testerin@fairnopoly.de</p><p>Passwort: testerin</p><p>oder&nbsp;</p><p>Login: tester@fairnopoly.de</p><p>Passwort: tester &nbsp; &nbsp;</p><p>&nbsp;</p><p>2. Bitte lade nur Bilddateien hoch, zu deren Verwendung Du berechtigt bist. Fairnopoly &uuml;bernimmt keine Haftung f&uuml;r auf diese Testversion hochgeladene Inhalte.&nbsp; &nbsp; &nbsp;</p><p>&nbsp;</p><p>3.&nbsp;Nach Ablauf der Testphase (voraussichtlich am Freitag, 30.11.2012) werden s&auml;mtliche Daten gel&ouml;scht.</p>'
Tinycms::Content.create key:'start-video', body: '<p><iframe src="http://www.youtube.com/embed/8t6zRafs2J8?rel=0&amp;wmode=transparent&amp;" frameborder="0"></iframe></p>'
Tinycms::Content.create key:'banned', body: '<p>Da in dies eine nicht &ouml;ffentliche Beta ist muss der Account noch aktiviert werden.</p>'
Tinycms::Content.create key:'test_phase_greeting', body: '<div class="well"><strong>Herzlich willkommen zur Testversion vom Fairnopoly Online-Marktplatz!</strong> <br /><br /> Hier k&ouml;nnt Ihr bereits die wichtigsten Funktionen vorab ausprobieren. Bitte beachtet: Dies ist eine reine Testversion, an der noch viel geschraubt wird.Nach und nach wird von uns das restliche Design eingearbeitet, ein paar kleinere Probleme behoben, und weitere Hilfstexte eingepflegt. Von dem Funktionsumfang enspricht die Testversion aber der Pionierversion, mit der wir nach der Testphase und der Einarbeitung Eures Feedbacks starten! <br /><br /> <strong>Da es sich um eine Testversion handelt, k&ouml;nnen derzeit keine authentischen Artikelangebote eingestellt oder K&auml;ufe get&auml;tigt werden! Wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Ihr m&uuml;&szlig;t Euch auch nicht mit authentischen pers&ouml;nlichen Daten anmelden, au&szlig;er der Emailadresse, an welche die Registrierungsbest&auml;tigung verschickt wird. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht, dazu geh&ouml;rt auch die von Euch eingegebene Emailadresse. </strong> <br /><br /></div>'
Tinycms::Content.create key:'buy-ffps', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><a class="btn btn-primary btn-large pull-right" href="http://fairnopoly.startnext.de/">Sichere Dir Deinen Anteil</a></span><span style="font-family: arial, helvetica, sans-serif; font-size: small; line-height: 16px;">Bis zum 1.3.2013 ist es m&ouml;glich, sich &uuml;ber unsere Crowdfunding-Kampagne an Fairnopoly zu beteiligen: fairnopoly.startnext.de</span></p>'
Tinycms::Content.create key:'progress-ffps', body: '<div class="progress progress-landing"><div class="bar" style="height: 100%; width: 100%;">&nbsp;</div></div><p><a class="pull-right" href="http://fairnopoly.startnext.de">Anteile kaufen</a> 156.183 &euro; von 100.000 &euro; erreicht</p>'
Tinycms::Content.create key:'please-register', body: '<p><span style="font-family: arial, helvetica, sans-serif; font-size: small;"><span class="b" style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;"><strong style="margin: 0px; padding: 0px;">Bitte beachten:</strong></span><span style="line-height: 16px; margin: 0px; padding: 0px 0px 1px; cursor: auto;">&nbsp;&nbsp;</span><span style="line-height: 16px;">Dies ist eine reine Testversion, wir &uuml;bernehmen keinerlei Haftung oder Verantwortung f&uuml;r eingestellte Daten. Nach Ablauf des Tests werden alle Daten ohne Vorwarnung gel&ouml;scht.</span></span></p>'
