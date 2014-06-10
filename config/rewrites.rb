# encoding: utf-8
class RewriteConfig
  def self.list
    [{
      method: :r301,
      from: /(.*)/,
      to: '/categories/buecher',
      if: /b(ü|ue)cher\./i
    },{
      method: :r301,
      from: /(.*)/,
      to: '/categories/sonstiges',
      if: /sonsties\./i
    }]
  end
end

module Rack
  class Rewrite
    class FairnopolyRuleSet
      attr_reader :rules

      def initialize(options)
        @rules = RewriteConfig.list.map { |rule|
          Rule.new(rule[:method], rule[:from], rule[:to], {if: Proc.new {|rack_env| rack_env['SERVER_NAME'] =~ rule[:if]}})
        }
      end
    end
  end
end
