# Event Logging Service

## Overview
A distributed event logging system designed to decouple log generation from persistence. It consists of a Ruby gem for services to emit logs and a centralized worker service that consumes logs from a queue and persists them to MongoDB.

## Architecture

### High-Level Design

```
┌─────────────┐     ┌─────────────┐
│  Service A  │     │  Service B  │
│ (Simulator) │     │             │
│ LoggerService│    │ LoggerService│
│    (gem)    │     │    (gem)    │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │ Push events       │
       ▼                   ▼
┌─────────────────────────────────────┐
│             RabbitMQ                │
│             (Queue)                 │
└──────────────────┬──────────────────┘
                   │
                   │ Pull events
                   ▼
┌─────────────────────────────────────┐
│         LoggingConsumer             │
│        (Worker + API)               │
│ - Consumes from RabbitMQ            │
│ - Persists to MongoDB               │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│             MongoDB                 │
│            (Database)               │
└─────────────────────────────────────┘
```


### Technology Choices

#### RabbitMQ
Choosing RabbitMQ as the message broker because:
- **Development Efficiency**: It is open-source, free to use, and easy to set up, making it ideal for the development phase.

#### MongoDB
Choosing MongoDB as the database because:
- **Flexibility**: Its schema-less nature allows us to store log events with varying structures.
- **Read Performance**: It excels at read-heavy workloads where data is frequently accessed

### Docker Compose Infrastructure
 
The system is containerized using Docker Compose with the following services:

- **rabbitmq**: Message broker for queuing log events.
- **mongodb**: Database for storing log events.
- **web**: The Rails application serving the API (running `rails server`).
- **worker**: The background worker consuming messages from RabbitMQ (running `rake consumer:start`).

## Getting Started

### Prerequisites
- Docker and Docker Compose

### Running the System

1. **Build and start the services:**
   ```bash
   docker-compose up --build
   ```

2. **Verify the services are running:**
   - RabbitMQ Management: [http://localhost:15672](http://localhost:15672) (User: `guest`, Pass: `guest`)
   - Rails API: [http://localhost:3000](http://localhost:3000)

## Testing with Simulator

To verify the system is working, you can run the `simulate_service_a.rb` script. This script uses the `logger_service` gem to push sample events to the RabbitMQ queue.

### Prerequisites for Simulator
- Ruby (>= 3.2.0)
- Bundler

### Running the Simulator

1. **Navigate to the `logger_service` directory:**
   ```bash
   cd logger_service
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Run the simulator script:**
   We run the script using `bundle exec` to ensure all gem dependencies (like `bunny`) are available, and include the `lib` directory in the load path so it can find the `logger_service` code.

   ```bash
   bundle exec ruby -I lib ../simulate_service_a/simulate_service_a.rb
   ```

4. **Verify the logs:**
   - Check the output of the **worker** service in your Docker Compose terminal. You should see logs indicating that events were processed.
   - Connect to MongoDB to verify the documents were created.

## Project Structure

- `logger_service/`: The Ruby gem used by client services.
- `logging_consumer/`: The Rails application (Worker + API).
- `simulate_service_a/`: A script to simulate a client service sending logs.
- `docker-compose.yml`: Docker Compose configuration.

## Future Enhancements

### Scaling with Multiple Consumers
To handle high traffic volumes and improve write performance, we can scale the system by running multiple instances of the `worker` service.
- **Horizontal Scaling**: RabbitMQ supports multiple consumers on the same queue. By adding more `worker` containers, we can process messages in parallel, significantly increasing the throughput of log ingestion.
- **Load Balancing**: RabbitMQ automatically distributes messages among available consumers, ensuring an even load distribution.

### Database Read/Write Separation
To further optimize performance, we can separate the database into read and write operations:
- **Write Optimization**: The primary MongoDB instance can be dedicated to writing logs from the consumers.
- **Read Optimization**: We can use MongoDB replicas for read operations (querying logs via the API). This offloads the read traffic from the primary node, ensuring that heavy query loads do not impact the write performance of the logging system.
