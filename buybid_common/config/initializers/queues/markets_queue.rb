module BuybidCommon::Queues
  class MarketsQueue
    MARTKET_PRODUCT_CARDS='martket_product_cards'
    MARTKET_PRODUCT_DETAIL='martket_product_detail'

    class << self
      def hostname
        "#{Rails.application.credentials.dig(:queue, :host)}:#{Rails.application.credentials.dig(:queue, :port)}"
      end
      
      def client
        @bunny ||=
          begin
            bunny = Bunny.new({
              host: hostname, 
              user: Rails.application.credentials.dig(:queue, :user), 
              pass: Rails.application.credentials.dig(:queue, :pass)
            }.compact)
            bunny.start
            bunny
          end
      end

      def channel
        @channel ||= client.create_channel
      end

      def fetch_queue(queue_name, options = {})
        channel.queue(queue_name, options)
      end

      def fetch_exchange(exchange_type, exchange_name = nil, options = {})
        case exchange_type
        when :default
          channel.default_exchange
        when :fanout
          channel.fanout(exchange_name)
        when :direct
          channel.direct(exchange_name)
        when :topic
          channel.topic(exchange_name, options)
        when :headers
          channel.headers(exchange_name)
        end
      end
    end
  end
end
