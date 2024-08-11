Clearance.configure do |config|
  config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
  config.allow_sign_up = false
  config.signed_cookie = true
  config.routes = false
end
