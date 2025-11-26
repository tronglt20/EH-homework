namespace :consumer do
  task start: :environment do
    require_relative '../../app/workers/LogEventConsumer'
    LogEventConsumer.start
  end
end