# encoding: utf-8
class RewriteConfig
  def self.list
    [{
      method: :r301,
      from: /(.*)/,
      to: '/categories/bucher',
      if: /b(ü|u|ue)cher\./i
    },{
      method: :r301,
      from: /(.*)/,
      to: '/categories/weitere',
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
          Rule.new(rule[:method], rule[:from], rule[:to], {if: Proc.new {|rack_env| Rails.logger.info('-----------------------'); Rails.logger.info('Rack:'); Rails.logger.info(rack_env); Rails.logger.info('Rule:'); Rails.logger.info(rule); Rails.logger.info('Matches:'); rack_env['SERVER_NAME'] =~ rule[:if] ? Rails.logger.info('yes') : Rails.logger.info('no'); rack_env['SERVER_NAME'] =~ rule[:if]}})
        end
      end
    end
  end
end
