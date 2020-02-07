#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.
Money.locale_backend = :i18n

MoneyRails.configure do |config|

  # To set the default currency
  #
  config.default_currency = :eur
  config.no_cents_if_whole = false

  # Set default bank object
  #
  # Example:
  # config.default_bank = EuCentralBank.new

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  config.include_validations = true

  # Register a custom currency
  #
  # Example:
  # config.register_currency = {
  #   :priority            => 1,
  #   :iso_code            => "EU4",
  #   :name                => "Euro with subunit of 4 digits",
  #   :symbol              => "€",
  #   :symbol_first        => true,
  #   :subunit             => "Subcent",
  #   :subunit_to_unit     => 10000,
  #   :thousands_separator => ".",
  #   :decimal_mark        => ","
  # }

end

Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

# Monkey Patch
# Url: https://github.com/RubyMoney/money-rails/blob/master/lib/money-rails/helpers/action_view_extension.rb
# Patch to have the symbol after the amount and always have 2 digits after the seperator
module MoneyRails
  module ActionViewExtension
    def humanized_money_with_symbol(value)
      humanized_money(value, format: '%n %u', symbol: true, no_cents_if_whole: false)
    end
  end
end
