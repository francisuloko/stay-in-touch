Warden::JWTAuth.configure do |config|
  config.secret = Rails.application.credentials.devise[:jwt_secret_key]
  config.dispatch_requests = [
                               ['POST', %r{^/api/login$}],
                               ['POST', %r{^/api/login.json$}]
                             ]
  config.revocation_requests = [
                                 ['DELETE', %r{^/api/logout$}],
                                 ['DELETE', %r{^/api/logout.json$}]
                               ]
end
