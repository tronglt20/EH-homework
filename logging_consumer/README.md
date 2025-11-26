# Event Logging Service

A centralized service for aggregating and querying logs from distributed services.

## Prerequisites
- Ruby 3.2+
- MongoDB
- RabbitMQ

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Configure environment variables (optional, defaults provided):
    - `MONGODB_URI`: MongoDB connection string
    - `RABBITMQ_URL`: RabbitMQ connection URL
    - `LOG_QUEUE_NAME`: Name of the queue to consume from

## Running the Service

### 1. Start the Consumer Worker
The worker consumes messages from RabbitMQ and saves them to MongoDB.
```bash
bundle exec rake consumer:start
```

### 2. Start the API Server
The API server provides endpoints to query logs.
```bash
rails server
```

## test update 222
