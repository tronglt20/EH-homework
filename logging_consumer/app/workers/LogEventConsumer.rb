require 'bunny'
require 'json'

class LogEventConsumer
  def initialize
    @connection = nil
    @channel = nil
    @queue = nil
  end

  def self.start
    puts "[LogEventConsumer] Starting consumer"
    connect
    subscribe
  rescue Interrupt => _
    puts "[LogEventConsumer] Stopping consumer..."
    @channel.close if @channel
    @connection.close if @connection
  end

  def self.connect
    config = Rails.application.config_for("rabbitmq")
    @connection = Bunny.new(config[:url])
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue(config[:queue_name], durable: true)
  end

  def self.subscribe
    @queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
      process_message(body)
      @channel.ack(delivery_info.delivery_tag)
    end
  end

  def self.process_message(body)
    begin
      data = JSON.parse(body)
      LogEvent.create!(
        message: data['message'],
        source: data['source'],
        timestamp: data['timestamp'],
        metadata: data['metadata']
      )
      puts "[LogEventConsumer] Successfully created message"
    rescue JSON::ParserError => e
      puts "[LogEventConsumer] [!] Invalid JSON: #{e.message}"
    rescue StandardError => e
      puts "[LogEventConsumer] [!] Error processing message: #{e.message}"
    end
  end
end