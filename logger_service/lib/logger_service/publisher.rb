require 'json'
require 'time'
require 'bunny'

module LoggerService
  class Publisher
    def publish(type,  message, metadata = {})
      payload = {
        type: type,
        message: message,
        source: LoggerService.configuration.service_name,
        timestamp: Time.now.utc.iso8601,
        metadata: metadata
      }.to_json

      publish_to_queue(payload)
    end

    def publish_to_queue(payload)
      connection = Bunny.new(LoggerService.configuration.rabbitmq_url)
      connection.start

      channel = connection.create_channel
      queue = channel.queue(LoggerService.configuration.queue_name, durable: true)

      channel.default_exchange.publish(payload, routing_key: queue.name, persistent: true)

      connection.close

      rescue Bunny::TCPConnectionFailed, Bunny::AuthenticationFailureError => e
      puts "[LoggerService] ERROR: Could not connect to RabbitMQ. #{e.message}"

      rescue StandardError => e
      puts "[LoggerService] ERROR: An unexpected error occurred. #{e.message}"
    end


  end
end
