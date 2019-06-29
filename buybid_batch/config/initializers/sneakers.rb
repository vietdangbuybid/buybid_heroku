require 'sneakers'

Sneakers.configure  :heartbeat => 29,
                    :vhost => '/',
                    :amqp => 'amqp://guest:guest@localhost:5672',
                    #:amqp => "amqp://#{Rails.application.credentials.dig(:queue, :user)}:#{Rails.application.credentials.dig(:queue, :pass)}@#{Rails.application.credentials.dig(:queue, :host)}:#{Rails.application.credentials.dig(:queue, :port)}",
                    :exchange => 'buybid_jp_sneakers',
                    :exchange_type => :direct

Sneakers.logger.level = Logger::INFO
