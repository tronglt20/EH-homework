module LoggerService
  class Configuration
    attr_accessor :service_name, :rabbitmq_url, :queue_name
    def initialize
      @service_name = 'unknown_service'
      @rabbitmq_url = 'amqp://localhost:5672'
      @queue_name = 'log_events'
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
