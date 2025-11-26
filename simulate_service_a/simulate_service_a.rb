require 'logger_service'

LoggerService.configure do |config|
  config.service_name = 'simulate_service_a'
end

LoggerService.info('user.registered', {
  user_id: 999,
  email: 'service.a.user@example.com',
  ip_address: '10.0.0.5'
})

LoggerService.error('user.login.success', {
  user_id: 999,
  session_id: 'sess_xyz_123'
})

puts "All events from Service A have been pushed to the queue."