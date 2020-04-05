# frozen_string_literal: true
Devise.setup do |config|
  config.mailer_sender = ENV['MAILER_SENDER']

  require 'devise/orm/active_record'

  config.authentication_keys = [:username]
  config.case_insensitive_keys = [:username]
  config.strip_whitespace_keys = [:username]
  config.reset_password_keys = [ :username ]
  config.confirmation_keys = [ :username ]
  config.unlock_keys = [:username]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/


  config.reset_password_within = 6.months

  config.sign_out_via = :delete

  config.jwt do |jwt|
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
    jwt.dispatch_requests = [
        ['POST', %r{^/login$}]
    ]
    jwt.revocation_requests = [
        ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 1.year
  end
end
