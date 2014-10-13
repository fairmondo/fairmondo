# encoding: utf-8
class RewriteConfig
  def self.list
    [{
      method: :r301,
      from: '/warum',
      to: 'https://info.fairmondo.de/ein-neuer-name-warum/',
      if: Proc.new { |rack_env| true}
    },{
      method: :r301,
      from: /(.*)/,
      to: 'https://www.fairmondo.de/categories/bucher',
      if: Proc.new { |rack_env| rack_env['SERVER_NAME'] =~ /b(ü|u|ue)cher\./i }
    },{
      method: :r301,
      from: /(.*)/,
      to: 'https://www.fairmondo.de/categories/weitere-abf793c9-d94b-423c-947d-0d8cb7bbe3b9',
      if: Proc.new { |rack_env| rack_env['SERVER_NAME'] =~ /weitere\./i }
    },{
      method: :r301,
      from: %r{.*},
      to: 'https://www.fairmondo.de$&',
      if:  Proc.new { |rack_env| rack_env['SERVER_NAME'] != 'www.fairmondo.de' }
    }]
  end
end

module Rack
  class Rewrite
    class FairmondoRuleSet
      attr_reader :rules

      def initialize(options)
        @rules = RewriteConfig.list.map do |rule|
          Rule.new(rule[:method], rule[:from], rule[:to], {if: rule[:if] })
        end
      end
    end
  end
end
