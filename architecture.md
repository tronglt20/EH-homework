# Event Logging Service - Planning Document

## Overview
Design and implement a distributed event logging system with two main components:
1. **LoggerService** - A Ruby gem library that services can install to push log events to a queue
2. **LoggingConsumer** - A worker service that consumes events from the queue, persists them to a database, and provides a query API

## Architecture Overview

### High-Level Design

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Service A  │     │  Service B  │     │  Service C  │
│             │     │             │     │             │
│ LoggerService│    │ LoggerService│    │ LoggerService│
│    (gem)    │     │    (gem)    │     │    (gem)    │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       └───────────────────┴───────────────────┘
                          │
                          │ Push events
                          ▼
                   ┌──────────────┐
                   │  RabbitMQ    │
                   │   (Queue)    │
                   └──────┬───────┘
                          │
                          │ Pull events
                          ▼
              ┌───────────────────────┐
              │ LoggingConsumer       │
              │  (Worker + API)       │
              │                       │
              │  - Consume from queue │
              │  - Save to MongoDB    │
              │  - Query API          │
              └───────────────────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │   MongoDB    │
                   │  (Database)  │
                   └──────────────┘
```

### Components

#### 1. LoggerService (Gem Library)
- **Purpose**: Lightweight gem that services can install
- **Functionality**:
    - Expose simple logging function/method
    - Push log events to RabbitMQ queue
    - Handle connection management
    - Provide configuration options
- **Usage**: Services A, B, C install this gem and use it to log events

#### 2. LoggingConsumer (Worker Service)
- **Purpose**: Centralized service for log persistence and querying
- **Functionality**:
    - Consume events from RabbitMQ queue
    - Persist logs to MongoDB
    - Provide REST API for querying logs
    - Handle errors and retries

### Technology Stack

#### LoggerService (Gem)
- **Language**: Ruby
- **Dependencies**:
    - `bunny` (RabbitMQ client)
    - `json` (for message serialization)

#### LoggingConsumer (Rails App)
- **Language**: Ruby
- **Framework**: Rails
- **Database**: MongoDB (using Mongoid or Mongo gem)
- **Queue**: RabbitMQ (using `bunny` for consumer)
- **API**: RESTful Rails API
