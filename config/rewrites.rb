# encoding: utf-8
class RewriteConfig
  def self.list
    [{
      method: :r301,
      from: /(.*)/,
      to: 'https://www.fairnopoly.de/categories/bucher',
      if: /b(ü|u|ue)cher\./i
    },{
      method: :r301,
      from: /(.*)/,
      to: 'https://www.fairnopoly.de/categories/weitere',
      if: /weitere\./i
    }]
  end
end

module Rack
  class Rewrite
    class FairnopolyRuleSet
      attr_reader :rules

      def initialize(options)
        @rules = RewriteConfig.list.map do |rule|
          Rule.new(rule[:method], rule[:from], rule[:to], {if: Proc.new do |rack_env|
            rack_env['SERVER_NAME'] =~ rule[:if]
          end})
        end
      end
    end
  end
end
