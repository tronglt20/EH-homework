# db/seeds.rb
puts "Cleaning old log events..."
LogEvent.delete_all

puts "Creating sample log events..."
events = [
  {
    message: "User successfully logged in",
    source: "user-service",
    timestamp: Time.now - 2.minutes,
    metadata: { user_id: 101, ip_address: "192.168.1.10", session_id: "abc123xyz" }
  },
  {
    message: "Order #54321 has been created",
    source: "order-service",
    timestamp: Time.now - 5.minutes,
    metadata: { order_id: 54321, user_id: 101, total_amount: 250.75, currency: "USD" }
  },
  {
    message: "Payment failed for order #54322",
    source: "payment-service",
    timestamp: Time.now - 10.minutes,
    metadata: { order_id: 54322, error_code: "CARD_DECLINED", gateway: "Stripe" }
  },
  {
    message: "Database query is slow",
    source: "api-gateway",
    timestamp: Time.now - 15.minutes,
    metadata: { query: "SELECT * FROM products WHERE...", duration_ms: 1250 }
  },
  {
    message: "New user registration",
    source: "user-service",
    timestamp: Time.now - 1.hour,
    metadata: { user_id: 102, email: "new.user@example.com", referral_code: nil }
  },
  {
    message: "Product inventory updated",
    source: "inventory-service",
    timestamp: Time.now - 2.hours,
    metadata: { product_id: "PROD-987", old_stock: 50, new_stock: 75, updated_by: "admin_bot" }
  },
  {
    message: "Failed to send notification email",
    source: "notification-service",
    timestamp: Time.now - 3.hours,
    metadata: { recipient: "customer@example.com", template: "welcome_email", error: "SMTP connection timeout" }
  }
]

LogEvent.create!(events)
puts "Successfully created #{LogEvent.count} log events."