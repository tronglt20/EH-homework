# LoggerService

A simple event logging service gem that pushes logs to RabbitMQ.

## Installation 

Add this line to your application's Gemfile:

```ruby
gem 'logger_service'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install logger_service

## Usage

### Configuration

Configure the gem in an initializer or before use:

```ruby
LoggerService.configure do |config|
  config.rabbitmq_url = ENV['RABBITMQ_URL'] || 'amqp://localhost:5672'
  config.queue_name = 'log_events'
  config.service_name = 'my_service'
end
```

### Logging

```ruby
# Simple logging
LoggerService.log('info', 'User logged in', { user_id: 123 })

# Convenience methods
LoggerService.info('User logged in', { user_id: 123 })
LoggerService.error('Failed to connect', { error: 'timeout' })
LoggerService.warn('High memory usage', { memory: '85%' })
LoggerService.debug('Processing request', { request_id: 'abc123' })
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## test update
