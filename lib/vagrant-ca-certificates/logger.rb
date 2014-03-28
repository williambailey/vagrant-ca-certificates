require 'log4r'

module VagrantPlugins
  module CaCertificates
    # @return [Log4r::Logger] the logger instance for this plugin
    def self.logger
      @logger ||= Log4r::Logger.new('vagrant::ca-certificates')
    end
  end
end