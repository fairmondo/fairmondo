#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class HumanLanguageList < Array
  # Make list human readable
  # @return String
  def concatenate
    output = ''
    prelast_index = count - 2

    self.each_with_index do |element, index|
      output += element
      output += I18n.t('human_article_list.separator') if count > 2 && index < prelast_index
      output += I18n.t('human_article_list.and') if count > 1 && index == prelast_index
    end

    output
  end
end
