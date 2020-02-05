#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :mass_upload_article do
    association :mass_upload
    action { 'create' }
    row_index { 1 }
    article_csv do
      ';;Richard Fischer: Tabellenbuch Kraftfahrzeugtechnik mit Formelsammlung '\
      '(Taschenbuch, EAN 9783808521366);309;new;;<h3>Tabellenbuch Kraftfahrzeugtechnik mit '\
      'Formelsammlung</h3><p>von <b>Richard Fischer</b></p><p>Deutsch, September 2008, Europa '\
      'Lehrmittel Verlag, Taschenbuch, ISBN 3808521368, EAN 9783808521366</p><p><b>Beschreibung'\
      '</b></p><p><br \\>Das Standardwerk zur Lösung von kraftfahrzeugtechnischen '\
      'Problemstellungen und Aufgaben in der Arbeitsplanung, im Technologiepraktikum und im '\
      'Techniklabor.<br \\>Alle wichtigen Formeln, häufig mit Beispielaufgaben, Diagrammen und '\
      'technischen Werten der Kfz-Technik.<br \\>Mathematik, technische Formeln, Grundkenntnisse '\
      'der Metalltechnik, Fachkenntnisse Kfz-Technik, Werkstoffkunde, Technisches Zeichnen, '\
      'Normteile.<br \\>Anschauliche und übersichtliche Darstellung.</p>'\
      ';100;3120;;;7;http://media.ecobookstore.de/366/EAN_9783808521366.jpg;;;true;Postversand;0;9'\
      ';;;;;1-3;;false;true;;true;;true;;false;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;9783808521366;'\
      'LIB-9783808521366;update\n'
    end

    factory :update_mass_upload_article do
      action { 'update' }
    end
  end
end
