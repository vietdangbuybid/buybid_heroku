require 'gruf'

Gruf.configure do |c|
  c.server_binding_url = "#{Rails.application.credentials.dig(:rpc, :host)}:#{Rails.application.credentials.dig(:rpc, :port)}"
end
