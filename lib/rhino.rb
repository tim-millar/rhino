require 'rhino/cli'
require 'rhino/logger'
require 'rhino/version'

module Rhino
  def self.logger
    @logger ||= Rhino::Logger.new
  end
end
