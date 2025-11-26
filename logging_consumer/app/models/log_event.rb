class LogEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :source, type: String
  field :timestamp, type: DateTime
  field :metadata, type: Hash

end
