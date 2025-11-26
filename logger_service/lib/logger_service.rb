require_relative "logger_service/version"
require_relative "logger_service/configuration"
require_relative "logger_service/publisher"

require "bunny"
require "json"

module LoggerService
  class Error < StandardError; end
  class << self
    def publisher
      @publisher ||= Publisher.new
    end

    def log(type, message, metadata = {})
      publisher.publish(type, message, metadata)
    end

    def info(message, metadata = {})
      log('info', message, metadata)
    end

    def error(message, metadata = {})
      log('error', message, metadata)
    end

    def warn(message, metadata = {})
      log('warn', message, metadata)
    end

    def debug(message, metadata = {})
      log('debug', message, metadata)
    end
  end
end
