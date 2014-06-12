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
        logger = Logger.new("#{Rails.root}/log/rewrite.log").logger
        @rules = RewriteConfig.list.map do |rule|
          Rule.new(rule[:method], rule[:from], rule[:to], {if: Proc.new do |rack_env|
            if rack_env['SERVER_NAME'] != "www.fairnopoly.de"
              logger.info('-----------------------')
              logger.info('Rack:')
              logger.info(rack_env)
              logger.info('Rule:')
              logger.info(rule)
              logger.info('Matches:')
              rack_env['SERVER_NAME'] =~ rule[:if] ? logger.info('yes') : logger.info('no')
            end
            rack_env['SERVER_NAME'] =~ rule[:if]
          end})
        end
      end
    end
  end
end
